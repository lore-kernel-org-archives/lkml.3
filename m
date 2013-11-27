Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3K0KEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:04:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57864 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3K0KEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:04:33 -0500
Message-ID: <1385546387.4270.11.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH 3/3] ARM: tegra: set SM2 voltage correct
From: Lucas Stach <l.stach@pengutronix.de>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, sameo@linux.intel.com,
        dev@lynxeye.de, mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 27 Nov 2013 10:59:47 +0100
In-Reply-To: <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
References: <cover.1385508112.git.stefan@agner.ch>
	 <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Am Mittwoch, den 27.11.2013, 00:45 +0100 schrieb Stefan Agner:
> Set the requested SM2 voltage to the correct value of 1.8V. The value
> before used to work on TPS658623 since the driver applied a wrong
> voltage table too. However, the TPS658643 used on newer devices uses
> yet another voltage table and those broke that compatibility. The
> regulator driver now has the correct voltage table for both regulator
> versions and those the correct voltage can be used in this device
> tree.

This isn't a global Tegra change, but very specific to the Colibri, so
please reword your commit headline to reflect that.

Also there are other issues with the regulator setup on Colibri, I sent
a patch for this a good while ago, but didn't come around to revise it
until now. So if you are going to touch things here, please look up that
patch and fold it into this one.

I'll take a look at the other patches later today.

Regards,
Lucas

> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/boot/dts/tegra20-colibri-512.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> index d5c9bca..cbe89ff 100644
> --- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> +++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> @@ -268,8 +268,8 @@
>  					reg = <3>;
>  					regulator-compatible = "sm2";
>  					regulator-name = "vdd_sm2,vin_ldo*";
> -					regulator-min-microvolt = <3700000>;
> -					regulator-max-microvolt = <3700000>;
> +					regulator-min-microvolt = <1800000>;
> +					regulator-max-microvolt = <1800000>;
>  					regulator-always-on;
>  				};
>  

-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

