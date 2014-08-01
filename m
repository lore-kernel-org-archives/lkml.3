Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaHAFXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:23:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49030 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaHAFXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:23:03 -0400
Message-ID: <53DB240F.2030908@ti.com>
Date: Fri, 1 Aug 2014 08:22:23 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <nsekhar@ti.com>,
        <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <khilman@deeprootsystems.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/6] ARM: DTS: da850-evm: Add node for tlv320aic3106 codec
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com> <1406801934-23334-6-git-send-email-peter.ujfalusi@ti.com> <53DA519A.4090905@cogentembedded.com>
In-Reply-To: <53DA519A.4090905@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 05:24 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 07/31/2014 02:18 PM, Peter Ujfalusi wrote:
> 
>> The board uses aic3106 for audio.
> 
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>   arch/arm/boot/dts/da850-evm.dts | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
> 
>> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
>> index 09118c72e83f..b9ef2be0b145 100644
>> --- a/arch/arm/boot/dts/da850-evm.dts
>> +++ b/arch/arm/boot/dts/da850-evm.dts
>> @@ -51,6 +51,20 @@
>>               tps: tps@48 {
>>                   reg = <0x48>;
>>               };
>> +            tlv320aic3106: tlv320aic3106@1b {
> 
>    The "reg" property is <0x18>, why the unit-address part of a name is
> different?

True, I have lifted the codec part from other dts file and overlooked the
unit-address.
I will resend the series with this fixed.


> Also, the ePAPR standard [1] says:
> 
> The name of a node should be somewhat generic, reflecting the function of the
> device and not its precise programming model.

True. This is why the node for the audio support is named as 'sound'. For the
components, like in this case I do not see issue to call the audio codec with
it's name.

> 
>> +                #sound-dai-cells = <0>;
>> +                compatible = "ti,tlv320aic3106";
>> +                reg = <0x18>;
>> +                status = "okay";
>> +
>> +                /* Regulators */
>> +                IOVDD-supply = <&vdcdc2_reg>;
>> +                /* Derived from VBAT: Baseboard 3.3V / 1.8V */
>> +                AVDD-supply = <&vbat>;
>> +                DRVDD-supply = <&vbat>;
>> +                DVDD-supply = <&vbat>;
>> +            };
>> +
> 
> [1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

BTW: there's a newer version available:
https://www.power.org/wp-content/uploads/2012/06/Power_ePAPR_APPROVED_v1.1.pdf

> 
> WBR, Sergei
> 


-- 
Péter
