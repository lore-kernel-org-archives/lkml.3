Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3GIHsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:48:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:40540 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3GIHso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:48:44 -0400
Message-ID: <51DBC07A.4020809@windriver.com>
Date: Tue, 9 Jul 2013 15:49:14 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bhushan Bharat-R65777 <R65777@freescale.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2][PATCH 1/7] powerpc/book3e: support CONFIG_RELOCATABLE
References: <1371714797-7898-1-git-send-email-tiejun.chen@windriver.com> <1371714797-7898-2-git-send-email-tiejun.chen@windriver.com> <6A3DF150A5B70D4F9B66A25E3F7C888D0709474E@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D0709474E@039-SN2MPN1-011.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.214]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 01:00 PM, Bhushan Bharat-R65777 wrote:
>
>
>> -----Original Message-----
>> From: Linuxppc-dev [mailto:linuxppc-dev-
>> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Tiejun Chen
>> Sent: Thursday, June 20, 2013 1:23 PM
>> To: benh@kernel.crashing.org
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
>> Subject: [v2][PATCH 1/7] powerpc/book3e: support CONFIG_RELOCATABLE
>>
>> book3e is different with book3s since 3s includes the exception
>> vectors code in head_64.S as it relies on absolute addressing
>> which is only possible within this compilation unit. So we have
>> to get that label address with got.
>>
>> And when boot a relocated kernel, we should reset ipvr properly again
>> after .relocate.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---

[snip]

>>   	int *src, *dest;
>>   	unsigned long length;
>> +#ifdef CONFIG_PPC_BOOK3E
>> +	extern char interrupt_end_book3e[];
>> +#endif
>
> Cannot we do this in arch/powerpc/kernel/asm/sections.h
>
>>
>>   	if (PHYSICAL_START == 0)
>>   		return;
>>
>>   	src = (int *)(KERNELBASE + PHYSICAL_START);
>>   	dest = (int *)KERNELBASE;
>> +#ifdef CONFIG_PPC_BOOK3E
>> +	length = (interrupt_end_book3e - _stext) / sizeof(int);
>> +#else
>>   	length = (__end_interrupts - _stext) / sizeof(int);
>> +#endif
>
> can we keep same name in books and booke; __end_interrupts ? this way we can avoid such #ifdefs

Yes, I think I can simplify this as you pointed :)

Thanks,

Tiejun
