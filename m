Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867Ab3LIIHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:07:15 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:64493 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760768Ab3LIIHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:07:10 -0500
Message-ID: <52A57A17.40400@linaro.org>
Date: Mon, 09 Dec 2013 16:06:47 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Rob Herring <robherring2@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linaro Patches <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC part2 PATCH 2/9] ARM64 / ACPI: Prefill cpu possible/present
 maps and map logical cpu id to APIC id
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org> <1386088753-2850-3-git-send-email-hanjun.guo@linaro.org> <CAL_JsqKF-_GCRR1d5Hs0F6pCMfLxUYkXAAp9hY7Ywuu1C+aZ0A@mail.gmail.com> <201312060009.54801.arnd@arndb.de>
In-Reply-To: <201312060009.54801.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-6 7:09, Arnd Bergmann wrote:
> On Wednesday 04 December 2013, Rob Herring wrote:
>>> index a0c2ca6..1428024 100644
>>> --- a/arch/arm64/kernel/smp.c
>>> +++ b/arch/arm64/kernel/smp.c
>>> @@ -420,7 +420,9 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
>>>                 if (err)
>>>                         continue;
>>>
>>> +#ifndef CONFIG_ACPI
>>>                 set_cpu_present(cpu, true);
>>> +#endif
>>
>> Should this be moved to DT cpu topology related code?
> 
> More importantly, the #ifndef is certainly wrong here: It is important that you can
> turn CONFIG_ACPI on or off without impacting the run-time code path for non-ACPI
> systems. The snippet above breaks this because we no longer set the
> cpu mask when ACPI is turned on but not used.

Good point, I'll rework this patch to find a better solution.

Thanks for your comments.

Hanjun

