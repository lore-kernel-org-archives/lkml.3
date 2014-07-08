Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaGHJzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:55:43 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49602 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaGHJzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:55:41 -0400
Message-ID: <53BBC01A.4030704@linaro.org>
Date: Tue, 08 Jul 2014 17:55:38 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/4] ACPI: ARM64 does not have a BIOS add config for BIOS
 table scan.
References: <1404290847-7671-1-git-send-email-hanjun.guo@linaro.org> <1404290847-7671-2-git-send-email-hanjun.guo@linaro.org> <1430951.SWzYBgFe0M@vostro.rjw.lan>
In-Reply-To: <1430951.SWzYBgFe0M@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月08日 05:06, Rafael J. Wysocki wrote:
> On Wednesday, July 02, 2014 04:47:23 PM Hanjun Guo wrote:
>> From: Graeme Gregory <graeme.gregory@linaro.org>
>>
>> With the addition of ARM64 that does not have a traditional BIOS to
>> scan, add a config option which is selected on x86 and ia64 to do
>> the traditional BIOS scanning for tables.
>>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  arch/ia64/Kconfig    |    1 +
>>  arch/x86/Kconfig     |    1 +
>>  drivers/acpi/Kconfig |    3 +++
>>  drivers/acpi/osl.c   |    4 +++-
>>  4 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
>> index 2f3abcf..f82b352 100644
>> --- a/arch/ia64/Kconfig
>> +++ b/arch/ia64/Kconfig
>> @@ -47,6 +47,7 @@ config IA64
>>  	select MODULES_USE_ELF_RELA
>>  	select ARCH_USE_CMPXCHG_LOCKREF
>>  	select HAVE_ARCH_AUDITSYSCALL
>> +	select ACPI_SCAN_BIOS_NOT_EFI
> I would call this ACPI_LEGACY_TABLES_LOOKUP or something like that.
>
> Also please do
>
> +	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
>
> in analogy with patch [3/4] in this series.

OK, I will update this patch accordingly, thanks for the great config
name :)

Thanks
Hanjun
