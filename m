Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaEUCQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:16:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:1785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaEUCQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:16:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,877,1392192000"; 
   d="scan'208";a="543970540"
Message-ID: <537C0C6D.4030203@intel.com>
Date: Wed, 21 May 2014 10:16:13 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: wsa@the-dreams.de, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 0/5] I2C ACPI operation region handler
References: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com> <6169981.jIBZPeBvRE@vostro.rjw.lan>
In-Reply-To: <6169981.jIBZPeBvRE@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年05月21日 05:25, Rafael J. Wysocki wrote:
> On Tuesday, May 20, 2014 08:59:19 PM Lan Tianyu wrote:
>> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation
>> region. It allows ACPI aml code able to access such kind of devices to
>> implement some ACPI standard method.
>>
>> On the Asus T100TA, Bios use GenericSerialBus operation region to access
>> i2c device to get battery info. So battery function depends on the I2C
>> operation region support. Here is the bug link.
>> https://bugzilla.kernel.org/show_bug.cgi?id=69011
>>
>> Change since V2:
>>         Drop patchs of adding I2C smbus quick read/write and word/block
>> process call functions because not find machines supporting such protocols
>> so far and can't test these functions.
>>         Merge patchs of "I2C ACPI related code clear up" and "Add CONFIG_I2C_ACPI
>> config"
>> 	Patch 2: Add acpi_bus_detach_private_data() function to detach data from
>> ACPI handle and replace ACPI_ERROR() with acpi_handle_debug() to avoid some redundant
>> error log.  
>>
>> Change since V1:
>>        Fix some code style issues. Change prefix i2c_acpi to acpi_i2c.
>> Move ACPI related code in the i2c core to i2c-acpi.c. Add CONFIG_I2C_ACPI
>> and make i2c core built-in when it's set to avoid i2c ACPI operation region
>> being removed.
>>
>> Lan Tianyu (5):
>>   ACPICA: Export acpi_buffer_to_resource symbol
> 
> Redundant?

Yes.

> 
>>   ACPI: Add acpi_bus_attach_private_data() to facilitate to attach data
>>     to ACPI handle
>>   ACPI/Thermal: Use acpi_bus_attach_private_data() to attach private
>>     data
> 
> I can take the above two regardless of the I2C material below I guess?

Yes.

> 
>>   I2C/ACPI: Add i2c ACPI operation region support
>>   I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI config
>>
>>  drivers/acpi/acpica/rscreate.c |   1 +
>>  drivers/acpi/bus.c             |  28 +++-
>>  drivers/acpi/thermal.c         |  11 +-
>>  drivers/i2c/Kconfig            |  18 +-
>>  drivers/i2c/Makefile           |   5 +-
>>  drivers/i2c/i2c-acpi.c         | 362 +++++++++++++++++++++++++++++++++++++++++
>>  drivers/i2c/i2c-core.c         |  97 +----------
>>  include/acpi/acpi_bus.h        |   2 +
>>  include/linux/acpi.h           |  11 ++
>>  include/linux/i2c.h            |  12 ++
>>  10 files changed, 439 insertions(+), 108 deletions(-)
>>  create mode 100644 drivers/i2c/i2c-acpi.c
>>
>>
> 


-- 
Best regards
Tianyu Lan
