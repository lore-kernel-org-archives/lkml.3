Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbbAMP6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:58:47 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39193 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751257AbbAMP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:58:44 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+paUwF2s0UaRCbctXExD41
Date: Tue, 13 Jan 2015 07:54:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: kishon@ti.com, nm@ti.com, balbi@ti.com, george.cherian@ti.com,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/4] ARM: dts: OMAP5: Fix SATA PHY node
Message-ID: <20150113155457.GC2419@atomide.com>
References: <1421151802-7396-1-git-send-email-rogerq@ti.com>
 <1421151802-7396-5-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421151802-7396-5-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [150113 04:26]:
> The sata_ref_clk is a reference clock to the SATA phy.
> This fixes SATA malfunction across suspend/resume or when
> SATA driver is used as a module.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/boot/dts/omap5.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index b321fdf..bb498e7 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -929,8 +929,8 @@
>  				      <0x4A096800 0x40>; /* pll_ctrl */
>  				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
>  				ctrl-module = <&omap_control_sata>;
> -				clocks = <&sys_clkin>;
> -				clock-names = "sysclk";
> +				clocks = <&sys_clkin>, <&sata_ref_clk>;
> +				clock-names = "sysclk", "refclk";
>  				#phy-cells = <0>;
>  			};
>  		};
> -- 
> 2.1.0
> 
