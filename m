Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaIBQeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:34:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39632 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbaIBQd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:33:58 -0400
Date: Tue, 2 Sep 2014 18:33:56 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Erik van Luijk <evanluijk@interact.nl>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] ARM: at91/dt: at91sam9m10g45ek add rtc node
Message-ID: <20140902183356.7bcfdf84@bbrezillon>
In-Reply-To: <1409655132-17735-1-git-send-email-evanluijk@interact.nl>
References: <1409655132-17735-1-git-send-email-evanluijk@interact.nl>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Erik,

On Tue,  2 Sep 2014 12:52:12 +0200
Erik van Luijk <evanluijk@interact.nl> wrote:

> Signed-off-by: Erik van Luijk <evanluijk@interact.nl>

Except for the nitpicks you'll find below, you have my

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  arch/arm/boot/dts/at91sam9g45.dtsi     | 7 +++++++
>  arch/arm/boot/dts/at91sam9m10g45ek.dts | 3 +++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index 932a669..bf62c18 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -1070,6 +1070,13 @@
>  				status = "disabled";
>  			};
>  
> +			rtc@fffffdb0 {
> +				compatible = "atmel,at91rm9200-rtc";
> +				reg = <0xfffffdb0 0x30>;

The RTC registers goes from 0xfffffdb0 to 0xfffffdc0, which means the
size is 0x10 and not 0x30. This is not important here, because the
following region is marked as reserved, but we prefer to keep the DT
consistent with the datasheet.

> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				status = "disabled";
> +			};
> +
>  			spi0: spi@fffa4000 {
>  				#address-cells = <1>;
>  				#size-cells = <0>;
> diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> index 96ccc7d..2dd2347 100644
> --- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
> +++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> @@ -70,6 +70,9 @@
>  
>  			watchdog@fffffd40 {
>  				status = "okay";
> +
> +			rtc@fffffdb0 {
> +				status = "okay";

Try to keep SoC and board changes in distinct commits.

>  			};
>  
>  			mmc0: mmc@fff80000 {


Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
