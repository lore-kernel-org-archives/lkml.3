Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaL2OXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:23:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38905 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaL2OXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:23:43 -0500
Message-ID: <54A1638A.1050800@oracle.com>
Date: Mon, 29 Dec 2014 09:22:02 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: Li Bin <huawei.libin@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, rui.xiang@huawei.com,
        wengmeiling.weng@huawei.com
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com>	 <20140707083016.GA19379@twins.programming.kicks-ass.net>	 <53BAA6DF.5060409@oracle.com>	 <20140707200550.GA6758@twins.programming.kicks-ass.net>	 <549D03F6.9090607@huawei.com> <1419673927.8667.2.camel@stgolabs.net>	 <549ED5D7.8070007@oracle.com> <1419797834.8667.8.camel@stgolabs.net>
In-Reply-To: <1419797834.8667.8.camel@stgolabs.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2014 03:17 PM, Davidlohr Bueso wrote:
> On Sat, 2014-12-27 at 10:52 -0500, Sasha Levin wrote:
>> > There's a chance that lock->owner would change, but how would you explain
>> > it changing to 'current'?
> So yeah, the above only deals with the weird printk values, not the
> actual issue that triggers the BUG_ON. Lets sort this out first and at
> least get correct data.

Is there an issue with weird printk values? I haven't seen a report of
something like that, nor have seen it myself.

>> > That is, what race condition specifically creates the
>> > 'lock->owner == current' situation in the debug check?
> Why do you suspect a race as opposed to a legitimate recursion issue?
> Although after staring at the code for a while, I cannot see foul play
> in sched_rr_get_interval.
> 
> Given that all reports show bogus contending CPU and .owner_cpu, I do
> wonder if this is actually a symptom of the BUG_ON where something fishy
> is going on.. although I have no evidence to support that. I also ran
> into this https://lkml.org/lkml/2014/11/7/762 which shows the same bogus
> values yet a totally different stack.
> 
> Sasha, I ran trinity with CONFIG_DEBUG_SPINLOCK=y all night without
> triggering anything. How are you hitting this?

I don't have any reliable way of reproducing it. The only two things I
can think of are:

 - Try running as root in a disposable vm
 - Try running with really high load (I use ~800 children on 16 vcpu
guests).


Thanks,
Sasha
