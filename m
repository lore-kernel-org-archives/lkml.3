Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaGHJXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:23:23 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65317 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaGHJXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:23:20 -0400
Message-ID: <53BBB884.5000005@linaro.org>
Date: Tue, 08 Jul 2014 17:23:16 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 4/4] ACPI: Make EC debugfs depend on X86 || IA64 in Kconfig
References: <1404290847-7671-1-git-send-email-hanjun.guo@linaro.org> <1404290847-7671-5-git-send-email-hanjun.guo@linaro.org> <200683000.sgUJl2AyWR@vostro.rjw.lan>
In-Reply-To: <200683000.sgUJl2AyWR@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月08日 05:16, Rafael J. Wysocki wrote:
> On Wednesday, July 02, 2014 04:47:26 PM Hanjun Guo wrote:
>> Since EC (Embedded controller) needs SCI for the interupt which
>> is not available on ARM64, make the EC debugfs depend on X86 || IA64
>> only in the Kconfig file.
>>
>> Reviewed-by: Grant Likely <grant.likely@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  drivers/acpi/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>> index 0e6f72d..7de5e3f 100644
>> --- a/drivers/acpi/Kconfig
>> +++ b/drivers/acpi/Kconfig
>> @@ -69,6 +69,7 @@ config ACPI_PROCFS_POWER
>>  
>>  config ACPI_EC_DEBUGFS
>>  	tristate "EC read/write access through /sys/kernel/debug/ec"
>> +	depends on X86 || IA64
> This is totally inconsistent with the other patches in the series where you
> define per-arch symbols for similar things.  In addition to that, do we need
> to build ec.c on ARM at all?

Yes, EC will be needed on ARM. This patch is not needed after some more
consideration, I will drop it.

Thanks
Hanjun

