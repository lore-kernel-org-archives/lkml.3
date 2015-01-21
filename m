Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbbAUCSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:18:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:33301 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbAUCS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:18:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,439,1418112000"; 
   d="scan'208";a="640176752"
Message-ID: <54BF0C71.5080508@linux.intel.com>
Date: Wed, 21 Jan 2015 10:18:25 +0800
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
Subject: Re: [RFC Patch 12/19] ACPI: Enforce stricter checks for address space
 descriptors
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-13-git-send-email-jiang.liu@linux.intel.com> <12267175.FvlCJYWCa5@vostro.rjw.lan>
In-Reply-To: <12267175.FvlCJYWCa5@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 8:45, Rafael J. Wysocki wrote:
> On Thursday, January 08, 2015 10:32:59 AM Jiang Liu wrote:
>> Enforce stricter checks for address space descriptors according to
>> ACPI spec.
> 
> So is the spec the only reason for doing this?  If so, I'd say don't.
Hi Rafael,
	Yes, it's just for spec. I will drop this patch to avoid
regressions.
Regards!
Gerry

> 
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/acpi/resource.c |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
>> index 26b47f1da523..e82149e44347 100644
>> --- a/drivers/acpi/resource.c
>> +++ b/drivers/acpi/resource.c
>> @@ -192,6 +192,14 @@ static bool acpi_decode_space(struct resource *res,
>>  	bool wp = base->info.mem.write_protect;
>>  	u64 len = addr->address_length;
>>  
>> +	/*
>> +	 * Filter out invalid descriptor according to ACPI Spec 5.0, section
>> +	 * 6.4.3.5 Address Space Resource Descriptors.
>> +	 */
>> +	if ((base->min_address_fixed != base->max_address_fixed && len) ||
>> +	    (base->min_address_fixed && base->max_address_fixed && !len))
>> +		return false;
>> +
>>  	res->start = addr->minimum;
>>  	res->end = addr->maximum;
>>  
>>
> 
