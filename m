Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaHNUXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 16:23:42 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:43505 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbaHNUXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 16:23:40 -0400
Message-ID: <53ED1A87.6000400@ladisch.de>
Date: Thu, 14 Aug 2014 22:22:31 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
CC: jdelvare@suse.de, rdunlap@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.carpenter@oracle.com,
        lm-sensors@lm-sensors.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] hwmon, k10temp: Add support for F15h M60h
References: <1408035262-18026-1-git-send-email-aravind.gopalakrishnan@amd.com>
	<20140814201730.GA501@roeck-us.net>
In-Reply-To: <20140814201730.GA501@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20140814202329.410150.95571@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck wrote:> On Thu, Aug 14, 2014 at 11:54:22AM -0500, Aravind Gopalakrishnan wrote:
>> This patch adds temperature monitoring support for F15h M60h processor.
>>  - Add new pci device id for the relevant processor
>>  - The functionality of REG_REPORTED_TEMPERATURE is moved to
>>    D0F0xBC_xD820_0CA4 [Reported Temperature Control]
>>    - So, use this to get CUR_TEMP value
>>    - Since we need an indirect register access, protect this with
>>      a mutex lock
>>  - Add Kconfig, Doc entries to indicate support for this processor.
>>
>> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
>> ---
>> Changes in V2:
>>  - Prevent race with other code that may require indirect NB_SMU_REG access
>>  - Fix some minor style issues
>>
>>  Documentation/hwmon/k10temp   |  2 +-
>>  arch/x86/include/asm/amd_nb.h |  2 ++
>>  arch/x86/kernel/amd_nb.c      | 15 +++++++++++++++
>>  drivers/hwmon/Kconfig         |  6 +++---
>>  drivers/hwmon/k10temp.c       | 22 +++++++++++++++++++---
>>  5 files changed, 40 insertions(+), 7 deletions(-)
>>
> [ ... ]
>
>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>> index 02d3d85..0234a08 100644
>> --- a/drivers/hwmon/Kconfig
>> +++ b/drivers/hwmon/Kconfig
>> @@ -275,13 +275,13 @@ config SENSORS_K8TEMP
>>
>>  config SENSORS_K10TEMP
>>  	tristate "AMD Family 10h+ temperature sensor"
>> -	depends on X86 && PCI
>> +	depends on X86 && PCI && AMD_NB
>
> Is the added dependency acceptable ?

Yes, it is automatically set from CPU_SUP_AMD.


Regards,
Clemens
