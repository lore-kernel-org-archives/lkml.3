Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3JWJ1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:27:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:62151 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3JWJ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:27:17 -0400
Message-ID: <5267966A.40007@windriver.com>
Date: Wed, 23 Oct 2013 17:27:06 +0800
From: =?UTF-8?B?IuKAnHRpZWp1bi5jaGVu4oCdIg==?= 
	<tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [v5][PATCH 2/6] powerpc/book3e: store critical/machine/debug
 exception thread info
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>	 <1371724110-8250-3-git-send-email-tiejun.chen@windriver.com> <1382136213.7979.908.camel@snotra.buserror.net>
In-Reply-To: <1382136213.7979.908.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 06:43 AM, Scott Wood wrote:
> On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
>> We need to store thread info to these exception thread info like something
>> we already did for PPC32.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---
>>   arch/powerpc/kernel/exceptions-64e.S |   15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
>> index 4d8e57f..07cf657 100644
>> --- a/arch/powerpc/kernel/exceptions-64e.S
>> +++ b/arch/powerpc/kernel/exceptions-64e.S
>> @@ -67,6 +67,18 @@
>>   	std	r10,PACA_##level##_STACK(r13);
>>   #endif
>>
>> +/* Store something to exception thread info */
>> +#define	BOOK3E_STORE_EXC_LEVEL_THEAD_INFO(type)					\
>> +	ld	r14,PACAKSAVE(r13);						\
>> +	CURRENT_THREAD_INFO(r14, r14);						\
>> +	CURRENT_THREAD_INFO(r15, r1);						\
>> +	ld	r10,TI_FLAGS(r14);		     				\
>> +	std	r10,TI_FLAGS(r15);			     			\
>> +	ld	r10,TI_PREEMPT(r14);		     				\
>> +	std	r10,TI_PREEMPT(r15);		     				\
>> +	ld	r10,TI_TASK(r14);			     			\
>> +	std	r10,TI_TASK(r15);
>
> Where is "type" used?
>

Yes, its noting now but its worth leaving this to extend something in the future.

> BTW, no need for a BOOK3E prefix for things local to this file.
>

What about "EXC_LEVEL_EXCEPTION_PROLOG"? Please see next version.

Thanks,

Tiejun
