Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaFXJAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:00:47 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:54728 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaFXJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:00:42 -0400
Message-ID: <53A93E44.8040303@linaro.org>
Date: Tue, 24 Jun 2014 11:00:52 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org
Subject: Re: [PATCH v3 2/5] acpi, apei, ghes: Introduce ARCH_HAS_ACPI_APEI_NMI
 to make NMI error notification a GHES feature.
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org> <1402657380-18539-3-git-send-email-tomasz.nowicki@linaro.org> <20140619142734.GE22025@pd.tnic>
In-Reply-To: <20140619142734.GE22025@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19.06.2014 16:27, Borislav Petkov wrote:
> On Fri, Jun 13, 2014 at 01:02:57PM +0200, Tomasz Nowicki wrote:
>> Currently APEI depends on x86 architecture. It is because of NMI hardware
>> error notification of GHES which is currently supported by x86 only.
>> However, many other APEI features can be still used perfectly by other
>> architectures.
>>
>> This commit adds ARCH_HAS_ACPI_APEI_NMI which will be used in next patches
>> for NMI related code isolation in ghes.c file. Only NMI error notification
>> feature depends on x86 so let it be hard selected for x86 arch.
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   arch/x86/Kconfig          |    1 +
>>   drivers/acpi/apei/Kconfig |    8 +++++++-
>>   2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 3fc9b12..e1dc819 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -24,6 +24,7 @@ config X86
>>   	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
>>   	select ARCH_MIGHT_HAVE_PC_PARPORT
>>   	select ARCH_MIGHT_HAVE_PC_SERIO
>> +	select ARCH_HAS_ACPI_APEI_NMI
>>   	select HAVE_AOUT if X86_32
>>   	select HAVE_UNSTABLE_SCHED_CLOCK
>>   	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64
>> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
>> index c4dac71..9f6c3ec 100644
>> --- a/drivers/acpi/apei/Kconfig
>> +++ b/drivers/acpi/apei/Kconfig
>> @@ -3,7 +3,6 @@ config ACPI_APEI
>>   	select MISC_FILESYSTEMS
>>   	select PSTORE
>>   	select UEFI_CPER
>> -	depends on X86
>
> Now this can practically be enabled on any architecture, AFAICT. Which
> is wrong.
>
> I think a better solution would be to have another HAVE_ symbol which
> each arch which sports APEI selects. Like in the diff below ontop of
> this patch, also incorporating Robert's comments.
>
> You'll have to do select HAVE_ACPI_APEI on arm too.
>
> Hmm?
>

Now that it turns out we have to provide at least tlb_flush_... arch 
function, APEI can not be selected by any architecture. So you are right 
I will introduce HAVE_ACPI_APEI in next version of patches. Thanks.

Tomasz
