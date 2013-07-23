Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3GWMuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:50:10 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54456 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab3GWMuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:50:08 -0400
Message-ID: <51EE7BF7.80000@gmail.com>
Date: Tue, 23 Jul 2013 20:49:59 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, acpi: Remove out-of-date comment of __acpi_map_table
References: <51DDA677.9000102@gmail.com> <20130723092214.GB19786@gmail.com>
In-Reply-To: <20130723092214.GB19786@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 05:22 PM, Ingo Molnar wrote:
> 
> * Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:
> 
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>>
>> The implementation of function __acpi_map_table() has been changed
>> long time ago, and now it directly invokes early_ioremap() to setup
>> the temporarily acpi table mappings. So remove its out-of-date
>> comment.
>>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> ---
>>  arch/x86/kernel/acpi/boot.c |   13 +------------
>>  1 files changed, 1 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
>> index d81a972..bac8b5b 100644
>> --- a/arch/x86/kernel/acpi/boot.c
>> +++ b/arch/x86/kernel/acpi/boot.c
>> @@ -140,18 +140,6 @@ static u32 irq_to_gsi(int irq)
>>  	return gsi;
>>  }
>>  
>> -/*
>> - * Temporarily use the virtual area starting from FIX_IO_APIC_BASE_END,
>> - * to map the target physical address. The problem is that set_fixmap()
>> - * provides a single page, and it is possible that the page is not
>> - * sufficient.
>> - * By using this area, we can map up to MAX_IO_APICS pages temporarily,
>> - * i.e. until the next __va_range() call.
>> - *
>> - * Important Safety Note:  The fixed I/O APIC page numbers are *subtracted*
>> - * from the fixed base.  That's why we start at FIX_IO_APIC_BASE_END and
>> - * count idx down while incrementing the phys address.
>> - */
>>  char *__init __acpi_map_table(unsigned long phys, unsigned long size)
> 
> Good catch. Removing documentation makes me sad, so how about replacing it 
> with a simple comment:
> 
> 	/*
> 	 * This is just a simple wrapper around early_ioremap(),
> 	 * with sanity checks for phys == 0 and size == 0:
> 	 */
> 
> ?

Yeah, agreed. So I will send the v2 patch.

> 
> Thanks,
> 
> 	Ingo


-- 
Thanks.
Zhang Yanfei
