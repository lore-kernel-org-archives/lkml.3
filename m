Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaGAHzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:55:54 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50791 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaGAHzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:55:52 -0400
Message-ID: <53B2694F.7070501@linaro.org>
Date: Tue, 01 Jul 2014 15:54:55 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "rric@kernel.org" <rric@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v4 13/13] ARM64 / ACPI: Enable ARM64 in Kconfig
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org> <1403840976-7456-14-git-send-email-hanjun.guo@linaro.org> <20140630104652.GG28951@arm.com>
In-Reply-To: <20140630104652.GG28951@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-6-30 18:46, Catalin Marinas wrote:
> On Fri, Jun 27, 2014 at 04:49:36AM +0100, Hanjun Guo wrote:
>> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>> index 7de5e3f..33d6dbb 100644
>> --- a/drivers/acpi/Kconfig
>> +++ b/drivers/acpi/Kconfig
>> @@ -8,10 +8,10 @@ config ACPI_SCAN_BIOS_NOT_EFI
>>  menuconfig ACPI
>>  	bool "ACPI (Advanced Configuration and Power Interface) Support"
>>  	depends on !IA64_HP_SIM
>> -	depends on IA64 || X86
>> +	depends on IA64 || X86 || ARM64
> 
> I still don't understand what the point of enabling ACPI for arm64
> during this series is. Do you get any working arm64 functionality
> (on hardware or model) without subsequent patches? If it's just for
> compilation reasons, the best we could do is depending on (ARM64 &&
> COMPILE_TEST) but even though I would not merge this patch until we have
> most of the arm64 required features in place (some of which are
> introduced by the upcoming ACPI version).

it is ok to me to merge all the patches together, but if Rafael is happy
with the clean up patches (patch 1~3) for ACPI core, they can be merged
first.

> 
>>  	depends on PCI
>>  	select PNP
>> -	default y
>> +	default y if !ARM64
> 
> For the benefit of single Image, I think you can default to y here.

It ok to me. if we default to y here, devicetree will not be unflattened
in default, is it ok to you? you can refer to "[PATCH 12/13] ARM64 / ACPI: if
we chose to boot from acpi then disable FDT".

Thanks
Hanjun
