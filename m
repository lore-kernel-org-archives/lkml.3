Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab3GBELn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:11:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50587 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3GBELm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:11:42 -0400
Message-ID: <51D252EF.2030500@huawei.com>
Date: Tue, 2 Jul 2013 12:11:27 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, Zhang Hang <bob.zhanghang@huawei.com>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH] sched: fix cpu utilization account error
References: <51D12570.9070100@huawei.com>  <1372664187.7678.45.camel@marge.simpson.net> <51D16777.5000703@huawei.com> <1372734474.7363.66.camel@marge.simpson.net>
In-Reply-To: <1372734474.7363.66.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/2 11:07, Mike Galbraith wrote:
> On Mon, 2013-07-01 at 19:26 +0800, Xie XiuQi wrote:
> 
>> Here is the kthread main logic. Although it's not a good idea, but it does
>> exist:
> 
> Why not fix this instead?
> 
>> while (!kthread_should_stop()) {
>> 	/* call schedule every 1 sec */
>> 	if (HZ <= jiffies - last) {
>> 		last = jiffies;
>> 		schedule();
>> 	}
> 
> Hanging out in the kernel for ages is not cool.  That doesn't mean
> something else might not pop up that forces the issue, but to date it
> has not, and sacrificing precious fastpath cycles is not attractive.
> 

That is to say, the driver's code needs improvement.
Thank you Mike.

> -Mike
> 


