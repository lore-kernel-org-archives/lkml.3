Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaBRKVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:21:37 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49933 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbaBRKVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:21:35 -0500
Message-ID: <53033433.7080002@linaro.org>
Date: Tue, 18 Feb 2014 11:21:39 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI, PCI, ISA: Fix memory leak when there is no
 IRQ in the ACPI subsystem.
References: <1392037211-29349-1-git-send-email-tomasz.nowicki@linaro.org> <1392037211-29349-2-git-send-email-tomasz.nowicki@linaro.org> <87065822.vfIc9IskHH@vostro.rjw.lan>
In-Reply-To: <87065822.vfIc9IskHH@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.02.2014 02:02, Rafael J. Wysocki wrote:
> On Monday, February 10, 2014 02:00:11 PM Tomasz Nowicki wrote:
>> Whenever we register ISA interrupt or not, we need to free the IRQ routing
>> table entry.
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   drivers/acpi/pci_irq.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
>> index b0e31b6..6ec0f36 100644
>> --- a/drivers/acpi/pci_irq.c
>> +++ b/drivers/acpi/pci_irq.c
>> @@ -432,6 +432,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>>   #endif
>>   		dev_warn(&dev->dev, "PCI INT %c: no GSI\n", pin_name(pin));
>>
>> +		kfree(entry);
>
> If I'm not mistaken, entry is always NULL here, isn't it?
acpi_pci_link_allocate_irq() can return negative gsi even if entry != 
NULL. For that case we'd have memory leak.
>
>>   		return 0;
>>   	}
>>
>>
>
