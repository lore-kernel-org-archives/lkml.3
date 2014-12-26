Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaLZHDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:03:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39604 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaLZHDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:03:02 -0500
Message-ID: <549D07CD.8000204@oracle.com>
Date: Fri, 26 Dec 2014 02:01:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Li Bin <huawei.libin@huawei.com>, Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, rui.xiang@huawei.com,
        wengmeiling.weng@huawei.com
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com> <20140707083016.GA19379@twins.programming.kicks-ass.net> <53BAA6DF.5060409@oracle.com> <20140707200550.GA6758@twins.programming.kicks-ass.net> <549D03F6.9090607@huawei.com>
In-Reply-To: <549D03F6.9090607@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2014 01:45 AM, Li Bin wrote:
> On 2014/7/8 4:05, Peter Zijlstra wrote:
>> > On Mon, Jul 07, 2014 at 09:55:43AM -0400, Sasha Levin wrote:
>>> >> I've also had this one, which looks similar:
>>> >>
>>> >> [10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965
>>> >> [10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modprobe/10965, .owner_cpu: 15
>>> >> [10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765
>> > 
>> > Something's fucked; so we have:
>> > 
>> > debug_spin_lock_before()
>> > 	SPIN_BUG_ON(lock->owner == current, "recursion");
>> > 
> Hello，
> Does ACCESS_ONCE() can help this issue? I have no evidence that its lack is
> responsible for the issue, but I think here need it indeed. Is that right?
> 
> SPIN_BUG_ON(ACCESS_ONCE(lock->owner) == current, "recursion");

Could you explain a bit more why do you think it's needed?


Thanks,
Sasha
