Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaK0MMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:12:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40600 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaK0MM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:12:29 -0500
Date: Thu, 27 Nov 2014 12:12:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Will Deacon <Will.Deacon@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Message-ID: <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127115042.GE857@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 11:50:43AM +0000, Mark Rutland wrote:
> On Tue, Nov 25, 2014 at 12:16:56PM +0000, Chunyan Zhang wrote:
> > +
> > +       timer {
> > +               compatible = "arm,armv8-timer";
> > +               interrupts = <1 13 0xff01>,
> > +                            <1 14 0xff01>,
> > +                            <1 11 0xff01>,
> > +                            <1 10 0xff01>;
> > +               clock-frequency = <26000000>;
> 
> Please remove the clock-frequency property. Your FW should initialise
> CNTFRQ_EL0 on all CPUs (certainly PSCI 0.2 requires that you do this).

Since this comes up regularly, I think we need a dev_warn() in the arch
timer driver when CONFIG_ARM64.

-- 
Catalin
