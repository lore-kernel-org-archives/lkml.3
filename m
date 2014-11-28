Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaK1Qlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:41:52 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40224 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbaK1Qls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:41:48 -0500
Date: Fri, 28 Nov 2014 16:40:47 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        Pawel Moll <Pawel.Moll@arm.com>, "corbet@lwn.net" <corbet@lwn.net>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "broonie@linaro.org" <broonie@linaro.org>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Message-ID: <20141128164047.GL25883@leverpostej>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
 <20141127134309.GJ857@leverpostej>
 <20141128142913.GB5393@localhost>
 <20141128143532.GI25883@leverpostej>
 <20141128144412.GG7144@arm.com>
 <20141128150325.GC24370@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128150325.GC24370@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> In the meantime I think we can be more tolerant:
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 2133f9d59d06..87f67a93fcc7 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -376,6 +376,8 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
>  			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
>  		else
>  			arch_timer_rate = arch_timer_get_cntfrq();
> +	} else if (IS_ENABLED(CONFIG_ARM64)) {
> +		pr_warn("Architected timer frequency overridden by DT (broken firmware?)\n");
>  	}

That looks good to me. On a related note, it looks like my documentation
patch [1] from a while back fell by the wayside. Does anyone fancy
picking that up to go with this?

Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/282830.html
