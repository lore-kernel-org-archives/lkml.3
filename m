Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbbAEJbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:31:40 -0500
Received: from mail113-248.mail.alibaba.com ([205.204.113.248]:50595 "EHLO
	us-alimail-mta2.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753053AbbAEJbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:31:37 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07698552|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r46d02015;MF=gang.chen@sunrus.com.cn;PH=DS;RN=4;RT=4;SR=0;
Message-ID: <54AA5B6E.4040506@sunrus.com.cn>
Date: Mon, 05 Jan 2015 17:37:50 +0800
From: Chen Gang S <gang.chen@sunrus.com.cn>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: schwidefsky@de.ibm.com, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: boot: compressed: misc: Express the return value
 of _sclp_print_early()
References: <54A7B663.3010507@sunrus.com.cn> <20150105092105.GA4281@osiris>
In-Reply-To: <20150105092105.GA4281@osiris>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/5/15 17:21, Heiko Carstens wrote:
> On Sat, Jan 03, 2015 at 05:29:07PM +0800, Chen Gang wrote:
>> _sclp_print_early() has return value: at present, return 0 for OK, 1 for
>> failure. It returns '%r2', so use 'long' as return value (upper caller
>> can check '%r2' directly). The related warning:
>>
>>     CC      arch/s390/boot/compressed/misc.o
>>   arch/s390/boot/compressed/misc.c:66:8: warning: type defaults to 'int' in declaration of '_sclp_print_early' [-Wimplicit-int]
>>    extern _sclp_print_early(const char *);
>>           ^
>>
>> At present, _sclp_print_early() is only used by puts(), so can still
>> remain its declaration in 'misc.c' file.
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/s390/boot/compressed/misc.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
>> index 57cbaff..09003b2 100644
>> --- a/arch/s390/boot/compressed/misc.c
>> +++ b/arch/s390/boot/compressed/misc.c
>> @@ -63,7 +63,7 @@ static unsigned long free_mem_end_ptr;
>>  #include "../../../../lib/decompress_unxz.c"
>>  #endif
>>  
>> -extern _sclp_print_early(const char *);
>> +extern long _sclp_print_early(const char *);
> 
> Thanks, applied. However I moved the declaration to the sclp header file.
> 

OK, Thanks.

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
