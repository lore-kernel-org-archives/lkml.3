Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaK1RYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:24:48 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41679 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaK1RYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:24:45 -0500
Date: Fri, 28 Nov 2014 17:24:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "andrew@lunn.ch" <andrew@lunn.ch>, "heiko@sntech.de" <heiko@sntech.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Message-ID: <20141128172431.GA32393@e104818-lin.cambridge.arm.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
 <20141127134309.GJ857@leverpostej>
 <20141128142913.GB5393@localhost>
 <20141128143532.GI25883@leverpostej>
 <20141128144412.GG7144@arm.com>
 <20141128150325.GC24370@e104818-lin.cambridge.arm.com>
 <20141128164047.GL25883@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128164047.GL25883@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 04:40:47PM +0000, Mark Rutland wrote:
> [...]
> 
> > In the meantime I think we can be more tolerant:
> > 
> > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> > index 2133f9d59d06..87f67a93fcc7 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -376,6 +376,8 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
> >  			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
> >  		else
> >  			arch_timer_rate = arch_timer_get_cntfrq();
> > +	} else if (IS_ENABLED(CONFIG_ARM64)) {
> > +		pr_warn("Architected timer frequency overridden by DT (broken firmware?)\n");
> >  	}
> 
> That looks good to me. On a related note, it looks like my documentation
> patch [1] from a while back fell by the wayside. Does anyone fancy
> picking that up to go with this?

I can put the two together (keeping you as author). Do we still need the
IS_ENABLED(CONFIG_ARM64) part here or we extend the warning to to arm32
as well?

-- 
Catalin
