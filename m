Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3EXMxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:53:17 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:37532 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3EXMxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:53:16 -0400
Message-ID: <519F62B3.8090302@elopez.com.ar>
Date: Fri, 24 May 2013 09:53:07 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Florian Fainelli <florian@openwrt.org>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [PATCHv3 5/6] ARM: cubieboard: Enable ethernet (EMAC) support
 in dts
References: <1369387394-9453-1-git-send-email-maxime.ripard@free-electrons.com> <1369387394-9453-6-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1369387394-9453-6-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: multipart/mixed;
 boundary="------------060108070901020907050906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060108070901020907050906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi,

El 24/05/13 06:23, Maxime Ripard escribió:
> From: Stefan Roese <sr@denx.de>
> 
> Signed-off-by: Stefan Roese <sr@denx.de>
> ---
>  arch/arm/boot/dts/sun4i-a10-cubieboard.dts | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> index b70fe0d..32d9b18 100644
> --- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> +++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> @@ -27,6 +27,21 @@
>  	};
>  
>  	soc@01c20000 {
> +		emac: ethernet@01c0b000 {
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&emac_pins_a>;
> +			phy = <&phy0>;
> +			status = "okay";
> +		};
> +
> +		mdio@01c0b080 {
> +			status = "okay";
> +
> +			phy0: ethernet-phy@0 {
> +				reg = <0>;
> +			};

During my testing I found out that I needed to use 1 as reg for the
driver to work. You can find a fixup patch enclosed that changes this;
it's possible that some extra changes may also be needed (s/phy0/phy1/
on the node?)

Cheers,

Emilio

--------------060108070901020907050906
Content-Type: text/x-diff;
 name="fixup-reg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fixup-reg.patch"

>From f8a76c66fff0700e3c87f89b8b250effc0f2b37f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Date: Fri, 17 May 2013 10:11:48 -0300
Subject: [PATCH] fixup! ARM: cubieboard: Enable ethernet (EMAC) support in dts

---
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
index cd69799..21f0197 100644
--- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
+++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
@@ -38,7 +38,7 @@
 			status = "okay";
 
 			phy0: ethernet-phy@0 {
-				reg = <0>;
+				reg = <1>;
 			};
 		};
 
-- 
1.8.1.6


--------------060108070901020907050906--
