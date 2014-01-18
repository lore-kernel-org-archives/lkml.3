Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaAREFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 23:05:41 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44036 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaAREFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 23:05:38 -0500
Message-ID: <52D9FD84.9090808@linaro.org>
Date: Sat, 18 Jan 2014 12:05:24 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Al Stone <al.stone@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
Subject: Re: [PATCH 04/20] ARM64 / ACPI: Introduce arm_core.c and its related
 head file
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-5-git-send-email-hanjun.guo@linaro.org> <20140117141241.GH16003@mudshark.cambridge.arm.com>
In-Reply-To: <20140117141241.GH16003@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-1-17 22:12, Will Deacon wrote:
> On Fri, Jan 17, 2014 at 12:24:58PM +0000, Hanjun Guo wrote:
>> Introduce arm_core.c and its related head file, after this patch,
>> we can get ACPI tables from firmware on ARM64 now.
>>
>> Signed-off-by: Al Stone <al.stone@linaro.org>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> 
> [...]
> 
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index bd9bbd0..2210353 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/memblock.h>
>>  #include <linux/of_fdt.h>
>>  #include <linux/of_platform.h>
>> +#include <linux/acpi.h>
>>  
>>  #include <asm/cputype.h>
>>  #include <asm/elf.h>
>> @@ -225,6 +226,11 @@ void __init setup_arch(char **cmdline_p)
>>  
>>  	arm64_memblock_init();
>>  
>> +	/* Parse the ACPI tables for possible boot-time configuration */
>> +	acpi_boot_table_init();
>> +	early_acpi_boot_init();
>> +	acpi_boot_init();
> 
> Do we really need *three* back-to-back calls for ACPI to initialise?

Sorry, my colleague Graeme had integrate them as one function but I
forgot to merge them in this patch, my bad, will update it in next
version.

Thanks
Hanjun

