Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaA1BU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:20:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:46190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbaA1BUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:20:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,732,1384329600"; 
   d="scan'208";a="471766902"
Message-ID: <52E705D4.3010806@linux.intel.com>
Date: Tue, 28 Jan 2014 09:20:20 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        David Rientjes <rientjes@google.com>
CC: Jorg Otte <jrg.otte@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: reduce log level for message "ACPI: \_PR_.CPU4:
 failed to get CPU APIC ID"
References: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com> <1390804498-30311-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1401271615580.17114@chino.kir.corp.google.com> <52E6F9B9.1070900@intel.com>
In-Reply-To: <52E6F9B9.1070900@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/1/28 8:28, Rafael J. Wysocki wrote:
> On 1/28/2014 1:18 AM, David Rientjes wrote:
>> On Mon, 27 Jan 2014, Jiang Liu wrote:
>>
>>> diff --git a/drivers/acpi/acpi_processor.c
>>> b/drivers/acpi/acpi_processor.c
>>> index c9311be..c29c2c3 100644
>>> --- a/drivers/acpi/acpi_processor.c
>>> +++ b/drivers/acpi/acpi_processor.c
>>> @@ -261,7 +261,7 @@ static int acpi_processor_get_info(struct
>>> acpi_device *device)
>>>         apic_id = acpi_get_apicid(pr->handle, device_declaration,
>>> pr->acpi_id);
>>>       if (apic_id < 0) {
>>> -        acpi_handle_err(pr->handle, "failed to get CPU APIC ID.\n");
>>> +        acpi_handle_debug(pr->handle, "failed to get CPU APIC ID.\n");
>>>           return -ENODEV;
>>>       }
>> Don't we already leave some artifact in the kernel log at boot about apic
>> ids that don't get registered?  I'm wondering if we should have this
>> warning at all.
> 
> It is useful for knowing that there are potentially broken objects in
> the ACPI tables.
And it's very useful to identify BIOS bug in case of CPU hot-addition.
It caused our test team about 1 week to identify BIOS bug in CPU
hot-addition, so I added this debug message.
Thanks!
Gerry
> 
> 
