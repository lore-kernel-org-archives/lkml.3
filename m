Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbaFLNGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:06:55 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46421 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaFLNGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:06:52 -0400
Message-ID: <5399A5F6.8010905@linaro.org>
Date: Thu, 12 Jun 2014 15:07:02 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 1/5] apei, mce: Factor out APEI architecture specific
 MCE calls.
References: <1401262770-25343-1-git-send-email-tomasz.nowicki@linaro.org> <1401262770-25343-2-git-send-email-tomasz.nowicki@linaro.org> <20140612102319.GA22583@rric.localhost>
In-Reply-To: <20140612102319.GA22583@rric.localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.2014 12:23, Robert Richter wrote:
> On 28.05.14 09:39:26, Tomasz Nowicki wrote:
>> This commit abstracts MCE calls and provides weak corresponding default
>> implementation for those architectures which do not need arch specific
>> actions. Each platform willing to do additional architectural actions
>> should provides desired function definition. It allows us to avoid wrap
>> code into #ifdef in generic code and prevent new platform from introducing
>> dummy stub function too.
>>
>> Initially, there are two APEI arch-specific calls:
>> - apei_arch_enable_cmcff()
>> - apei_arch_report_mem_error()
>> Both interact with MCE driver for X86 architecture.
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   arch/x86/kernel/acpi/Makefile |    1 +
>>   arch/x86/kernel/acpi/apei.c   |   56 +++++++++++++++++++++++++++++++++++++++++
>>   drivers/acpi/apei/apei-base.c |   13 ++++++++++
>>   drivers/acpi/apei/ghes.c      |    6 ++---
>>   drivers/acpi/apei/hest.c      |   26 +------------------
>>   include/acpi/apei.h           |    3 +++
>>   6 files changed, 76 insertions(+), 29 deletions(-)
>>   create mode 100644 arch/x86/kernel/acpi/apei.c
>
>>   static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
>>   {
>> -#ifdef CONFIG_X86_MCE
>> -	int i;
>> -	struct acpi_hest_ia_corrected *cmc;
>> -	struct acpi_hest_ia_error_bank *mc_bank;
>> -
>> -	if (hest_hdr->type != ACPI_HEST_TYPE_IA32_CORRECTED_CHECK)
>> -		return 0;
>> -
>> -	cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
>> -	if (!cmc->enabled)
>> +	if (!apei_arch_enable_cmcff(hest_hdr, data))
>>   		return 0;
>
> This could be a tail call:
>
> 	return apei_arch_enable_cmcff(...);

Right. Will fix that.

>
> Otherwise the patch looks good to me.

Thanks.

Tomasz
