Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3JQFlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 01:41:47 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:33216 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3JQFlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 01:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <1381960030-1640-3-git-send-email-tim.kryger@linaro.org>
References: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org>
	<1381960030-1640-3-git-send-email-tim.kryger@linaro.org>
Date: Wed, 16 Oct 2013 22:41:44 -0700
Message-ID: <CAEPRUYrzAow1yr58jOp5ead7BkQx-K7yaLLzSHPwqYVu=aZFEQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 2/6] ARM: dts: Specify clocks for UARTs on bcm11351
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>, Matt Porter <matt.porter@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 2:47 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> Rather than declaring the frequency of the external clock, specify the
> label of the clock such that the driver may determine the frequency on
> its own.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
>  arch/arm/boot/dts/bcm11351.dtsi | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> index c6464fb..ce65367 100644
> --- a/arch/arm/boot/dts/bcm11351.dtsi
> +++ b/arch/arm/boot/dts/bcm11351.dtsi
> @@ -43,7 +43,7 @@
>                 compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
>                 status = "disabled";
>                 reg = <0x3e000000 0x1000>;
> -               clock-frequency = <13000000>;
> +               clocks = <&uartb_clk>;
>                 interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
>                 reg-shift = <2>;
>                 reg-io-width = <4>;

Hi Sebastian,
 this patch series (and a subsequent one from Tim) both rely on your
"ARM: provide common arch init for DT clocks" patchset in order to
work. Will that patchset be in 3.13 ? I don't want to pull the dt mods
unless they are as they break the boot without them.

 Thanks,
   csd
