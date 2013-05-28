Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879Ab3E1RDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:03:12 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:48055 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934805Ab3E1RDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:03:10 -0400
Date: Tue, 28 May 2013 18:02:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] arm64: compiling issue for allmodconfig, need
 "asm/parport.h" by "drivers/parport/parport_pc.c"
Message-ID: <20130528170219.GI17912@arm.com>
References: <5177551D.8090007@asianux.com>
 <20130424082237.GA23397@arm.com>
 <5177B1F0.10106@asianux.com>
 <20130424102327.GF21850@mudshark.cambridge.arm.com>
 <5177BAD0.9000500@asianux.com>
 <20130424110511.GK23397@arm.com>
 <5199A453.4080402@asianux.com>
 <20130521131734.GD27002@arm.com>
 <519C1539.10908@asianux.com>
 <519C7484.9020709@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519C7484.9020709@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 08:32:20AM +0100, Chen Gang wrote:
> On 05/22/2013 08:45 AM, Chen Gang wrote:
> > On 05/21/2013 09:17 PM, Catalin Marinas wrote:
> >> On Mon, May 20, 2013 at 05:19:31AM +0100, Chen Gang wrote:
> >>>
> >>> Need add the default file in 'asm/Kbuild' just like arm has done.
> >>>
> >>> The build command is:
> >>>   make EXTRA_CFLAGS=-W ARCH=arm64 allmodconfig
> >>>   make EXTRA_CFLAGS=-W ARCH=arm64 menuconfig
> >>>     set "aarch64-linux-gnu-" as cross compiling prefix.
> >>>   make EXTRA_CFLAGS=-W ARCH=arm64
> >>>
> >>> The related error:
> >>>   drivers/parport/parport_pc.c:67:25: fatal error: asm/parport.h: No such file or directory
> >>
> >> As I don't see when we'd need this driver, you can probably change the
> >> Kconfig entry (similar to the VGA_CONSOLE one).
> >>
> 
> After check the Kconfig in drivers, we can find quite a few using long
> list args which related with ARCH.
> 
> And they are not only depend on ARCHs, but also depend on another
> things (e.g. VGA_CONSOL also depend on !4xx && !8xx, and another
> combinations).

Given this dependency is on the negation of that symbol, you just remove
it and have a "depends on HAVE_VGA_CONSOLE". The few architectures that
need it will have to define it (X86, ARM with a few configurations).

> We also can find another long list for depend on, but not related with
> ARCH.
> 
> They seems not quit difficult for reading (in fact, if we separate them
> into pieces and let them spread into another areas, the reader will not
> see the whole dependency clearly)
> 
> For fixing bug, better as local as possible, as independent as possible,
> it will be OK if only add !ARM64 for PARPORT_PC depend on, and it has
> no any negative effect. But if we define CONFIG_HAVE_*, we have to let
> it related with multiple platforms.
> 
> For design: if can bear current design, better not to touch it, I think
> current design is still sustainable, and not complex for understanding,
> so not need redesign.

We usually clean some of these as we hit them, otherwise people forget
about the clean-up later ;).

-- 
Catalin
