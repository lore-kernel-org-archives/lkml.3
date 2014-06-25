Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbaFYWL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:11:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44536 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaFYWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:11:58 -0400
Message-ID: <53AB492D.9010107@gmail.com>
Date: Thu, 26 Jun 2014 06:11:57 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>
CC: Liqin Chen <liqin.linux@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/asm/uaccess.h: Use standard clear_user()
 prototype
References: <53A6CC0E.5010000@gmail.com> <CAF0htA7YoQ=UtfMsNSRrYEO33aQZHnQP3Thy5ZUCreHwdqtg_Q@mail.gmail.com>
In-Reply-To: <CAF0htA7YoQ=UtfMsNSRrYEO33aQZHnQP3Thy5ZUCreHwdqtg_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 11:29 PM, Lennox Wu wrote:
> Thanks for the patch.
> 
> Acked-by: Lennox Wu<lennox.wu@gmail.com>
> 

Thank you for your work, and I shall continue, hope I can finish
allmodconfig for score within next month (2014-07-31).


Thanks.

> 2014-06-22 20:29 GMT+08:00 Chen Gang <gang.chen.5i5j@gmail.com>:
>> Use standard clear_user() just like another architectures, also match
>> __clear_user() under score.
>>
>> The related warning (allmodconfig under score):
>>
>>     CC [M]  drivers/md/dm-ioctl.o
>>   drivers/md/dm-ioctl.c: In function 'copy_params':
>>   drivers/md/dm-ioctl.c:1728:33: warning: passing argument 1 of 'clear_user' from incompatible pointer type
>>      if (secure_data && clear_user(user, param_kernel->data_size))
>>                                    ^
>>   In file included from include/linux/uaccess.h:5:0,
>>                    from include/linux/highmem.h:8,
>>                    from include/linux/bio.h:23,
>>                    from include/linux/device-mapper.h:11,
>>                    from drivers/md/dm.h:14,
>>                    from drivers/md/dm-ioctl.c:8:
>>   ./arch/score/include/asm/uaccess.h:364:29: note: expected 'char *' but argument is of type 'struct dm_ioctl *'
>>    static inline unsigned long clear_user(char *src, unsigned long size)
>>                                ^
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/score/include/asm/uaccess.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/score/include/asm/uaccess.h b/arch/score/include/asm/uaccess.h
>> index ab66ddd..259a539 100644
>> --- a/arch/score/include/asm/uaccess.h
>> +++ b/arch/score/include/asm/uaccess.h
>> @@ -361,7 +361,8 @@ copy_in_user(void *to, const void *from, unsigned long len)
>>   */
>>  extern unsigned long __clear_user(void __user *src, unsigned long size);
>>
>> -static inline unsigned long clear_user(char *src, unsigned long size)
>> +static inline unsigned long __must_check clear_user(void __user *src,
>> +                                                       unsigned long size)
>>  {
>>         if (access_ok(VERIFY_WRITE, src, size))
>>                 return __clear_user(src, size);
>> --
>> 1.9.2.459.g68773ac


-- 
Chen Gang

Open share and attitude like air water and life which God blessed
