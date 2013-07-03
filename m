Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3GCLF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:05:29 -0400
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:55947 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3GCLF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:05:28 -0400
Date: Wed, 3 Jul 2013 13:01:37 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, giometti@enneenne.com,
        Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91/DT: at91sam9x5ek: fix USB host property to
 enable port C
Message-ID: <20130703110137.GE21034@game.jcrosoft.org>
References: <1372849250-14715-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372849250-14715-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 210261808565562220
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:00 Wed 03 Jul     , Nicolas Ferre wrote:
> Device Tree "num-ports" property of USB host node has to be
> set to maximum number of ports available.
> The possibility to activate a particular port is done by specifying the proper
> gpio configuration for its vbus.
> 
> This patch fixes the USB host node by configuring the 3 ports available on the
> product and letting "port A" available for USB gadget usage.
> 
> Reported-by: Rodolfo Giometti <giometti@enneenne.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Bo Shen <voice.shen@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

> ---
>  arch/arm/boot/dts/at91sam9x5ek.dtsi | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> index b753855..49e3c45 100644
> --- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> @@ -94,8 +94,9 @@
>  
>  		usb0: ohci@00600000 {
>  			status = "okay";
> -			num-ports = <2>;
> -			atmel,vbus-gpio = <&pioD 19 GPIO_ACTIVE_LOW
> +			num-ports = <3>;
> +			atmel,vbus-gpio = <0 /* &pioD 18 GPIO_ACTIVE_LOW *//* Activate to have access to port A */
on 2 line would have been more clear


Best Regards,
J.
> +					   &pioD 19 GPIO_ACTIVE_LOW
>  					   &pioD 20 GPIO_ACTIVE_LOW
>  					  >;
>  		};
> -- 
> 1.8.2.2
> 
