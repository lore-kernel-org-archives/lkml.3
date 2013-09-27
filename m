Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3I0WuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 18:50:01 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4661 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab3I0Wt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 18:49:59 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <52460B90.5060907@broadcom.com>
Date: Fri, 27 Sep 2013 15:49:52 -0700
From: "Wendy Ng" <wendy.ng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Matt Porter" <matt.porter@linaro.org>
cc: "Rob Herring" <rob.herring@calxeda.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>
Subject: Re: [PATCH 1/3] thermal: bcm281xx: Add thermal driver
References: <1379958698-7554-1-git-send-email-wendy.ng@broadcom.com>
 <1379958698-7554-2-git-send-email-wendy.ng@broadcom.com>
 <20130925192609.GB25191@ohporter.com>
In-Reply-To: <20130925192609.GB25191@ohporter.com>
X-WSS-ID: 7E58D5871R095398652-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 9/25/2013 12:26 PM, Matt Porter wrote:
> On Mon, Sep 23, 2013 at 10:51:36AM -0700, Wendy Ng wrote:
>> This adds the support for reading out temperature from Broadcom bcm281xx
>> SoCs.
>>
>> Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
>> Reviewed-by: Markus Mayer <mmayer@broadcom.com>
>> Reviewed-by: Christian Daudt <csd@broadcom.com>
>> ---
>>   .../bindings/thermal/bcm-kona-thermal.txt          |   18 +++
>>   drivers/thermal/Kconfig                            |   10 ++
>>   drivers/thermal/Makefile                           |    1 +
>>   drivers/thermal/bcm_thermal.c                      |  170 ++++++++++++++++++++
>>   4 files changed, 199 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
>>   create mode 100644 drivers/thermal/bcm_thermal.c
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
>> new file mode 100644
>> index 0000000..acca99e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
>> @@ -0,0 +1,18 @@
>> +* Broadcom Kona Thermal Management Unit
>> +
>> +This version is for the BCM281xx family of SoCs.
>> +
>> +Required properties:
>> +- compatible : "brcm,bcm11351-thermal", "brcm,kona-thermal"
>> +- reg : Address range of the thermal register
>> +- thermal-name: this entry must be specified and it will be passed into
>> +thermal_zone_device_register().  This name will also be reported under Hwmon
>> +sysfs 'name' attribute.
>> +
>> +Example:
>> +	thermal@34008000 {
>> +		compatible = "brcm,bcm11351-thermal", "brcm,kona-thermal";
>> +		reg = <0x34008000 0x0024>;
>> +		thermal-name = "bcm_kona_therm";
>> +		status = "disabled";
>> +	};
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index dbfc390..7f823f0 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -134,6 +134,16 @@ config KIRKWOOD_THERMAL
>>   	  Support for the Kirkwood thermal sensor driver into the Linux thermal
>>   	  framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
>>   
>> +config BCM_THERMAL
>> +	tristate "Temperature sensor on Broadcom BCM281xx family of SoCs"
>> +	depends on ARCH_BCM
> Hi Wendy,
>
> I just noticed that, depending on acceptance, this could collide with
> Christian's ARCH_BCM->ARCH_BCM_MOBILE rename that is expected to go into
> 3.13. I'm not sure if this series is targeted for 3.13 (due to the discussion
> about Eduardo's subsystem changes that impact it). If it is, you might
> want to rebase on Christian's rename series
> http://www.spinics.net/lists/arm-kernel/msg274963.html and use
> ARCH_BCM_MOBILE here.
>
> -Matt
Hi Matt,

I have uploaded v2 of this thermal driver patch series to make it 
compatible with Christian's
ARCH_BCM->ARCH_BCM_MOBILE changes.

Thanks for pointing this out!

>> +	default y
>> +	help
>> +	  If you say yes here you get support for TMU (Thermal Management
>> +	  Unit) on Broadcom BCM281xx family of SoCs. This provides thermal
>> +	  monitoring of CPU clusters, graphics, and SoC glue, but does not
>> +	  include monitoring of charger temperature.
>

-- 
Best regards,
-Wendy


