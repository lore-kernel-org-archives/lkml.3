Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaEVPOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:14:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:6885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaEVPOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:14:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,887,1392192000"; 
   d="scan'208";a="536084917"
Message-ID: <537E143F.7060701@intel.com>
Date: Thu, 22 May 2014 23:14:07 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rolf Eike Beer <eb@emlix.com>
CC: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 0/9] I2C ACPI operation region handler support
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <53722700.6010001@intel.com> <2676258.HXv5hGZIFG@devpool02> <4867018.HWMf8AlFN3@devpool02>
In-Reply-To: <4867018.HWMf8AlFN3@devpool02>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 10:17 PM, Rolf Eike Beer wrote:
> Rolf Eike Beer wrote:
>> Lan Tianyu wrote:
>>> On 05/13/2014 09:09 PM, Rolf Eike Beer wrote:
>>>> Am Montag, 28. April 2014, 22:27:39 schrieb Lan Tianyu:
>>>>> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart)
>>>>> operation
>>>>> region. It allows ACPI aml code able to access such kind of devices to
>>>>> implement some ACPI standard method.
>>>>>
>>>>> On the Asus T100TA, Bios use GenericSerialBus operation region to
>>>>> access
>>>>> i2c device to get battery info. So battery function depends on the I2C
>>>>> operation region support. Here is the bug link.
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=69011
>
>>>> I have tested this series and got some errors, but no additional
>>>> functionality:
>
>> this is an Aava Inari 8 tablet (pre-release hardware). Please find the DSDT
>> and the dmesg.log attached.
>
> It may be that I have taken the wrong ACPI files. This is the result of a
> fresh run of acpidump, together with the most recent dmesg.log, just in case
> I messed it up.

Hi Rolf:
	I have check the log. I2C ACPI operation region targets to I2C controller which 
has one ACPI node in the ACPI table and is associated with one I2C adapter. 
Graphic with one ACPI handle registers several I2C adapters. This causes attach 
data to the ACPI handle with the same handler several time. The ACPICA function 
will return ALREADY EXIST error code and causes the log you mentioned. There is 
no I2C ACPI operation region under graphic device node and so not break 
function. To avoid these noise logs, I make them only appear under dynamic debug 
mode in the my V3 patchset.


>
> Kernel now is at 60b5f90+some patches:
>
> 8e7bd6f pinctrl: baytrail: Register GPIO chip after chip->to_irq is set
> c4b2230 pinctrl: baytrail: Add back Baytrail-T ACPI ID
> 32f3364 gpio: Add support for Intel SoC PMIC (Crystal Cove)
> 088ee81 mfd: intel_soc_pmic: Build files
> 5315135 mfd: intel_soc_pmic: Crystal Cove support
> 8b5ed0b mfd: intel_soc_pmic: I2C interface
> b18979f mfd: intel_soc_pmic: Core driver
> 5200b75 add debugging
>    (This is the debug patch Lan Tianyu sent as reply to the previous mail)
> bd3e6c6 I2C/ACPI: Add CONFIG_I2C_ACPI config
> 947f0a1 I2C/ACPI: Move ACPI related code to i2c-acpi.c
> 534f182 I2C/ACPI: Add i2c ACPI operation region support
> 32384d4 I2C: Add smbus word/block process call helper function
> aa6459e I2C: Add smbus quick read/write helper function
> 51825ed ACPI/Thermal: Use acpi_bus_attach_private_data() to attach private data
> 95e9e92 ACPI: Add acpi_bus_attach_private_data() to facilitate to attach data to ACPI handle
> cc6fecb ACPICA: Export acpi_buffer_to_resource symbol
> ad38de6 ACPI / LPSS: custom power domain for LPSS
> b0caadf ACPI / PM: Export rest of the subsys functions
> 22a7210 ACPI / platform: add another ID for Broadcom Bluetooth and GPS chips
>   (this just adds AAM4752 as another platform id)
> 000627d ACPI / platform: add IDs for Broadcom Bluetooth and GPS chips
>
> Eike
>

