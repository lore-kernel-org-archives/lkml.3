Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3FZPAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:00:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZPAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:00:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: Device Tree updates for 3.11 #3
Date: Wed, 26 Jun 2013 16:57:04 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1372237377-20315-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1372237377-20315-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306261657.05191.arnd@arndb.de>
X-Provags-ID: V02:K0:wJRcthv7p4+xV41VKddZG6708kg+Vy45Qtu6ovnpCNE
 KHDu5nP5yKq55RKBcUFoyvv+XHncJc8hqSb7DL6XUgFomhCDfZ
 PR/XLB+Oeok6dnOOayw8UapL8esgXEpzCP5FTOSMM2NWaLHEoS
 Z9TphetNkMWz5/QnX0UkJoRcwmkS0O6Ab21csgP/dDcrOR+pE8
 G2dR03zpnP/VVEESumzy/lXMYMUSKdnHNuFP9Ia1CDpydaMU6h
 6xfc6uE6rre8W9dmEt2md9YZdZqMScXeGSn391osleTJz2sgYT
 G806T99zcQF2t6FEjt423fyj4xhMBRjepq0Za/rA0w1nC3WPXb
 s/4zcxixXT2jHDII0Sdc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013, Nicolas Ferre wrote:
> Arnd, Olof,
> 
> One more pull-request for AT91 DT patches.
> It is focused on SPI on several SoCs and it particular the SPI+DMA addition on newer
> SAMA5D3 and AT91SAM9N12.

Pulled into next/dt, thanks! I've performed the simple merge below.

	Arnd

diff --cc arch/arm/boot/dts/sama5d3.dtsi
index bbf88d7,5956f9b..a1d5e25
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@@ -80,9 -76,17 +80,12 @@@
  			spi0: spi@f0004000 {
  				#address-cells = <1>;
  				#size-cells = <0>;
- 				compatible = "atmel,at91sam9x5-spi";
+ 				compatible = "atmel,at91rm9200-spi";
  				reg = <0xf0004000 0x100>;
  				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
 -				cs-gpios = <&pioD 13 0
 -					    &pioD 14 0 /* conflicts with SCK0 and CANRX0 */
 -					    &pioD 15 0 /* conflicts with CTS0 and CANTX0 */
 -					    &pioD 16 0 /* conflicts with RTS0 and PWMFI3 */
 -					   >;
+ 				dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(1)>,
+ 				       <&dma0 2 AT91_DMA_CFG_PER_ID(2)>;
+ 				dma-names = "tx", "rx";
  				pinctrl-names = "default";
  				pinctrl-0 = <&pinctrl_spi0>;
  				status = "disabled";
@@@ -203,9 -207,17 +206,12 @@@
  			spi1: spi@f8008000 {
  				#address-cells = <1>;
  				#size-cells = <0>;
- 				compatible = "atmel,at91sam9x5-spi";
+ 				compatible = "atmel,at91rm9200-spi";
  				reg = <0xf8008000 0x100>;
  				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 3>;
 -				cs-gpios = <&pioC 25 0
 -					    &pioC 26 0 /* conflitcs with TWD1 and ISI_D11 */
 -					    &pioC 27 0 /* conflitcs with TWCK1 and ISI_D10 */
 -					    &pioC 28 0 /* conflitcs with PWMFI0 and ISI_D9 */
 -					   >;
+ 				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(15)>,
+ 				       <&dma1 2 AT91_DMA_CFG_PER_ID(16)>;
+ 				dma-names = "tx", "rx";
  				pinctrl-names = "default";
  				pinctrl-0 = <&pinctrl_spi1>;
  				status = "disabled";

