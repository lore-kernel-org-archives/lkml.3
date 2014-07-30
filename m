Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaG3Rzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:55:42 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:39248 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbaG3Rzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:55:40 -0400
Message-ID: <53D9319A.9060407@cogentembedded.com>
Date: Wed, 30 Jul 2014 21:55:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kever Yang <kever.yang@rock-chips.com>, heiko@sntech.de,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk, paulz@synopsys.com,
        gregkh@linuxfoundation.org, mporter@linaro.org, kishon@ti.com,
        balbi@ti.com
CC: swarren@wwwdotorg.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        addy.ke@rock-chips.com, xjq@rock-chips.com, cf@rock-chips.com,
        lyz@rock-chips.com, wulf@rock-chips.com, dianders@chromium.org,
        olof@lixom.net, sonnyrao@chromium.org
Subject: Re: [PATCH 2/4] ARM: dts: add rk3288 dwc2 controller support
References: <1406683873-18194-1-git-send-email-kever.yang@rock-chips.com> <1406684075-18271-1-git-send-email-kever.yang@rock-chips.com> <53D90CC4.9070009@cogentembedded.com>
In-Reply-To: <53D90CC4.9070009@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 07:18 PM, Sergei Shtylyov wrote:

>> rk3288 has two kind of usb controller, this add the dwc2 controller
>> for otg and host1.

>> Controller can works with usb PHY default setting and Vbus on.

>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>> ---
>>   arch/arm/boot/dts/rk3288.dtsi |   20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)

>> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
>> index abc51f5..4309c4f 100644
>> --- a/arch/arm/boot/dts/rk3288.dtsi
>> +++ b/arch/arm/boot/dts/rk3288.dtsi
>> @@ -646,5 +646,25 @@
>>               clock-names = "baudclk", "apb_pclk";
>>               status = "disabled";
>>           };
>> +
>> +        usb_otg: dwc2@ff580000 {

>     The ePAPR standard [1] says:

> The name of a node should be somewhat generic, reflecting the function of the
> device and not its precise programming model. If appropriate, the name should
> be one of the following choices:

> [...]
>     • usb

>> +            compatible = "rockchip,rk3288-usb", "rockchip,rk3066-usb",
>> +                    "snps,dwc2";
>> +            reg = <0xff580000 0x40000>;
>> +            interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
>> +            clocks = <&cru HCLK_OTG0>;
>> +            clock-names = "otg";
>> +            status = "disabled";
>> +        };
>> +
>> +        usb_host1: dwc2@ff540000 {

>     Same here.

    Oops, forgot to give the ePAPR link:

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei

