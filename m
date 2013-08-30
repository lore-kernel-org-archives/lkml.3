Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3H3FvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 01:51:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:8880 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3H3FvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:51:10 -0400
X-Spam-Score: -100.9
Message-ID: <52203283.4020701@asianux.com>
Date: Fri, 30 Aug 2013 13:49:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]  h8300/kernel/setup.c: add "linux/initrd.h" to pass
 compiling
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <52202045.1050506@roeck-us.net>
In-Reply-To: <52202045.1050506@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 12:32 PM, Guenter Roeck wrote:
> On 08/29/2013 08:59 PM, Chen Gang wrote:
>> The related error (allmodconfig for h8300):
>>
>>    arch/h8300/kernel/setup.c: In function 'setup_arch':
>>    arch/h8300/kernel/setup.c:103:3: error: 'initrd_start' undeclared
>> (first use in this function)
>>       initrd_start = memory_start;
>>       ^
>>    arch/h8300/kernel/setup.c:103:3: note: each undeclared identifier
>> is reported only once for each function it appears in
>>    arch/h8300/kernel/setup.c:104:3: error: 'initrd_end' undeclared
>> (first use in this function)
>>       initrd_end = memory_start += be32_to_cpu(((unsigned long *)
>> (memory_start))[2]);
>>       ^
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>   arch/h8300/kernel/setup.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
>> index d0b1607..85639a1 100644
>> --- a/arch/h8300/kernel/setup.c
>> +++ b/arch/h8300/kernel/setup.c
>> @@ -47,6 +47,10 @@
>>   #include <asm/regs267x.h>
>>   #endif
>>
>> +#if defined(CONFIG_BLK_DEV_INITRD)
>> +#include <linux/initrd.h>
>> +#endif
>> +
> 
> Is the #ifdef/#endif really needed ? If not you should drop it.
> 

"linux/initrd.h" is needed by 'initrd_start' and 'initrd_end' when
BLK_DEV_INITRD enabled.

'memory_start' is defined within this file, and also only one place may
use "linux/initrd.h" within this file.

So if BLK_DEV_INITRD disabled, do not need "linux/initrd.h" either.


Please reference the code in "arch/h8300/kernel/setup.c" below.

102 void __init setup_arch(char **cmdline_p)
103 {
104         int bootmap_size;
105 
106         memory_start = (unsigned long) &_ramstart;
107 
108         /* allow for ROMFS on the end of the kernel */
109         if (memcmp((void *)memory_start, "-rom1fs-", 8) == 0) {
110 #if defined(CONFIG_BLK_DEV_INITRD)
111                 initrd_start = memory_start;
112                 initrd_end = memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]);
113 #else
114                 memory_start += be32_to_cpu(((unsigned long *) memory_start)[2]);
115 #endif
116         }



> Thanks,
> Guenter
> 
> 
> 

Thanks.
-- 
Chen Gang
