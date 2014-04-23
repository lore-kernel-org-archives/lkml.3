Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaDWFri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:47:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:59715 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaDWFrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:47:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="517734872"
Message-ID: <53575227.7080407@intel.com>
Date: Wed, 23 Apr 2014 13:39:51 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "Zheng, Lv" <lv.zheng@intel.com>
Subject: Re: [Resend Patch 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com> <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398147855-9868-10-git-send-email-tianyu.lan@intel.com> <20140422114510.GM30677@intel.com>
In-Reply-To: <20140422114510.GM30677@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年04月22日 19:45, Mika Westerberg wrote:
> On Tue, Apr 22, 2014 at 02:24:15PM +0800, Lan Tianyu wrote:
>> This patch is to add CONFIG_I2C_ACPI. Current there is a race between
>> removing I2C ACPI operation region and ACPI AML code accessing.
>> So make i2c core built-in if CONFIG_I2C_ACPI is set.
>>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>  drivers/i2c/Kconfig  | 17 ++++++++++++++++-
>>  drivers/i2c/Makefile |  2 +-
>>  include/linux/i2c.h  |  2 +-
>>  3 files changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
>> index 7b7ea32..c670d49 100644
>> --- a/drivers/i2c/Kconfig
>> +++ b/drivers/i2c/Kconfig
>> @@ -2,7 +2,9 @@
>>  # I2C subsystem configuration
>>  #
>>  
>> -menuconfig I2C
>> +menu "I2C support"
>> +
>> +config I2C
>>  	tristate "I2C support"
>>  	select RT_MUTEXES
>>  	---help---
>> @@ -21,6 +23,17 @@ menuconfig I2C
>>  	  This I2C support can also be built as a module.  If so, the module
>>  	  will be called i2c-core.
>>  
>> +config I2C_ACPI
>> +	bool "I2C ACPI support"
>> +	select I2C
>> +	depends on ACPI
>> +	default y
>> +	help
>> +	  Say Y here if you want to enable I2C ACPI function. ACPI table
>> +	  provides I2C slave devices' information to enumerate these devices.
>> +	  This option also allows ACPI AML code to access I2C slave devices
>> +	  via I2C ACPI operation region to fulfill ACPI method.
>> +
> 
> I'm wondering, can we provide some sort of wrapper function from ACPI core
> that is guaranteed to be built in to the kernel image and use it instead of
> adding new Kconfig options?
> 
Cc: LV

LV tried to fix the issue via wrapper solution in the ACPI code before.
https://lkml.org/lkml/2013/7/23/87

He has a plan to resolve the issue in ACPICA later.

Other choice is to increase the i2c-core module count to prevent it
being unloaded when i2c operation region handler is installed. Remove
the code When LV finish his job.

-- 
Best regards
Tianyu Lan
