Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3KHQyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:54:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42513 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab3KHQyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:54:51 -0500
Date: Fri, 8 Nov 2013 16:54:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Rob Herring <robherring2@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library
	functions
Message-ID: <20131108165437.GM16735@n2100.arm.linux.org.uk>
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org> <CAL_JsqJ9zbJFJePk2FHH8UhrUP2J7fuuiZLb+NhuTovRodqrCA@mail.gmail.com> <20131108115004.GH28304@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108115004.GH28304@ns203013.ovh.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:50:04PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 19:34 Thu 07 Nov     , Rob Herring wrote:
> > On Thu, Nov 7, 2013 at 1:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > > If we're running on a v7 ARM CPU, detect if the CPU supports the
> > > sdiv/udiv instructions and replace the signed and unsigned
> > > division library functions with an sdiv/udiv instruction.
> > 
> > [snip]
> > 
> > > diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> > > index bd454b0..6ed6496 100644
> > > --- a/arch/arm/lib/Makefile
> > > +++ b/arch/arm/lib/Makefile
> > > @@ -15,6 +15,9 @@ lib-y         := backtrace.o changebit.o csumipv6.o csumpartial.o   \
> > >                    io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
> > >                    call_with_stack.o
> > >
> > > +lib-$(CONFIG_CPU_V7) += div-v7.o
> > > +CFLAGS_div-v7.o := -march=armv7-a
> > 
> > Won't this fail to build if the compiler doesn't have armv7-a support.
> > Perhaps we don't care about compilers that old.
> 
> use the propoer compiler to compile a armv7 kernel

It's probably about time to get rid of the conditionals for this in
the main arch/arm/Makefile actually - some of those date back some
10 or so years.  That's something for the v3.14 merge window.
