Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaIQKZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:25:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38186 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaIQKZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:25:13 -0400
Date: Wed, 17 Sep 2014 12:24:20 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        shawn.guo@freescale.com, kernel@pengutronix.de, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/3] ARM: dts: imx6: add pm_power_off support for
 i.mx6 chips
Message-ID: <20140917102420.GW4992@pengutronix.de>
References: <1410947881-7345-1-git-send-email-b38343@freescale.com>
 <1410947881-7345-2-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410947881-7345-2-git-send-email-b38343@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:20:41 up 7 days,  3:08, 56 users,  load average: 0.09, 0.16, 0.21
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 05:57:58PM +0800, Robin Gong wrote:
> All chips of i.mx6 can be powered off by programming SNVS.
> For example :
> On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> pmic ON/OFF pin, that will cause the whole PMIC powered off
> except VSNVS. And system can restart once PMIC_ON_REQ goes
> high by push POWRER key.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  arch/arm/boot/dts/imx6qdl.dtsi |    5 +++++
>  arch/arm/boot/dts/imx6sl.dtsi  |    5 +++++
>  arch/arm/boot/dts/imx6sx.dtsi  |    5 +++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index c701af9..fffa1c6 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -645,6 +645,11 @@
>  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
>  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
>  				};
> +
> +				snvs-poweroff@38 {
> +					compatible = "fsl,sec-v4.0-poweroff";
> +					reg = <0x38 0x4>;
> +				};

As said: This makes board specific assumptions on SoC level. Whether or
not this function is available is *BOARD* specific, so at SoC level this
needs a status = "disabled";

So: NACK.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
