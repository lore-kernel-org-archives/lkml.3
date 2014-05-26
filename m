Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaEZLtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:49:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4440 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaEZLtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:49:31 -0400
Message-ID: <53832A36.5020205@huawei.com>
Date: Mon, 26 May 2014 19:49:10 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>,
        <peterz@infradead.org>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com> <1401090987.5339.79.camel@marge.simpson.net>
In-Reply-To: <1401090987.5339.79.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/26 15:56, Mike Galbraith wrote:
> On Mon, 2014-05-26 at 11:04 +0800, Libo Chen wrote: 
>> hi,
>>     my box has 16 cpu (E5-2658,8 core, 2 thread per core), i did a test on
>> 3.4.24stable, startup 50 same process, every process is sample:
>>
>>  	#include <unistd.h>
>>
>>  	int main()
>>  	{
>>           	for (;;)
>>           	{
>>                   	unsigned int i = 0;
>>                  	 while (i< 100){
>>                      	 i++;
>>                   	}
>>                   	usleep(100);
>>           	}
>>
>>          	 return 0;
>>   	}
>>
>> the result is process uses 15% cpu time, perf tool shows 70w migrations in 5 second.
> 
> My 8 socket 64 core DL980 running 256 copies (3.14-rt5) munches ~4%/copy
> per top, and does roughly 1 sh*tload migrations, nano-work loop or not.
> Turn SD_SHARE_PKG_RESOURCES off at MC (not a noop here), and consumption
> drops to ~2%/copy, and migrations ('course) mostly go away.

how to turn off SD_SHARE_PKG_RESOURCES in userspace ?

> 
> vogelweide:/abuild/mike/:[0]# perf stat -a -e sched:sched_migrate_task -- sleep 5
> 
>  Performance counter stats for 'system wide':
> 
>               3108      sched:sched_migrate_task                                    
> 
>        5.001367910 seconds time elapsed
> 
> (turns SD_SHARE_PKG_RESOURCES back on)
> 
> vogelweide:/abuild/mike/:[0]# perf stat -a -e sched:sched_migrate_task -- sleep 5
> 
>  Performance counter stats for 'system wide':
> 
>            4182334      sched:sched_migrate_task                                    
> 
>        5.001365023 seconds time elapsed
> 
> vogelweide:/abuild/mike/:[0]# 
> 
> 
> 


