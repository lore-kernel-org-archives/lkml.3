Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaI3XVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:21:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:33975 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaI3XVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:21:33 -0400
Date: Wed, 1 Oct 2014 01:21:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Sebastian Lackner <sebastian@fds-team.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [PATCH 1/2] x86_64,entry: Filter RFLAGS.NT on entry from
 userspace
In-Reply-To: <CALCETrWTVPjkgfU3sWyKgtfidccXkO=H7y+9XiX20AfeQsAf2w@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410010119320.4455@nanos>
References: <cover.1412105369.git.luto@amacapital.net> <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net> <542B2305.9060805@fds-team.de> <CALCETrX86zeONHsf74yKseddXUc1BMHHAFaGKgU82HuU9+_PjQ@mail.gmail.com> <alpine.DEB.2.11.1410010025050.4455@nanos>
 <CALCETrWTVPjkgfU3sWyKgtfidccXkO=H7y+9XiX20AfeQsAf2w@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Andy Lutomirski wrote:

> On Tue, Sep 30, 2014 at 3:27 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 30 Sep 2014, Andy Lutomirski wrote:
> >> It would certainly be possible to clear NT and retry IRET if IRET
> >> fails with NT set.  This would have no overhead for anything relevant.
> >> That would be this alternative from my 0/2 email:
> >>
> >>  - Don't filter NT on sysenter.  Instead, filter it on EFI entry
> >>    and modify the IRET code to retry without NT set if NT was set.
> >>
> >> Thomas hpa, etc: any thoughts?
> >
> > Filter it right away. That's solid and obvious. Anything else is just
> > complex and prone for future brown paperbag failures.
> 
> Yeah, agreed.  That's exactly what these patches do, although, if you
> put them in -tip and want to keep the stable CC, it's probably worth
> fixing the address (oops).

Even more oops as you failed to update it in your reply again ....
 
> > We get the context switch benefit from it, so there is some
> > compensation for the extra cycles.
> 
> If we ever want those cycles back, I bet that the compat sysenter path
> could be trimmed down a lot.  For example, I think that all of the
> zero-extension stuff is unnecessary now that we have the magic syscall
> wrappers for all (?) syscalls.

Emphasis on "(?)". So yes, once we verified that ....

Thanks,

	tglx
