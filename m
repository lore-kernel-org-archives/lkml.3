Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaEEFtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:49:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:35186 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaEEFti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:49:38 -0400
X-Nat-Received: from [202.181.97.72]:30290 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1399268970.16841
To: selinux@tycho.nsa.gov
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH (for 3.15) 0/5] Fix cross rename race window for LSM.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <53523D16.9020101@gmail.com>
	<201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
	<CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
	<201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
In-Reply-To: <201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
Message-Id: <201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 5 May 2014 14:49:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 05052014 #7845953, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello SELinux people, may I have your response?

Miklos Szeredi posted v3 of cross rename patchset at
http://marc.info/?l=linux-fsdevel&m=138921924707564&w=4 . In that thread,
I questioned him whether he already explained this proposal to LSM people.
He answered no and explained me what renameat2() does. I asked him to get
confirmation from LSM people before he merges this change to linux-next.git
tree, and he answered that patch 07/11 already does what LSM people need. But
I commented that TOMOYO wants to avoid re-calculation of pathnames and posted
a patch at http://marc.info/?l=linux-security-module&m=138970469226106&w=4 and
John Johansen commented that the changes in AppArmor directory looks OK and
John would re-factor AppArmor to avoid re-calculation in the future. Therefore,
I posted a patch for SELinux/SMACK/Capability at
http://marc.info/?l=linux-fsdevel&m=138973289404450&w=4 but Miklos responded
that he doesn't want to include my patch which temporarily breaks TOMOYO and
AppArmor. Instead, he asked me to post a complete patch right after his cross
rename patchset goes in. Thus, I was waiting for his cross rename patchset to
arrive at linux-next.git tree.

By the day Linux 3.14 was released, Miklos's cross rename patchset did not
arrive at linux-next.git tree. Therefore, I assumed that the cross rename
patchset will not go to Linux 3.15-rc1. However, the patchset committed after
Linux 3.14 release (commit da1ce067 "vfs: add cross-rename") directly went to
linux.git tree without letting it known to LSM people and the merge window for
Linux 3.15 was closed. Then, I noticed that renameat2() will be in 3.15 at
http://marc.info/?l=linux-fsdevel&m=139789855823422&w=2 .

At first, I assumed that renameat2() is not callable as of 3.15 because I
couldn't find "#define __NR_renameat2" line. But Miklos told me that
renameat2() will be callable as of 3.15 because x86 automatically generates
__NR_renameat2 entries. I realized that TOMOYO and AppArmor now have a race
window (a kind of regression) introduced by the cross rename functionality, and
I re-posted my patch as a patchset in this thread. I can approve the changes in
TOMOYO directory and John Johansen already gave me a sort of Reviewed-by:
response to the changes in AppArmor directory in January's thread. In this
thread, Casey Schaufler gave me an Acked-by: response to the changes in SMACK
directory, but so far I have gotten no response from SELinux people.

Would somebody in SELinux community please respond to the changes in SELinux
directory so that we can merge this race window fix patchset before 3.15-final?

Regards.

Tetsuo Handa wrote:
> James, would you send this patchset to Linus?
> This patchset is expected to go to 3.15 because this is a kind of regression fix.
> 
> Tetsuo Handa wrote:
> > Miklos Szeredi wrote:
> > > On Sat, Apr 19, 2014 at 2:08 PM, Tetsuo Handa
> > > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > > Michael Kerrisk (man-pages) wrote:
> > > >> Now that renameat2() is in 3.15, I've taken these changes.
> > > >
> > > > What!? I didn't know renameat2() goes to 3.15.
> > > >
> > > > But I assume that renameat2() is not accessible in 3.15, for I can see
> > > > "asmlinkage long sys_renameat2(" but don't see "#define __NR_renameat2".
> > > 
> > > x86 automatically generates __NR_foo entries and syscall tables from
> > > arch/x86/syscalls/syscall_*.tbl, which is why you don't find an
> > > explicit definition in the git tree.
> > > 
> > > Thanks,
> > > Miklos
> > > 
> > 
> > Oh, I see. Then, I must submit patches for fixing a race window
> > caused by commit da1ce067 "vfs: add cross-rename".
> > 
> > Regards.
> > 
> 
