Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaD3Hsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:48:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55557 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaD3Hsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:48:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>, Marian Marinov <mm@1h.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
References: <535FADDA.2070803@1h.com> <20140429183534.GB19325@thunk.org>
	<20140429185251.GA27969@ubuntumail> <53601E5B.5050004@1h.com>
	<20140429220234.GC28410@ubuntumail> <536026B3.1020905@1h.com>
	<20140429222913.GD28410@ubuntumail> <53602B84.1020304@mit.edu>
	<20140430001641.GA28969@ubuntumail> <20140430003236.GA6472@thunk.org>
Date: Wed, 30 Apr 2014 00:48:01 -0700
In-Reply-To: <20140430003236.GA6472@thunk.org> (Theodore Ts'o's message of
	"Tue, 29 Apr 2014 20:32:36 -0400")
Message-ID: <87ha5bntqm.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19r3aLZXm2jA6IyxcZhNszd1tiexbEiDpc=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4632]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Theodore Ts'o <tytso@mit.edu>
X-Spam-Relay-Country: 
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:

> On Wed, Apr 30, 2014 at 12:16:41AM +0000, Serge Hallyn wrote:
>> I forget the details, but there was another case where I wanted to
>> have the userns which 'owns' the whole fs available.  I guess we'd
>> have to check against that instead of using inode_capable.
>
> Yes, that sounds right.
>
> And *please* tell me that that under no circumstances can anyone other
> than root@init_user_ns is allowed to use mknod....

Nope.  mknod not allowed.  capable(CAP_MKNOD) is required is required
and I can't see any reason to change that.

As a rule of thumb, the only additional actions allowed in a user
namespace above and beyond what an ordinary unpriviliged user would be
allowed to do are those things which we only don't allow because they
could confuse a setuid root executable.


If we ever allow the creation of immutable files by unprivileged users
those files would at least have to be kept completely separate from the
files the global root encounters (aka a disjoint mount namespace).

I do not currently see a path to safely using immutable files with just
user namespace root permission.

Eric
