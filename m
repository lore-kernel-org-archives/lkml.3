Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbbABSV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:21:26 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:50789 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbbABSVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:21:24 -0500
MIME-Version: 1.0
In-Reply-To: <CABuKBeJ-bBiJSbh9jKH1+T2MhKCjxnkryStrhG_kFX7HuBnevQ@mail.gmail.com>
References: <1413983529-21887-1-git-send-email-eddie.huang@mediatek.com>
	<1413983529-21887-3-git-send-email-eddie.huang@mediatek.com>
	<CABuKBeJ-bBiJSbh9jKH1+T2MhKCjxnkryStrhG_kFX7HuBnevQ@mail.gmail.com>
Date: Fri, 2 Jan 2015 19:21:21 +0100
Message-ID: <CABuKBe+WeL7AOP0U9dtujUVr=cO2EDmz8rBSnscC9_LpxB7+yg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: mediatek: add UART dts for mt8127 and mt8135
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        =?UTF-8?B?WUggQ2hlbiAo6Zmz5pix6LGqKQ==?= <yh.chen@mediatek.com>,
        HC Yen <hc.yen@mediatek.com>, Nathan Chung <nathan.chung@mediatek.com>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-02 11:23 GMT+01:00 Matthias Brugger <matthias.bgg@gmail.com>:
> 2014-10-22 15:12 GMT+02:00 Eddie Huang <eddie.huang@mediatek.com>:
>> This add dts support for mt8127 and mt8135 SOC UART
>>
>> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
>> ---
>>  arch/arm/boot/dts/mt8127.dtsi | 34 ++++++++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/mt8135.dtsi | 36 ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 70 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/mt8127.dtsi b/arch/arm/boot/dts/mt8127.dtsi
>> index 25c9f69..249c218 100644
>> --- a/arch/arm/boot/dts/mt8127.dtsi
>> +++ b/arch/arm/boot/dts/mt8127.dtsi
>> @@ -64,6 +64,12 @@
>>                         clock-frequency = <32000>;
>>                         #clock-cells = <0>;
>>                 };
>> +
>> +               uart_clk: dummy26m {
>> +                       compatible = "fixed-clock";
>> +                       clock-frequency = <26000000>;
>> +                       #clock-cells = <0>;
>> +                };
>>         };
>>
>>         soc {
>> @@ -89,5 +95,33 @@
>>                               <0 0x10214000 0 0x2000>,
>>                               <0 0x10216000 0 0x2000>;
>>                 };
>> +
>> +               uart0: serial@11006000 {
>> +                       compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
>> +                       reg = <0 0x11002000 0 0x400>;
>> +                       interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
>> +                       clocks = <&uart_clk>;
>> +               };

I just realized that you forgot to disable the uart ports by default
in the dtsi.
I fixed that for you, but please send a patch enabling the necessary
ports in the board dts file.
It depends on the board which uarts will be enabled rather then on the SoC.

>> +
>> +               uart1: serial@11007000 {
>> +                       compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
>> +                       reg = <0 0x11003000 0 0x400>;
>> +                       interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_LOW>;
>> +                       clocks = <&uart_clk>;
>> +               };
>> +
>> +               uart2: serial@11008000 {
>> +                       compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
>> +                       reg = <0 0x11004000 0 0x400>;
>> +                       interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_LOW>;
>> +                       clocks = <&uart_clk>;
>> +               };
>> +
>> +               uart3: serial@11009000 {
>> +                       compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
>> +                       reg = <0 0x11005000 0 0x400>;
>> +                       interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_LOW>;
>> +                       clocks = <&uart_clk>;
>> +               };
>>         };
>>  };
>> diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
>> index 90a56ad..683b761 100644
>> --- a/arch/arm/boot/dts/mt8135.dtsi
>> +++ b/arch/arm/boot/dts/mt8135.dtsi
>> @@ -86,6 +86,13 @@
>>                         clock-frequency = <32000>;
>>                         #clock-cells = <0>;
>>                 };
>> +
>> +               uart_clk: dummy26m {
>> +                       compatible = "fixed-clock";
>> +                       clock-frequency = <26000000>;
>> +                       #clock-cells = <0>;
>> +               };
>> +
>>         };
>>
>>         soc {
>> @@ -111,5 +118,34 @@
>>                               <0 0x10214000 0 0x2000>,
>>                               <0 0x10216000 0 0x2000>;
>>                 };
>> +
>> +               uart0: serial@11006000 {
>> +                       compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
>> +                       reg = <0 0x11006000 0 0x400>;
>> +                       interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
>> +                       clocks = <&uart_clk>;
>> +               };
>> +
>> +               uart1: serial@11007000 {
>> +                       compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
>> +                       reg = <0 0x11007000 0 0x400>;
>> +                       interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_LOW>;
>> +                       clocks = <&uart_clk>;
>> +               };
>> +
>> +               uart2: serial@11008000 {
>> +                       compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
>> +                       reg = <0 0x11008000 0 0x400>;
>> +                       interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_LOW>;
>> +                       clocks = <&uart_clk>;
>> +               };
>> +
>> +               uart3: serial@11009000 {
>> +                       compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
>> +                       reg = <0 0x11009000 0 0x400>;
>> +                       interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_LOW>;
>> +                       clocks = <&uart_clk>;
>> +               };
>> +
>>         };
>>  };
>> --
>> 1.8.1.1.dirty
>>
>
> Applied to v3.20-next/dts, thanks.
>
> --
> motzblog.wordpress.com



-- 
motzblog.wordpress.com
