Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab3FZPEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:04:06 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:53682 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3FZPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:04:04 -0400
Message-ID: <51CB02DD.4080409@atmel.com>
Date: Wed, 26 Jun 2013 17:03:57 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: Device Tree updates for 3.11 #3
References: <1372237377-20315-1-git-send-email-nicolas.ferre@atmel.com> <201306261657.05191.arnd@arndb.de>
In-Reply-To: <201306261657.05191.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/2013 16:57, Arnd Bergmann :
> On Wednesday 26 June 2013, Nicolas Ferre wrote:
>> Arnd, Olof,
>>
>> One more pull-request for AT91 DT patches.
>> It is focused on SPI on several SoCs and it particular the SPI+DMA addition on newer
>> SAMA5D3 and AT91SAM9N12.
>
> Pulled into next/dt, thanks! I've performed the simple merge below.

Your merge is correct. Thanks a lot Arnd.

Bye,

> diff --cc arch/arm/boot/dts/sama5d3.dtsi
> index bbf88d7,5956f9b..a1d5e25
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@@ -80,9 -76,17 +80,12 @@@
>    			spi0: spi@f0004000 {
>    				#address-cells = <1>;
>    				#size-cells = <0>;
> - 				compatible = "atmel,at91sam9x5-spi";
> + 				compatible = "atmel,at91rm9200-spi";
>    				reg = <0xf0004000 0x100>;
>    				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
>   -				cs-gpios = <&pioD 13 0
>   -					    &pioD 14 0 /* conflicts with SCK0 and CANRX0 */
>   -					    &pioD 15 0 /* conflicts with CTS0 and CANTX0 */
>   -					    &pioD 16 0 /* conflicts with RTS0 and PWMFI3 */
>   -					   >;
> + 				dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(1)>,
> + 				       <&dma0 2 AT91_DMA_CFG_PER_ID(2)>;
> + 				dma-names = "tx", "rx";
>    				pinctrl-names = "default";
>    				pinctrl-0 = <&pinctrl_spi0>;
>    				status = "disabled";
> @@@ -203,9 -207,17 +206,12 @@@
>    			spi1: spi@f8008000 {
>    				#address-cells = <1>;
>    				#size-cells = <0>;
> - 				compatible = "atmel,at91sam9x5-spi";
> + 				compatible = "atmel,at91rm9200-spi";
>    				reg = <0xf8008000 0x100>;
>    				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 3>;
>   -				cs-gpios = <&pioC 25 0
>   -					    &pioC 26 0 /* conflitcs with TWD1 and ISI_D11 */
>   -					    &pioC 27 0 /* conflitcs with TWCK1 and ISI_D10 */
>   -					    &pioC 28 0 /* conflitcs with PWMFI0 and ISI_D9 */
>   -					   >;
> + 				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(15)>,
> + 				       <&dma1 2 AT91_DMA_CFG_PER_ID(16)>;
> + 				dma-names = "tx", "rx";
>    				pinctrl-names = "default";
>    				pinctrl-0 = <&pinctrl_spi1>;
>    				status = "disabled";
>
>
>


-- 
Nicolas Ferre
