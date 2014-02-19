Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaBSK2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:28:03 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53697 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaBSK2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:28:00 -0500
Message-ID: <53048736.7020106@linaro.org>
Date: Wed, 19 Feb 2014 11:28:06 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ACPI, PCI, ISA: Call ISA-specific code only for architectures
 which support ISA.
References: <1392037211-29349-1-git-send-email-tomasz.nowicki@linaro.org> <1463162.p1Ukb4737y@vostro.rjw.lan>
In-Reply-To: <1463162.p1Ukb4737y@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 15.02.2014 02:05, Rafael J. Wysocki wrote:
> On Monday, February 10, 2014 02:00:10 PM Tomasz Nowicki wrote:
>> This commit enables ISA-specific code if and only if CONFIG_{E}ISA is set
>> in the kernel configuration so that we do not have to maintain
>> acpi_isa_irq_to_gsi() function for architectures which do not support ISA.
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   drivers/acpi/pci_irq.c |    8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
>> index 41c5e1b..b0e31b6 100644
>> --- a/drivers/acpi/pci_irq.c
>> +++ b/drivers/acpi/pci_irq.c
>> @@ -418,6 +418,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>>   	 * driver reported one, then use it. Exit in any case.
>>   	 */
>>   	if (gsi < 0) {
>> +#if IS_ENABLED(CONFIG_ISA) || IS_ENABLED(CONFIG_EISA)
>
> Can you please move the code in question into a separate function and make
> that function depend on the above (with an empty stub for when they are not
> enabled)?
Thanks for suggestion, I will resend as next version.
>
>>   		u32 dev_gsi;
>>   		/* Interrupt Line values above 0xF are forbidden */
>>   		if (dev->irq > 0 && (dev->irq <= 0xF) &&
>> @@ -427,10 +428,9 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>>   			acpi_register_gsi(&dev->dev, dev_gsi,
>>   					  ACPI_LEVEL_SENSITIVE,
>>   					  ACPI_ACTIVE_LOW);
>> -		} else {
>> -			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
>> -				 pin_name(pin));
>> -		}
>> +		} else
>> +#endif
>> +		dev_warn(&dev->dev, "PCI INT %c: no GSI\n", pin_name(pin));
>>
>>   		return 0;
>>   	}
>>
>
