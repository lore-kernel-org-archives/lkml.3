Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaE0H5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:57:07 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25417 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaE0H5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:57:03 -0400
Message-ID: <53844510.1040502@huawei.com>
Date: Tue, 27 May 2014 15:56:00 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>,
        <peterz@infradead.org>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com>	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com> <1401113960.23186.41.camel@marge.simpson.net>
In-Reply-To: <1401113960.23186.41.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/26 22:19, Mike Galbraith wrote:
> On Mon, 2014-05-26 at 20:16 +0800, Libo Chen wrote: 
>> On 2014/5/26 13:11, Mike Galbraith wrote:
> 
>>> Your synthetic test is the absolute worst case scenario.  There has to
>>> be work between wakeups for select_idle_sibling() to have any chance
>>> whatsoever of turning in a win.  At 0 work, it becomes 100% overhead.
>>
>> not synthetic, it is a real problem in our product. under no load, waste
>> much cpu time.
> 
> What happens in your product if you apply the commit I pointed out?

under no load, cpu usage is up to 60%, but the same apps cost 10% on
susp sp1.  The apps use a lot of timer.

I am not sure that commit is the root cause, but they do have some different
cpu usage between 3.4.24 and suse sp1, e.g. my synthetic test before.

> 
>>>> so I think 15% cpu usage and migration event are too high, how to fixed?
>>>
>>> You can't for free, low latency wakeup can be worth one hell of a lot.
>>>
>>> You could do a decayed hit/miss or such to shut the thing off when the
>>> price is just too high.  Restricting migrations per unit time per task
>>> also helps cut the cost, but hurts tasks that could have gotten to the
>>> CPU quicker, and started your next bit of work.  Anything you do there
>>> is going to be a rob Peter to pay Paul thing.
>>>
>>
>> I had tried to change sched_migration_cost and sched_nr_migrate in /proc,
>> but no use.  any other  suggestion?
>>
>> I still think this is a problem to schedular.  it is better to directly solve
>> this issue instead of a workaroud
> 
> I didn't say it wasn't a problem, it is.  I said whatever you do will be
> a tradeoff.
> 
> -Mike
> 
> 
> 


