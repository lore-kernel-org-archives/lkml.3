Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaJEXuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:50:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48948 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJEXt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:49:58 -0400
Message-ID: <5431DA80.5090007@gmail.com>
Date: Mon, 06 Oct 2014 07:55:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: pavel@ucw.cz, len.brown@intel.com, gregkh@linuxfoundation.org,
        ulf.hansson@linaro.org, khilman@linaro.org, geert+renesas@glider.be,
        tomasz.figa@gmail.com, richard@nod.at, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] drivers: base: power: domain: Use 'pm_cpu_data' instead
 of 'cpu_data' for compiling break
References: <54300206.3020206@gmail.com> <3581264.gqojuoeKz2@vostro.rjw.lan>
In-Reply-To: <3581264.gqojuoeKz2@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/14 5:32, Rafael J. Wysocki wrote:
> On Saturday, October 04, 2014 10:19:50 PM Chen Gang wrote:
>> 'cpu_data' is too common to be already used by some architectures (e.g.
>> um, m32r, and mn10300), so need use 'pm_cpu_data' instead of, or cause
>> compiling break. The related error (with allmodconfig under um):
>>
>>     CC      drivers/base/platform.o
>>   In file included from ./arch/x86/um/asm/processor.h:31:0,
>>                    from ./arch/um/include/asm/uaccess.h:16,
>>                    from ./arch/um/include/asm/thread_info.h:13,
>>                    from include/linux/thread_info.h:54,
>>                    from include/asm-generic/current.h:4,
>>                    from arch/um/include/generated/asm/current.h:1,
>>                    from include/linux/mutex.h:13,
>>                    from include/linux/kernfs.h:13,
>>                    from include/linux/sysfs.h:15,
>>                    from include/linux/kobject.h:21,
>>                    from include/linux/device.h:17,
>>                    from include/linux/platform_device.h:14,
>>                    from drivers/base/platform.c:14:
>>   ./arch/um/include/asm/processor-generic.h:107:19: error: expected identifier or '(' before '&' token
>>    #define cpu_data (&boot_cpu_data)
>>                      ^
>>   include/linux/pm_domain.h:74:23: note: in expansion of macro 'cpu_data'
>>     struct gpd_cpu_data *cpu_data;
>>                        ^
>>
>> Also need notice about 80 columns boundary.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> This problem has already been fixed by a patch from Ulf Hansson that's
> in my tree (along with the commit that introduced the problem in the first
> place).
> 

OK, thanks, that is good news to us all.

> And you forgot to say that the problem was only occuring in linux-next.
> 

OK, thanks, next, I shall mark 'next' in subject, e.g. [PATH next] ...


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
