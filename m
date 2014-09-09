Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaIIQnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:43:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbaIIQnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:43:01 -0400
Message-ID: <540F2DCF.1010104@redhat.com>
Date: Tue, 09 Sep 2014 12:41:51 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        linux-acpi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 02/17] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-3-git-send-email-hanjun.guo@linaro.org> <20140909162648.GE2910@arm.com>
In-Reply-To: <20140909162648.GE2910@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 12:26 PM, Catalin Marinas wrote:
> On Mon, Sep 01, 2014 at 03:57:40PM +0100, Hanjun Guo wrote:
>> diff --git a/arch/arm64/include/asm/acenv.h b/arch/arm64/include/asm/acenv.h
>> new file mode 100644
>> index 0000000..3899ee6
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/acenv.h
>> @@ -0,0 +1,18 @@
>> +/*
>> + * ARM64 specific ACPICA environments and implementation
>> + *
>> + * Copyright (C) 2014, Linaro Ltd.
>> + *   Author: Hanjun Guo <hanjun.guo@linaro.org>
>> + *   Author: Graeme Gregory <graeme.gregory@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef _ASM_ACENV_H
>> +#define _ASM_ACENV_H
>> +
>> +#define ACPI_FLUSH_CPU_CACHE() WARN_ONCE(1, "Not currently supported on ARM64")
> 
> Does this mean that it will be supported at some point? Looking at the
> places where this function is called, I don't really see how this would
> ever work on ARM. Which means that we add such macro just to be able to
> compile code that would never be used on arm64. I would rather see the
> relevant ACPI files only compiled on x86/IA-64 rather than arm64.

That specific cache behavior is a part of e.g. ACPI C3 state support
(e.g. ACPI5.1 8.1.4 Processor Power State C3). As you note, it's not
going to work on 64-bit ARM as it does on x86, but it's optional to
implement C3 and early 64-bit ARM systems should not report Wbindv flags
in the FADT anyway. They can also set FADT.P_LVL3_LAT > 1000, which has
the effect of disabling C3 support, while also allowing for use of _CST
objects to define more flexible C-States later on.

Jon.

