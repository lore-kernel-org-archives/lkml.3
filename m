Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaAOLWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:22:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaAOLWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:22:21 -0500
Message-ID: <52D66F4B.8080301@redhat.com>
Date: Wed, 15 Jan 2014 06:21:47 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kosaki.motohiro@gmail.com, dyoung@redhat.com, toshi.kani@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH] acpi memory hotplug, add parameter to disable memory
 hotplug [v3]
References: <1389727273-27817-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.02.1401141642020.3375@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401141642020.3375@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/14/2014 07:42 PM, David Rientjes wrote:
> On Tue, 14 Jan 2014, Prarit Bhargava wrote:
> 
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index b9e9bd8..ea93f75 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -343,6 +343,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  			no: ACPI OperationRegions are not marked as reserved,
>>  			no further checks are performed.
>>  
>> +	acpi_no_memhotplug [ACPI] Disable memory hotplug.  Useful for kexec
>> +			   and kdump kernels.
>> +
>>  	add_efi_memmap	[EFI; X86] Include EFI memory map in
>>  			kernel's map of available physical RAM.
>>  
>> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
>> index 551dad7..4a0fa94 100644
>> --- a/drivers/acpi/acpi_memhotplug.c
>> +++ b/drivers/acpi/acpi_memhotplug.c
>> @@ -361,7 +361,19 @@ static void acpi_memory_device_remove(struct acpi_device *device)
>>  	acpi_memory_device_free(mem_device);
>>  }
>>  
>> +static bool acpi_no_memhotplug;
>> +
> 
> I think this should be annotated with __initdata.

Yep, I'll shoot out a v4 with that change.

P.

> 
>>  void __init acpi_memory_hotplug_init(void)
>>  {
>> +	if (acpi_no_memhotplug)
>> +		return;
>> +
>>  	acpi_scan_add_handler_with_hotplug(&memory_device_handler, "memory");
>>  }
>> +
>> +static int __init disable_acpi_memory_hotplug(char *str)
>> +{
>> +	acpi_no_memhotplug = true;
>> +	return 1;
>> +}
>> +__setup("acpi_no_memhotplug", disable_acpi_memory_hotplug);
