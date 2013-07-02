Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3GBDUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:20:52 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33478 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3GBDUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:20:50 -0400
Message-ID: <51D24708.1060206@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 11:20:40 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Xie XiuQi <xiexiuqi@huawei.com>
CC: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Zhang Hang <bob.zhanghang@huawei.com>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH] sched: fix cpu utilization account error
References: <51D12570.9070100@huawei.com> <1372664187.7678.45.camel@marge.simpson.net> <51D16777.5000703@huawei.com>
In-Reply-To: <51D16777.5000703@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070203-8256-0000-0000-0000082C8310
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Xie

On 07/01/2013 07:26 PM, Xie XiuQi wrote:
[snip]
> Here is the kthread main logic. Although it's not a good idea, but it does
> exist:
> while (!kthread_should_stop()) {
> 	/* call schedule every 1 sec */
> 	if (HZ <= jiffies - last) {
> 		last = jiffies;
> 		schedule();
> 	}
> 
> 	/* get data and sent it */
> 	get_msg();
> 	send_msg();

What about use cond_resched() here? Isn't that more gentle?

Regards,
Michael Wang

> 
> 	if (kthread_should_stop())
> 		break;
> }
> 
>> That said, accounting funnies induced by skipped update are possible,
>> which could trump the cycle savings I suppose, so maybe savings (sniff)
>> should just go away?
> 
> Indeed, removing the skip_clock_update could resolve the issue, but I found
> there is no this issue in preempt mode. However, if remove skip_clock_update
> we'll get more precise time account.
> 
> So, what's your opinion, Mike.
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

