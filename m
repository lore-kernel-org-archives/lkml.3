Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaBDU3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:29:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:49216 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaBDU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:29:35 -0500
Date: Tue, 4 Feb 2014 21:29:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove hpet vclock support
In-Reply-To: <CALCETrUwdS9c1RgWLN4Wvimejh56N0tnCmgsSgPKGv5bVCn8ZQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402042126090.24986@ionos.tec.linutronix.de>
References: <d348afdb2f6acc41dde0381396226b69a0358f8b.1391210357.git.luto@amacapital.net> <alpine.DEB.2.02.1402042011400.24986@ionos.tec.linutronix.de> <CALCETrUwdS9c1RgWLN4Wvimejh56N0tnCmgsSgPKGv5bVCn8ZQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Andy Lutomirski wrote:
> On Tue, Feb 4, 2014 at 11:31 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 31 Jan 2014, Andy Lutomirski wrote:
> >
> >> The HPET is so amazingly slow that this is barely a win.  It adds
> >
> > That's nonsense. It's definitely a win to access HPET directly
> > especially on older systems with TSC wreckage. Why do you want to
> > enforce a syscall if we can read out the data straight from user
> > space. The systems which are forced to use HPET have slower syscalls
> > than those which have a proper TSC.
> >
> 
> I'm actually curious whether anyone cares about this particular
> performance difference.  On all my HPET systems, the actual HPET read
> takes ~500ns, whereas the overhead from a syscall is ~50ns.  (This is
> ignoring the CONFIG_AUDIT_SYSCALL wreckage, which I'm trying to fix.)
> I certainly care about 10% performance changes in clock_gettime, but
> that's only because it's already fast enough to call very frequently.
> If it took anywhere near 500ns, I would just stop using it, so the
> 50ns difference wouldn't matter for my application.
> 
> It's certainly true that, on older hardware, syscalls are slower, but
> I suspect that the HPET is at least as slow, and old enough hardware
> won't even have a usable HPET.

Well, on one reference system which is forced to use hpet the
systemcall overhead with your patch amounts with a real world
application to a whopping 20% versus the vdso based HPET access.
 
> On newish things (probably Nehalem and up that have non-buggy BIOS),
> HPET is AFAIK completely pointless.

True, but there is a world outside of the "we have access to the
latest hardware" universe. Linux has served that world very well and I
see no reason why we should not continue to do so.
 
Thanks,

	tglx
