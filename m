Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaHRDOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 23:14:20 -0400
Received: from mail1.windriver.com ([147.11.146.13]:55510 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaHRDOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 23:14:19 -0400
Message-ID: <53F16F62.2090902@windriver.com>
Date: Mon, 18 Aug 2014 12:13:38 +0900
From: Sahara <keun-o.park@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, <kpark3469@gmail.com>,
        <akpm@linux-foundation.org>
CC: <hpa@zytor.com>, <rafael.j.wysocki@intel.com>, <peterz@infradead.org>,
        <kirill.shutemov@linux.intel.com>, <oleg@redhat.com>,
        <prarit@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] earlyprintk: re-enable earlyprintk calling early_param
References: <1408011216-8621-1-git-send-email-kpark3469@gmail.com> <87lhqp8uvu.fsf@rustcorp.com.au>
In-Reply-To: <87lhqp8uvu.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2014년 08월 16일 03:34, Rusty Russell 쓴 글:
> kpark3469@gmail.com writes:
>> From: Sahara <keun-o.park@windriver.com>
>>
>> Although there are many obs_kernel_param and its names are
>> earlyprintk and also EARLY_PRINTK is also enabled, we could not
>> see the early_printk output properly until now. This patch
>> considers earlycon as well as earlyprintk.
> Hmm, the initial "earlycon" hack slipped in when I wasn't looking.
> I don't think we should extend it.
>
> Why not make the thing(s) you want early_param()s?
>
> Cheers,
> Rusty.
The earlycon and the earlyprintk are scattered and used in many 
architectures.
It looks earlycon just could be a subset of earlyprintk.
The earlycon is for uart specific, while the earlyprintk is to support 
vga, efi, xen, serial, and so on. Especially ARM uses earlyprintk in 
many places. And, I am not sure if this is a good chance to replace all 
the earlyprintk with the earlycon. As of now, it's fair for both 
earlycon and earlyprintk.
Or perhaps removing case#2, see in my previous email to Andrew Morton, 
is better?, so users be forced to specify earlycon and earlyprintk in 
cmdline if they want to see early_printk() output.

Thanks.

Best Regards,
Sahara.

>
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -426,7 +426,8 @@ static int __init do_early_param(char *param, char *val, const char *unused)
>>   	for (p = __setup_start; p < __setup_end; p++) {
>>   		if ((p->early && parameq(param, p->str)) ||
>>   		    (strcmp(param, "console") == 0 &&
>> -		     strcmp(p->str, "earlycon") == 0)
>> +		     ((strcmp(p->str, "earlycon") == 0) ||
>> +		     (strcmp(p->str, "earlyprintk") == 0)))
>>   		) {
>>   			if (p->setup_func(val) != 0)
>>   				pr_warn("Malformed early option '%s'\n", param);
>> -- 
>> 1.7.9.5

