Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbbAPA64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 19:58:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:10327 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbbAPA6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 19:58:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,407,1418112000"; 
   d="scan'208";a="638047186"
Message-ID: <54B8624B.1050705@linux.intel.com>
Date: Fri, 16 Jan 2015 08:58:51 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 16/19] ACPI: Introduce helper function acpi_dev_filter_resource_type()
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-17-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1501152228560.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501152228560.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/16 5:30, Thomas Gleixner wrote:
> On Thu, 8 Jan 2015, Jiang Liu wrote:
> 
>> Introduce helper function acpi_dev_filter_resource_type(), which may
>> be used by acpi_dev_get_resources() to filer out resource based on
>> resource type.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/acpi/resource.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/acpi.h    |    1 +
>>  2 files changed, 55 insertions(+)
>>
>> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
>> index 54204ac94f8e..8ea7c26d6915 100644
>> --- a/drivers/acpi/resource.c
>> +++ b/drivers/acpi/resource.c
>> @@ -570,3 +570,57 @@ int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
>>  	return c.count;
>>  }
>>  EXPORT_SYMBOL_GPL(acpi_dev_get_resources);
>> +
>> +/**
>> + * acpi_dev_filter_resource_type - Filter ACPI resource according to resource
>> + *				   types
>> + * @ares: Input ACPI resource object.
>> + * @arg: Valid resource types of IORESOURCE_XXX
>> + *
>> + * This is a hepler function to support acpi_dev_get_resources(), which filters
>> + * ACPI resource objects according to resource types.
>> + */
>> +int acpi_dev_filter_resource_type(struct acpi_resource *ares, void *arg)
> 
> Why is the filter a void pointer instead of an simple unsigned long?
> That does not make any sense as you convert it to unsigned long right away:
> 
>> +{
>> +	unsigned long type = 0, types = (unsigned long)arg;
> 
> So this should be:
> 
> int acpi_dev_filter_resource_type(struct acpi_resource *ares, unsigned long type_mask)
> 
> or something like that.
Hi Thomas,
	I used void * instead of unsigned long for type_mask so
acpi_dev_filter_resource_type() could directly used by
acpi_dev_get_resources(). Otherwise we need to use something like
acpi_dev_get_resources(..., (void *)acpi_dev_filter_resource_type, ...).
I will find a way to solve this:)
Regards!
Gerry

> 
> Thanks,
> 
> 	tglx
> 
