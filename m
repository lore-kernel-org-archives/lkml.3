Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaDZRmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 13:42:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35795 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaDZRmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 13:42:45 -0400
Date: Sat, 26 Apr 2014 18:42:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
Message-ID: <20140426174229.GG18016@ZenIV.linux.org.uk>
References: <CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
 <874n1h16le.fsf@x220.int.ebiederm.org>
 <CACE9dm_56FvbJDVyxvTtd3yL+d89XYhZ-i038HJS-sUsZAPpaQ@mail.gmail.com>
 <87iopxxfpp.fsf@x220.int.ebiederm.org>
 <CACE9dm-fdqDgFT5Pw1ry6XOuAhqmsEEiQMOFw=rooazBkdx-wg@mail.gmail.com>
 <CACE9dm9CTU0-FFr3KveE8QV0dR-vxiDg91Km_2w3v37O5eTcYg@mail.gmail.com>
 <87lhutt4ph.fsf@x220.int.ebiederm.org>
 <CACE9dm_SreLw8976qu52tmnJ5dq_xruR5f1sp9VfJBieEk-=nw@mail.gmail.com>
 <20140426135616.GE18016@ZenIV.linux.org.uk>
 <CACE9dm-Ruvt-kDk3B3YJ9SJ3PvRKa+NJ-e1zpnxcTPk7aDBmug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACE9dm-Ruvt-kDk3B3YJ9SJ3PvRKa+NJ-e1zpnxcTPk7aDBmug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 07:54:47PM +0300, Dmitry Kasatkin wrote:
> On 26 April 2014 16:56, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sat, Apr 26, 2014 at 11:58:45AM +0300, Dmitry Kasatkin wrote:
> >
> >> Conflict with Apparmor means with Ubuntu.
> >>
> >> But answering to your early question..
> >> IMA does not want permission denied when measuring and re-measuring files.
> >> may_open() is doing that job before.
> >>
> >> We need quickly introduce kernel_read without LSM checks...
> >
> > *snarl*
> >
> > What we need quickly is to introduce you to a textbook or two.  As the
> > matter of fact, in this case even wikipedia might suffice...
> >
> 
> Hopefully we have you who were introduced to a textbook or two about relevant
> subject and able kindly help us with the solution instead of telling
> me this crap...

See the discussion of that very topic (required modifications of vfs_read())
upthread.  And Eric has a very good point about the usefulness of understanding
the basics of IO-related system calls in Unix for anybody who does any
kind of development related to keeping track of file contents modifications,
etc.  It's *not* about some arcane knowledge of VFS internals (which also might
come handy when sticking hooks into said internals); it's about being familiar
with the semantics of read(2) and related concepts.
