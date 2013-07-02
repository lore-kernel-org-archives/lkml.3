Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab3GBEPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:15:23 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51946 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3GBEPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:15:22 -0400
Message-ID: <51D253CA.5080204@huawei.com>
Date: Tue, 2 Jul 2013 12:15:06 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Zhang Hang <bob.zhanghang@huawei.com>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH] sched: fix cpu utilization account error
References: <51D12570.9070100@huawei.com> <1372664187.7678.45.camel@marge.simpson.net> <51D16777.5000703@huawei.com> <51D24708.1060206@linux.vnet.ibm.com>
In-Reply-To: <51D24708.1060206@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/2 11:20, Michael Wang wrote:
> Hi, Xie
> 
> On 07/01/2013 07:26 PM, Xie XiuQi wrote:
> [snip]
>> Here is the kthread main logic. Although it's not a good idea, but it does
>> exist:
>> while (!kthread_should_stop()) {
>> 	/* call schedule every 1 sec */
>> 	if (HZ <= jiffies - last) {
>> 		last = jiffies;
>> 		schedule();
>> 	}
>>
>> 	/* get data and sent it */
>> 	get_msg();
>> 	send_msg();
> 
> What about use cond_resched() here? Isn't that more gentle?
> 

That's a good idea for driver implementation.
Thank you Michael.

> Regards,
> Michael Wang
> 


