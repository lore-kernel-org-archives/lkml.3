Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaESJp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:45:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:38007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbaESJpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:45:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,866,1392192000"; 
   d="scan'208";a="513825508"
Message-ID: <5379D28F.1020200@intel.com>
Date: Mon, 19 May 2014 17:44:47 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
CC: rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-10-git-send-email-tianyu.lan@intel.com> <20140429081609.GF1684@lahna.fi.intel.com> <20140517174834.GA2858@katana> <20140519084944.GH2067@lahna.fi.intel.com>
In-Reply-To: <20140519084944.GH2067@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 04:49 PM, Mika Westerberg wrote:
> On Sat, May 17, 2014 at 07:48:34PM +0200, Wolfram Sang wrote:
>> On Tue, Apr 29, 2014 at 11:16:09AM +0300, Mika Westerberg wrote:
>>> On Mon, Apr 28, 2014 at 10:27:48PM +0800, Lan Tianyu wrote:
>>>> This patch is to add CONFIG_I2C_ACPI. Current there is a race between
>>>> removing I2C ACPI operation region and ACPI AML code accessing.
>>>> So make i2c core built-in if CONFIG_I2C_ACPI is set.
>>>>
>>>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>>> ---
>>>>   drivers/i2c/Kconfig  | 17 ++++++++++++++++-
>>>>   drivers/i2c/Makefile |  2 +-
>>>>   include/linux/i2c.h  |  2 +-
>>>>   3 files changed, 18 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
>>>> index 7b7ea32..c670d49 100644
>>>> --- a/drivers/i2c/Kconfig
>>>> +++ b/drivers/i2c/Kconfig
>>>> @@ -2,7 +2,9 @@
>>>>   # I2C subsystem configuration
>>>>   #
>>>>
>>>> -menuconfig I2C
>>>> +menu "I2C support"
>>>> +
>>>> +config I2C
>>>>   	tristate "I2C support"
>>>>   	select RT_MUTEXES
>>>>   	---help---
>>>> @@ -21,6 +23,17 @@ menuconfig I2C
>>>>   	  This I2C support can also be built as a module.  If so, the module
>>>>   	  will be called i2c-core.
>>>>
>>>> +config I2C_ACPI
>>>> +	bool "I2C ACPI support"
>>>> +	select I2C
>>>> +	depends on ACPI
>>>> +	default y
>>>> +	help
>>>> +	  Say Y here if you want to enable I2C ACPI function. ACPI table
>>>> +	  provides I2C slave devices' information to enumerate these devices.
>>>> +	  This option also allows ACPI AML code to access I2C slave devices
>>>> +	  via I2C ACPI operation region to fulfill ACPI method.
>>>
>>> I would prefer something like:
>>>
>>> Say Y here if you want to enable ACPI I2C support. This includes support
>>> for automatic enumeration of I2C slave devices and support for ACPI I2C
>>> Operation Regions. Operation Regions allow firmware (BIOS) code to
>>> access I2C slave devices, such as smart batteries through an I2C host
>>> controller driver.
>>>
>>> But it is really up to you so,
>>>
>>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>
>> How does this fit into the context of
>> 55e71edb81b2b45273e7b284cce13ff24bde846f ("i2c: move ACPI helpers into
>> the core")?
>
> With that commit we moved ACPI code to live inside I2C module (given
> that it was compiled as a module). However, you still can remove that
> module from userspace.
>
> With this patch we make sure that the I2C core can't be removed if you
> have ACPI enabled. This prevents the potential race.
>

Yes, these are the two patches' purposes. Thanks Mika's explanation. If you 
like, I can merge them into one patch.

