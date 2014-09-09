Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaIIQpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:45:44 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:48218 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaIIQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:45:43 -0400
Date: Tue, 9 Sep 2014 12:44:45 -0400 (EDT)
Subject: Re: [PATCH v3 02/17] ARM64 / ACPI: Get RSDP and ACPI boot-time
 tables
From: Jon Masters <jcm@redhat.com>
To: hanjun.guo@linaro.org, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-acpi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, grant.likely@linaro.org,
        Will Deacon <Will.Deacon@arm.com>, graeme.gregory@linaro.org,
        Olof Johansson <olof@lixom.net>, Robert Richter <rric@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Rob Herring <robh@kernel.org>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <Mark.Rutland@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Jason Cooper <jason@lakedaemon.net>
MIME-Version: 1.0
Message-ID: <1672724278.9306589.1410281085602.JavaMail.zimbra@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.0.6_GA_5922 (MobileSync - Android/4.4.4-EAS-2.0)
In-Reply-To: <540F2DCF.1010104@redhat.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-3-git-send-email-hanjun.guo@linaro.org> <20140909162648.GE2910@arm.com> <540F2DCF.1010104@redhat.com>
Thread-Topic: ARM64 / ACPI: Get RSDP and ACPI boot-time tables
Thread-Index: e5zJTxu1pSu5gr/fESfv8qGMVVTOnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the ARM guys pointed out the cache issue before I had meant to send this note then. Sorry.

-- 
Computer Architect | Sent from my #ARM Powered Mobile device

On Sep 9, 2014 12:41 PM, Jon Masters <jcm@redhat.com> wrote:
>
> On 09/09/2014 12:26 PM, Catalin Marinas wrote: 
> > On Mon, Sep 01, 2014 at 03:On 09/09/2014 12:26 PM, Catalin Marinas wrote:
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

