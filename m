Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaDWJCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:02:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55433 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016AbaDWJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:02:50 -0400
Date: Wed, 23 Apr 2014 11:02:46 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2 1/2] ARM: dts: berlin: add the SDHCI nodes for the BG2Q
Message-ID: <20140423090246.GG24355@kwain>
References: <1398155248-1659-1-git-send-email-antoine.tenart@free-electrons.com>
 <1398155248-1659-2-git-send-email-antoine.tenart@free-electrons.com>
 <5356A85F.6030708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5356A85F.6030708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Tue, Apr 22, 2014 at 07:35:27PM +0200, Sebastian Hesselbarth wrote:
> On 04/22/2014 10:27 AM, Antoine Ténart wrote:

[…]

> > +		sdhci0: sdhci@ab0000 {
> > +			compatible = "mrvl,pxav3-mmc";
> > +			reg = <0xab0000 0x200>;
> > +			clocks = <&sdio1clk>;
> > +			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> > +			status = "disabled";
> > +		};
> > +
> > +		sdhci1: sdhci@ab0800 {
> > +			compatible = "mrvl,pxav3-mmc";
> > +			reg = <0xab0800 0x200>;
> > +			clocks = <&sdio1clk>;
> > +			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
> > +			status = "disabled";
> > +		};
> > +
> > +		sdhci2: sdhci@ab1000 {
> 
> Didn't Jisheng ask for sdhci2 being registered at mmc0?

Yes sure, but I don't know if he agreeded on this solution. I'll ask him.
Otherwise aliases seems ok from my point of view.

> Renaming the node labels will not help, but have you tried using an:
> 
> aliases {
> 	mmc0 = &sdhci2;
> 	mmc1 = &sdhci0;
> 	mmc2 = &sdhci1;
> };
> 
> node and set the platform_device's .id field with what you get
> from of_alias_get_id(np, "mmc")?
> 
> @Chris, Ulf: Is there any generic alias, e.g. "sdhci", you prefer for
> drivers/mmc so we can put it into sdhci_get_of_property()?

I'd also like the subsystem maintainers to give their opinion on this
before updating.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
