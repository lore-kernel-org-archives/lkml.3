Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaL0Py2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:54:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24714 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaL0Py1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:54:27 -0500
Message-ID: <549ED5D7.8070007@oracle.com>
Date: Sat, 27 Dec 2014 10:52:55 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>, Li Bin <huawei.libin@huawei.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        rui.xiang@huawei.com, wengmeiling.weng@huawei.com
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com>	 <20140707083016.GA19379@twins.programming.kicks-ass.net>	 <53BAA6DF.5060409@oracle.com>	 <20140707200550.GA6758@twins.programming.kicks-ass.net>	 <549D03F6.9090607@huawei.com> <1419673927.8667.2.camel@stgolabs.net>
In-Reply-To: <1419673927.8667.2.camel@stgolabs.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2014 04:52 AM, Davidlohr Bueso wrote:
>> Hello，
>> > Does ACCESS_ONCE() can help this issue? I have no evidence that its lack is
>> > responsible for the issue, but I think here need it indeed. Is that right?
>> > 
>> > SPIN_BUG_ON(ACCESS_ONCE(lock->owner) == current, "recursion");
> Hmm I guess on a contended spinlock, there's a chance that lock->owner
> can change, if the contended lock is acquired, right between the 'cond'
> and spin_debug(), which would explain the bogus ->owner related
> messages. Of course the same applies to ->owner_cpu. Your ACCESS_ONCE,
> however, doesn't really change anything since we still read ->owner
> again in spin_debug; How about something like this (untested)?

There's a chance that lock->owner would change, but how would you explain
it changing to 'current'?

That is, what race condition specifically creates the
'lock->owner == current' situation in the debug check?

Thanks,
Sasha
