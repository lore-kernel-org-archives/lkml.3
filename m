Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaICGJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:09:32 -0400
Received: from mail.interact-automation.nl ([193.141.16.74]:39807 "EHLO
	smtp.interact.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaICGJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:09:31 -0400
Message-ID: <5406B098.6020500@interact.nl>
Date: Wed, 03 Sep 2014 08:09:28 +0200
From: Erik van Luijk <evanluijk@interact.nl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] ARM: at91/dt: at91sam9m10g45ek add rtc node
References: <1409655132-17735-1-git-send-email-evanluijk@interact.nl> <20140902183356.7bcfdf84@bbrezillon>
In-Reply-To: <20140902183356.7bcfdf84@bbrezillon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Boris, Nicolas,

Boris BREZILLON schreef op 2-9-2014 om 18:33:
> Hi Erik,
 >
 > On Tue,  2 Sep 2014 12:52:12 +0200
 > Erik van Luijk <evanluijk@interact.nl> wrote:
 >
 >> Signed-off-by: Erik van Luijk <evanluijk@interact.nl>
 >
 > Except for the nitpicks you'll find below, you have my
 >
 > Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
 >
 >> ---
 >>  arch/arm/boot/dts/at91sam9g45.dtsi     | 7 +++++++
 >>  arch/arm/boot/dts/at91sam9m10g45ek.dts | 3 +++
 >>  2 files changed, 10 insertions(+)
 >>
 >> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi 
b/arch/arm/boot/dts/at91sam9g45.dtsi
 >> index 932a669..bf62c18 100644
 >> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
 >> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
 >> @@ -1070,6 +1070,13 @@
 >>                  status = "disabled";
 >>              };
 >>
 >> +            rtc@fffffdb0 {
 >> +                compatible = "atmel,at91rm9200-rtc";
 >> +                reg = <0xfffffdb0 0x30>;
 >
 > The RTC registers goes from 0xfffffdb0 to 0xfffffdc0, which means the
 > size is 0x10 and not 0x30. This is not important here, because the
 > following region is marked as reserved, but we prefer to keep the DT
 > consistent with the datasheet.

This is an inconsistency in the datasheet of the AT91SAM9G45 (and at 
least also
AT91SAM9G15, AT91SAM9G25, AT91SAM9G35 and AT91SAM9M10).
In the memory map (fig. 5-1) there is room for 16 bytes.
But in the 'Real-time Clock (RTC) User Interface' (table 15-1) there is 
room for
48 bytes (0x30) excluding the Reserved Registers (which don't belong to 
the RTC
on the AT91SAM9M10). Perhaps Nicolas can draw some attention to this at 
Atmel.

>
 >> +                interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 >> +                status = "disabled";
 >> +            };
 >> +
 >>              spi0: spi@fffa4000 {
 >>                  #address-cells = <1>;
 >>                  #size-cells = <0>;
 >> diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts 
b/arch/arm/boot/dts/at91sam9m10g45ek.dts
 >> index 96ccc7d..2dd2347 100644
 >> --- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
 >> +++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
 >> @@ -70,6 +70,9 @@
 >>
 >>              watchdog@fffffd40 {
 >>                  status = "okay";
 >> +
 >> +            rtc@fffffdb0 {
 >> +                status = "okay";
 >
 > Try to keep SoC and board changes in distinct commits.

Understood.

>
 >>              };
 >>
 >>              mmc0: mmc@fff80000 {
 >
 >
 > Best Regards,
 >
 > Boris
 >

Regards,

Erik
