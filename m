Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbaJ3KtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:49:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:34054 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbaJ3KtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:49:23 -0400
Date: Thu, 30 Oct 2014 11:49:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ley Foon Tan <lftan@altera.com>
cc: Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v5 29/29] nios2: Build infrastructure
In-Reply-To: <CAFiDJ59LZSwKBzVuuzfH_5772-BR74EH=d=FeBbWvEXjfpisug@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410301148080.5308@nanos>
References: <1414139071-3818-1-git-send-email-lftan@altera.com> <1414139071-3818-30-git-send-email-lftan@altera.com> <2095416.INZmt8AD1y@wuerfel> <CAFiDJ59LZSwKBzVuuzfH_5772-BR74EH=d=FeBbWvEXjfpisug@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Ley Foon Tan wrote:

> On Tue, Oct 28, 2014 at 9:38 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 24 October 2014 16:24:31 Ley Foon Tan wrote:
> >> +DECLARE_EXPORT(__gcc_bcmp);
> >> +DECLARE_EXPORT(__divdi3);
> >> +DECLARE_EXPORT(__divsi3);
> >> +DECLARE_EXPORT(__moddi3);
> >> +DECLARE_EXPORT(__modsi3);
> >> +DECLARE_EXPORT(__udivdi3);
> >> +DECLARE_EXPORT(__udivmoddi4);
> >> +DECLARE_EXPORT(__udivsi3);
> >> +DECLARE_EXPORT(__umoddi3);
> >> +DECLARE_EXPORT(__umodsi3);
> >> +DECLARE_EXPORT(__muldi3);
> >>
> >
> > I don't remember what all of these are, but at least some of them seem
> > to be concerned with 64-bit division. By convention, we don't provide those
> > in the Linux kernel but instead require all code to use the do_div()
> > macro instead.
> Do you mean kernel doesn't support 64 bit division result for a 32-bit
> architecture? Because do_div() only support 32-bit division result for
> 32-bit architecture.
> Compiler will auto generate call to __divdi3() for the following
> example code. This means loadable module will have compilation error
> if we don't export symbol for __divdi3, but built-in module is fine.
> Is this an expectation? Or we can keep 64-bit division symbols here
> since they are no harm (they are software emulation when without
> hardware divider).
> 
> long long a, b, c;
> a = b / c;

We have proper helper functions for this:

See include/linux/math.h

Thanks,

	tglx
