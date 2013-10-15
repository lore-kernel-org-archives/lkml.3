Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab3JOVKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:10:23 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3794 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933713Ab3JOVKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:10:21 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <525DAF2F.7080009@broadcom.com>
Date: Tue, 15 Oct 2013 14:10:07 -0700
From: "Wendy Ng" <wendy.ng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101
 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Eduardo Valentin" <eduardo.valentin@ti.com>
cc: "Rob Herring" <rob.herring@calxeda.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>
Subject: Re: [PATCH v2 3/3] ARM: bcm281xx: Add thermal driver to device
 tree.
References: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com>
 <1380321454-16216-4-git-send-email-wendy.ng@broadcom.com>
 <525B1C77.1070809@ti.com>
In-Reply-To: <525B1C77.1070809@ti.com>
X-WSS-ID: 7E4370A02E41905342-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2013 3:19 PM, Eduardo Valentin wrote:
> On 27-09-2013 18:37, Wendy Ng wrote:
>> This patch adds the device tree node for Broadcom bcm281xx SoCs thermal
>> driver.
>>
>> Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
>> Reviewed-by: Markus Mayer <mmayer@broadcom.com>
>> Reviewed-by: Christian Daudt <csd@broadcom.com>
>> ---
>>   arch/arm/boot/dts/bcm11351-brt.dts |    4 +++-
>>   arch/arm/boot/dts/bcm11351.dtsi    |    6 ++++++
>>   arch/arm/boot/dts/bcm28155-ap.dts  |    4 ++++
>>   3 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
>> index 9d36eb4..0771b6b 100644
>> --- a/arch/arm/boot/dts/bcm11351-brt.dts
>> +++ b/arch/arm/boot/dts/bcm11351-brt.dts
>> @@ -43,5 +43,7 @@
>>   		status = "okay";
>>   	};
>>
>> -
>> +	thermal@34008000 {
>> +		status = "okay";
>> +	};
>>   };
>> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
>> index 05a5aab..aa13353 100644
>> --- a/arch/arm/boot/dts/bcm11351.dtsi
>> +++ b/arch/arm/boot/dts/bcm11351.dtsi
>> @@ -96,4 +96,10 @@
>>   		status = "disabled";
>>   	};
>>
>> +	thermal@34008000 {
>> +		compatible = "brcm,bcm11351-thermal", "brcm,kona-thermal";
>> +		reg = <0x34008000 0x0024>;
>> +		thermal-name = "bcm_kona_therm";
>
> As I mentioned previously, my only concern is this thermal binding,
> which is specific to your driver (BTW, you would need to do
> bcm,thermal-name)
>

Hi Eduardo,

I have a local working copy of the thermal driver that does not use the 
'thermal-name' from this DTS file.  It has been re-based to your working 
version of the new thermal DT binding.

>> +		status = "disabled";
>> +	};
>>   };
>> diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
>> index 96ae67a..a39aa47 100644
>> --- a/arch/arm/boot/dts/bcm28155-ap.dts
>> +++ b/arch/arm/boot/dts/bcm28155-ap.dts
>> @@ -42,4 +42,8 @@
>>   		max-frequency = <48000000>;
>>   		status = "okay";
>>   	};
>> +
>> +	thermal@34008000 {
>> +		status = "okay";
>> +	};
>>   };
>>
>
>


-- 
Best regards,
-Wendy

