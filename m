Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaGHKIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:08:00 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54028 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaGHKH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:07:59 -0400
Message-ID: <53BBC2F9.4070808@linaro.org>
Date: Tue, 08 Jul 2014 18:07:53 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 2/4] ACPI: Don't use acpi_lapic in ACPI core code
References: <1404290847-7671-1-git-send-email-hanjun.guo@linaro.org> <1404290847-7671-3-git-send-email-hanjun.guo@linaro.org> <2058650.s5vKv1ibCp@vostro.rjw.lan>
In-Reply-To: <2058650.s5vKv1ibCp@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月08日 05:08, Rafael J. Wysocki wrote:
> On Wednesday, July 02, 2014 04:47:24 PM Hanjun Guo wrote:
>> From: Graeme Gregory <graeme.gregory@linaro.org>
>>
>> Now ARM64 support is being added to ACPI so architecture specific
>> values can not be used in core ACPI code.
>>
>> Following on the patch "ACPI / processor: Check if LAPIC is present
>> during initialization" which uses acpi_lapic in acpi_processor.c,
>> on ARM64 platform, GIC is used instead of local APIC, so acpi_lapic
>> is not a suitable value for ARM64.
>>
>> What is actually important at this point is the SMPness of the system,
>> so introduce acpi_arch_is_smp() to be arch specific and generic.
>>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  arch/ia64/include/asm/acpi.h  |    5 +++++
>>  arch/x86/include/asm/acpi.h   |    5 +++++
>>  drivers/acpi/acpi_processor.c |    2 +-
>>  3 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
>> index 75dc59a..2fc0757 100644
>> --- a/arch/ia64/include/asm/acpi.h
>> +++ b/arch/ia64/include/asm/acpi.h
>> @@ -40,6 +40,11 @@ extern int acpi_lapic;
>>  #define acpi_noirq 0	/* ACPI always enabled on IA64 */
>>  #define acpi_pci_disabled 0 /* ACPI PCI always enabled on IA64 */
>>  #define acpi_strict 1	/* no ACPI spec workarounds on IA64 */
>> +
>> +static inline bool acpi_arch_is_smp(void)
> Why this name?  In particular, local APIC being present doesn't imply SMP.

Hmm, agreed. How about acpi_has_cpu_in_madt()? As we know,
Local APIC/SAPIC in MADT stands for CPU in the system, how about
the function name above?

>
>> +{
>> +	return acpi_lapic;
> Also
>
> 	return !!acpi_lapic;
>
> would be cleaner IMO.
>

I will update it as you suggested.

Thanks
Hanjun
