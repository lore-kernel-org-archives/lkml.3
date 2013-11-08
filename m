Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab3KHMEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:04:55 -0500
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:50252 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757079Ab3KHMEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:04:54 -0500
Date: Fri, 8 Nov 2013 12:50:04 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
Message-ID: <20131108115004.GH28304@ns203013.ovh.net>
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org>
 <CAL_JsqJ9zbJFJePk2FHH8UhrUP2J7fuuiZLb+NhuTovRodqrCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJ9zbJFJePk2FHH8UhrUP2J7fuuiZLb+NhuTovRodqrCA@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 14946602738881178588
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrheejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrheejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:34 Thu 07 Nov     , Rob Herring wrote:
> On Thu, Nov 7, 2013 at 1:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > If we're running on a v7 ARM CPU, detect if the CPU supports the
> > sdiv/udiv instructions and replace the signed and unsigned
> > division library functions with an sdiv/udiv instruction.
> 
> [snip]
> 
> > diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> > index bd454b0..6ed6496 100644
> > --- a/arch/arm/lib/Makefile
> > +++ b/arch/arm/lib/Makefile
> > @@ -15,6 +15,9 @@ lib-y         := backtrace.o changebit.o csumipv6.o csumpartial.o   \
> >                    io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
> >                    call_with_stack.o
> >
> > +lib-$(CONFIG_CPU_V7) += div-v7.o
> > +CFLAGS_div-v7.o := -march=armv7-a
> 
> Won't this fail to build if the compiler doesn't have armv7-a support.
> Perhaps we don't care about compilers that old.

use the propoer compiler to compile a armv7 kernel

Best Regards,
J.
> 
> Rob
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
