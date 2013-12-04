Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab3LDPkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:40:07 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:34534 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3LDPkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:40:05 -0500
MIME-Version: 1.0
In-Reply-To: <529F3A57.7010306@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
	<1386088753-2850-3-git-send-email-hanjun.guo@linaro.org>
	<20131203165755.37b07796@alan.etchedpixels.co.uk>
	<529F3A57.7010306@linaro.org>
Date: Wed, 4 Dec 2013 09:40:04 -0600
Message-ID: <CAL_JsqLGkxS13NAGJfqExFii-RcF3xRsvucjQbFoHeP5zoRkxA@mail.gmail.com>
Subject: Re: [RFC part2 PATCH 2/9] ARM64 / ACPI: Prefill cpu possible/present
 maps and map logical cpu id to APIC id
From: Rob Herring <robherring2@gmail.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linaro Patches <patches@linaro.org>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-acpi@lists.linaro.org, linux-acpi@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 8:21 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> On 2013年12月04日 00:57, One Thousand Gnomes wrote:
>>>
>>> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
>>> index 45ff625..8527ecc 100644
>>> --- a/drivers/acpi/plat/arm-core.c
>>> +++ b/drivers/acpi/plat/arm-core.c
>>> @@ -58,6 +58,13 @@ EXPORT_SYMBOL(acpi_pci_disabled);
>>>    */
>>>   static u64 acpi_lapic_addr __initdata;
>>>   +/* available_cpus here means enabled cpu in MADT */
>>> +int available_cpus;
>>> +
>>> +/* Map logic cpu id to physical GIC id. */
>>> +int arm_cpu_to_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = -1 };
>>> +int boot_cpu_apic_id = -1;
>>> +
>>
>> static ?
>>
>> Really shouldn't be leaking names like "available_cpus" out of ACPI into
>> the global namespace
>
>
> Ok, will update in next version.
>
>
>
>>> +#ifdef CONFIG_SMP
>>> +       if (available_cpus == 0) {
>>> +               pr_info(PREFIX "Found 0 CPUs; assuming 1\n");
>>> +               /* FIXME: should be the real GIC id read from hardware */
>>> +               arm_cpu_to_apicid[available_cpus] = 0;
>>> +               available_cpus = 1;     /* We've got at least one of
>>> these */
>>> +       }
>>> +#endif
>>
>> Isn't this true uniprocessor (by definition in fact)
>
>
> This code is intend to handle some buggy firmware I think.

Really? We have production firmware already that we need to
work-around? That's impressive given there is no production h/w.

Rob
