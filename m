Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbbAUF0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:26:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:58813 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbbAUF03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:26:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,439,1418112000"; 
   d="scan'208";a="640230034"
Message-ID: <54BF3881.9000708@linux.intel.com>
Date: Wed, 21 Jan 2015 13:26:25 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 08/19] ACPI: Add prefetch decoding to the address
 space parser
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-9-git-send-email-jiang.liu@linux.intel.com> <1593565.fJ4zH7YgDd@vostro.rjw.lan>
In-Reply-To: <1593565.fJ4zH7YgDd@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 8:35, Rafael J. Wysocki wrote:
> On Thursday, January 08, 2015 10:32:55 AM Jiang Liu wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> Add support of PREFETCH attributre to ACPI address space and extended
>> address space parser.
> 
> This potentially enables untested configurations which tends to uncover bugs,
> so I'm concerned.
> 
> What's the possible impact of this?
Hi Rafael,
	I have analyzed all call sites related to this change, most
users just care about resource type(IO, MEM, IRQ etc) and ignore
the prefetch property. Seems only PCI subsystem cares about PREFETCH.
Regards,
Gerry

> 
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/acpi/resource.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
>> index a56a64164410..abe3a29ad802 100644
>> --- a/drivers/acpi/resource.c
>> +++ b/drivers/acpi/resource.c
>> @@ -200,6 +200,9 @@ static bool acpi_decode_space(struct resource *res,
>>  	if (base->producer_consumer == ACPI_PRODUCER)
>>  		res->flags |= IORESOURCE_WINDOW;
>>  
>> +	if (base->info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
>> +		res->flags |= IORESOURCE_PREFETCH;
>> +
>>  	return !(res->flags & IORESOURCE_DISABLED);
>>  }
>>  
>>
> 
