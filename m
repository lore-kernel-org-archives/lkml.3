Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3IKIAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:00:23 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54546 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3IKIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:00:21 -0400
Message-ID: <5230231E.8070104@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 13:30:30 +0530
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Guenter Roeck <linux@roeck-us.net>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc: Export cpu_to_chip_id() to fix build error
References: <1378777076-4699-1-git-send-email-linux@roeck-us.net> <1378850610.4121.29.camel@pasglop>
In-Reply-To: <1378850610.4121.29.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091107-5490-0000-0000-000004220111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 03:33 AM, Benjamin Herrenschmidt wrote:
> On Mon, 2013-09-09 at 18:37 -0700, Guenter Roeck wrote:
>> powerpc allmodconfig build fails with:
>>
>> ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!
>>
>> The problem was introduced with commit 15863ff3b (powerpc: Make chip-id
>> information available to userspace).
>
> Thanks, I'll send that to Linus asap.
>

Verified on today's Linus tree. This issue is fixed.

Thanks a lot.

-Vasant

> Ben.
>
>> Export the missing symbol.
>>
>> Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
>> Cc: Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   arch/powerpc/kernel/smp.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
>> index 442d8e2..8e59abc 100644
>> --- a/arch/powerpc/kernel/smp.c
>> +++ b/arch/powerpc/kernel/smp.c
>> @@ -611,6 +611,7 @@ int cpu_to_chip_id(int cpu)
>>   	of_node_put(np);
>>   	return of_get_ibm_chip_id(np);
>>   }
>> +EXPORT_SYMBOL(cpu_to_chip_id);
>>
>>   /* Helper routines for cpu to core mapping */
>>   int cpu_core_index_of_thread(int cpu)
>
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

