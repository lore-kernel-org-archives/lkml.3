Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3HPIq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:46:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38458 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab3HPIqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:46:54 -0400
Message-ID: <520DE6F2.8080806@ti.com>
Date: Fri, 16 Aug 2013 14:16:42 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>
Subject: Re: [PATCH] ARM: DTS: DRA7: Add TPS659038 PMIC nodes
References: <1376372556-4244-1-git-send-email-j-keerthy@ti.com> <520C1451.7080203@ti.com>
In-Reply-To: <520C1451.7080203@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 August 2013 05:05 AM, Nishanth Menon wrote:
> linux-omap, linux-arm-list should also be CCed, Benoit needs to be
> addressed for allowing him to merge,
>
> I have not done a proper schematics Vs data manual review yet
> (apologies on that), but, a couple of comments:
>
> On 08/13/2013 12:42 AM, Keerthy wrote:
>> The Patch adds nodes for TPS659038 PMIC for DRA7 boards.
>>
>> It is based on:
>> http://comments.gmane.org/gmane.linux.ports.arm.omap/102459.
>>
>> Documentation:	Documentation/devicetree/bindings/mfd/palmas.txt
>> 		Documentation/devicetree/bindings/regulator/palmas-pmic.txt		
>>
>> Tested on DRA7 Board, 3.11-rc5 plus the above patch-set.
>>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> ---
>>   arch/arm/boot/dts/dra7-evm.dts |  118 ++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 118 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
>> index b270e24..96f409f 100644
>> --- a/arch/arm/boot/dts/dra7-evm.dts
>> +++ b/arch/arm/boot/dts/dra7-evm.dts
<snip>

>> +
>> +				ldo1_reg: ldo1 {
>> +						/* LDO1_OUT --> SDIO  */
>> +						regulator-name = "ldo1";
>> +						regulator-min-microvolt = <1800000>;
>> +						regulator-max-microvolt = <3300000>;
>> +					};
>> +
>> +				ldo2_reg: ldo2 {
>> +						/* VDD_RTCIO */
>> +						regulator-name = "ldo2";
>> +						regulator-min-microvolt = <3300000>;
>> +						regulator-max-microvolt = <3300000>;
>> +						regulator-always-on;
>> +						regulator-boot-on;
>> +					};
>> +
>> +				ldo3_reg: ldo3 {
>> +						/* VDDA_1V8 PHYs */
>> +						regulator-name = "ldo3";
>> +						regulator-min-microvolt = <1800000>;
>> +						regulator-max-microvolt = <1800000>;
>> +					};
>> +
>> +				ldo9_reg: ldo9 {
>> +						/* VDD_RTC */
>> +						regulator-name = "ldo9";
>> +						regulator-min-microvolt = <1000000>;
>> +						regulator-max-microvolt = <1000000>;
>> +						regulator-boot-on;
>> +						regulator-always-on;
>> +					};
>> +
>> +				ldoln_reg: ldoln {
>> +						/* VDDA_1v8: PLLs */
>> +						regulator-name = "ldoln";
>> +						regulator-min-microvolt = <1800000>;
>> +						regulator-max-microvolt = <1800000>;
>> +						regulator-always-on;
>> +						regulator-boot-on;
>> +					};
>> +
>> +				ldousb_reg: ldousb {
>> +						/* VDDA_3V_USB: VDDA_USBHS33 */
>> +						regulator-name = "ldousb";
>> +						regulator-min-microvolt = <3250000>;
>> +						regulator-max-microvolt = <3250000>;
>> +						regulator-always-on;
>> +						regulator-boot-on;
>> +					};
>> +
>> +				};
>> +			};
>> +		};
>
> Who are using these LDOs? Example SDIO LDO should be linked up with
> MMC instance, no? how about the PLLs and PHYs?
>

ldo1_reg would be linked in follow up patches which enables sd/mmc.

>
>>   };
>>
>>   &i2c2 {
>>
>
>
