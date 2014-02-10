Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaBJKNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:13:16 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21851 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753151AbaBJKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:11:59 -0500
Date: Mon, 10 Feb 2014 10:11:50 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <robherring2@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv2 2/2] arm: Get rid of meminfo
Message-ID: <20140210101150.GB25305@arm.com>
References: <1391558551-31395-1-git-send-email-lauraa@codeaurora.org>
 <1391558551-31395-3-git-send-email-lauraa@codeaurora.org>
 <20140207020949.GQ1706@sonymobile.com>
 <52F846AE.3050800@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F846AE.3050800@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:25:34AM +0000, Laura Abbott wrote:
> On 2/6/2014 6:09 PM, Courtney Cavin wrote:
> > On Wed, Feb 05, 2014 at 01:02:31AM +0100, Laura Abbott wrote:
> >> memblock is now fully integrated into the kernel and is the prefered
> >> method for tracking memory. Rather than reinvent the wheel with
> >> meminfo, migrate to using memblock directly instead of meminfo as
> >> an intermediate.
> >>
> >> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> > [...]
> >> diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
> >> index 0b11c1a..51d814e 100644
> >> --- a/arch/arm/mach-pxa/spitz.c
> >> +++ b/arch/arm/mach-pxa/spitz.c
> >> @@ -32,6 +32,7 @@
> >>   #include <linux/io.h>
> >>   #include <linux/module.h>
> >>   #include <linux/reboot.h>
> >> +#include <linux/memblock.h>
> >>
> >>   #include <asm/setup.h>
> >>   #include <asm/mach-types.h>
> >> @@ -971,13 +972,9 @@ static void __init spitz_init(void)
> >>          spitz_i2c_init();
> >>   }
> >>
> >> -static void __init spitz_fixup(struct tag *tags, char **cmdline,
> >> -                              struct meminfo *mi)
> >> +static void __init spitz_fixup(struct tag *tags, char **cmdline)
> >>   {
> >> -       sharpsl_save_param();
> >> -       mi->nr_banks = 1;
> >> -       mi->bank[0].start = 0xa0000000;
> >> -       mi->bank[0].size = (64*1024*1024);
> >> +       memblock_addr(0xa0000000, SZ_64M);
> >
> > memblock_add() ?
> Yes, that was a typo on my part. I'll send out a v3 with collected acks.

And better testing ;)

-- 
Catalin
