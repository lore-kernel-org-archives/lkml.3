Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbaAHXix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:38:53 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:54059 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaAHXiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:38:50 -0500
MIME-Version: 1.0
In-Reply-To: <1389120821-12007-1-git-send-email-tim.kryger@linaro.org>
References: <1389120821-12007-1-git-send-email-tim.kryger@linaro.org>
Date: Wed, 8 Jan 2014 15:38:49 -0800
Message-ID: <CAEPRUYo0r5YcRTYdgSNLqedVV4D0bsor7USBoxRRpBXRs7wpbw@mail.gmail.com>
Subject: Re: [RESEND PATCH] ARM: dts: bcm28155-ap: Fix Card Detection GPIO
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Arm Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 10:53 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
> The board schematic states that the "SD_CARD_DET_N gets pulled to GND
> when card is inserted" so the polarity has been updated to active low.
>
> Polarity is now specified with a GPIO define instead of a magic number.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
>  arch/arm/boot/dts/bcm28155-ap.dts | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
> index 08e47c2..27dd110 100644
> --- a/arch/arm/boot/dts/bcm28155-ap.dts
> +++ b/arch/arm/boot/dts/bcm28155-ap.dts
> @@ -13,6 +13,8 @@
>
>  /dts-v1/;
>
> +#include <dt-bindings/gpio/gpio.h>
> +
>  #include "bcm11351.dtsi"
>
>  / {
> @@ -40,7 +42,7 @@
>
>         sdio4: sdio@3f1b0000 {
>                 max-frequency = <48000000>;
> -               cd-gpios = <&gpio 14 0>;
> +               cd-gpios = <&gpio 14 GPIO_ACTIVE_LOW>;
>                 status = "okay";
>         };
>  };
> --
> 1.8.0.1
>
Tim,
 Does bcm11351-brt not also suffer from the same bug? If it does can
you pls update the patch to also fix it?

 Thanks,
   csd
