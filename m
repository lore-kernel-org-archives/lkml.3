Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaHOThy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:37:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaHOThw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:37:52 -0400
Date: Fri, 15 Aug 2014 19:37:47 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Kenton Varda <kenton@sandstorm.io>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fs: Remove implicit nodev for new mounts in non-root
 userns
Message-ID: <20140815193746.GE11476@ubuntumail>
References: <CALCETrWT_p1-5nkiAjWoeta19fkO3rDiJe9_mhRVqF8x1zXv2A@mail.gmail.com>
 <2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net>
 <20140815190552.GA11476@ubuntumail>
 <CALCETrVKq1Fxnsd9jKDi5_fcKfCJxBZ1w-zGXD3FR-pF-jLsmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVKq1Fxnsd9jKDi5_fcKfCJxBZ1w-zGXD3FR-pF-jLsmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Fri, Aug 15, 2014 at 12:05 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > Quoting Andy Lutomirski (luto@amacapital.net):
> >> Currently, creating a new mount (as opposed to bindmount) in a
> >> non-root userns will implicitly set nodev unless the fs is devpts.
> >> Something like this will be necessary for file systems that allow
> >> the mounter to create device nodes without using mknod (e.g. FUSE
> >> if/when that is allowed), but none of the currently allowed
> >> filesystems do this.
> >
> > Hi,
> >
> > Sorry, I'm probably thinking stupidly, but I don't see this restriction
> > being the case
> >
> > serge@sl:~$ mount | grep tmp
> > [...]
> > tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
> > serge@sl:~$ sudo mknod /run/kvm c 10 232
> > [sudo] password for serge:
> > serge@sl:~$ echo $?
> > 0
> > serge@sl:~$ ls -l /run/kvm
> > crw-r--r-- 1 root root 10, 232 Aug 15 14:04 /run/kvm
> >
> > But you seem to be saying I shouldn't be allowed to create a device inside
> > a tmpfs.  What am I overlooking?
> 
> I assume you're in the root userns.  This patch is unnecessary, and
> has no effect, if you're in the root userns.

Right, but I thought you were justifying adding FS_USERNS_DEV_MOUNT by saying
that you cannot mknod in those filesystems.  But I see you actually said
"without using mknod".  I guess I don't understand that caveat.

-serge
