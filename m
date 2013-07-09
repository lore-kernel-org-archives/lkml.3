Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3GILWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 07:22:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32842 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3GILWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 07:22:08 -0400
Message-ID: <51DBF23F.20103@ti.com>
Date: Tue, 9 Jul 2013 16:51:35 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>, <afzal@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm: dts: AM43x: Add usb_otg_hs node
References: <1373361446-30050-1-git-send-email-george.cherian@ti.com> <20130709102022.GH5552@arwen.pp.htv.fi>
In-Reply-To: <20130709102022.GH5552@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2013 3:50 PM, Felipe Balbi wrote:
> On Tue, Jul 09, 2013 at 02:47:26PM +0530, George Cherian wrote:
>> Adds device node for HS USB Host module for AM437x
>>
>> changes from v1
>>
>> renamed synopsis to snps
>> removed flag tx-fifo-resize
> the patch revision changes don't need to go to the commit log,
> they should be placed after the tearline (---) and before the diffstat.
>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   arch/arm/boot/dts/am4372.dtsi | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
>> index ddc1df7..c9e0da8 100644
>> --- a/arch/arm/boot/dts/am4372.dtsi
>> +++ b/arch/arm/boot/dts/am4372.dtsi
>> @@ -64,5 +64,23 @@
>>   			compatible = "ti,am4372-counter32k","ti,omap-counter32k";
>>   			reg = <0x44e86000 0x40>;
>>   		};
>> +
>> +		usb_otg_hs1: am4372_dwc3@48380000 {
> dtsi should always have status = "disabled"; no ?
>
>> +			compatible = "ti,am437x-dwc3";
>> +			reg = <0x48380000 0x1ff>;
> weird size, shouldn't this be 0x200 ?
okay
>> +			interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			utmi-mode = <1>;
>> +			ranges;
>> +
>> +			dwc3@48390000 {
> dtsi should always have status = "disabled"; no ?
okay
>
>> +				compatible = "snps,dwc3";
>> +				reg = <0x48390000 0xcfff>;
> weird size, shouldn't this be 0xd000 then the size would be exactly
> 52KiB

okay
>> +				interrupts = <GIC_SPI  168 IRQ_TYPE_LEVEL_HIGH>;
>> +			};
>> +
>> +		};
>> +		
> there two trailing tabs on this line.
>
> Another thing: am437x has 4 instances of this IP, why are you adding
> only one ?

AM437x has got only 2 instances. I have verified only one on HAPS so 
adding only one.

> And why aren't you pasing the PHY nodes here ? The device
> won't work without its PHYs.

Yes true, again in HAPS I  didnt have any PHY configuration to be done.
>


-- 
-George

