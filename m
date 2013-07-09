Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3GIHv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:51:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:40858 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3GIHvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:51:54 -0400
Message-ID: <51DBC0C9.6010001@windriver.com>
Date: Tue, 9 Jul 2013 15:50:33 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bhushan Bharat-R65777 <R65777@freescale.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2][PATCH 2/7] book3e/kexec/kdump: enable kexec for kernel
References: <1371714797-7898-1-git-send-email-tiejun.chen@windriver.com> <1371714797-7898-3-git-send-email-tiejun.chen@windriver.com> <6A3DF150A5B70D4F9B66A25E3F7C888D07094779@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D07094779@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.214]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 01:17 PM, Bhushan Bharat-R65777 wrote:
>
>
>> -----Original Message-----
>> From: Linuxppc-dev [mailto:linuxppc-dev-
>> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Tiejun Chen
>> Sent: Thursday, June 20, 2013 1:23 PM
>> To: benh@kernel.crashing.org
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
>> Subject: [v2][PATCH 2/7] book3e/kexec/kdump: enable kexec for kernel
>>
>> We need to active KEXEC for book3e and bypass or convert non-book3e stuff
>> in kexec coverage.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---
>>   arch/powerpc/Kconfig                   |    2 +-
>>   arch/powerpc/kernel/machine_kexec_64.c |    6 ++++++
>>   arch/powerpc/kernel/misc_64.S          |    6 ++++++
>>   3 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index c33e3ad..6ecf3c9 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -364,7 +364,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
>>
>>   config KEXEC
>>   	bool "kexec system call"
>> -	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP))
>> +	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP)) || PPC_BOOK3E
>>   	help
>>   	  kexec is a system call that implements the ability to shutdown your
>>   	  current kernel, and to start another kernel.  It is like a reboot
>> diff --git a/arch/powerpc/kernel/machine_kexec_64.c
>> b/arch/powerpc/kernel/machine_kexec_64.c
>> index 611acdf..ef39271 100644
>> --- a/arch/powerpc/kernel/machine_kexec_64.c
>> +++ b/arch/powerpc/kernel/machine_kexec_64.c
>> @@ -33,6 +33,7 @@
>>   int default_machine_kexec_prepare(struct kimage *image)
>>   {
>>   	int i;
>> +#ifndef CONFIG_PPC_BOOK3E
>>   	unsigned long begin, end;	/* limits of segment */
>>   	unsigned long low, high;	/* limits of blocked memory range */
>>   	struct device_node *node;
>> @@ -41,6 +42,7 @@ int default_machine_kexec_prepare(struct kimage *image)
>>
>>   	if (!ppc_md.hpte_clear_all)
>>   		return -ENOENT;
>> +#endif
>
> Do we really need this function for book3e? can we have a separate function rather than multiple confusing ifdef?

I prefer we have a separate function to book3e.

Thanks

Tiejun
