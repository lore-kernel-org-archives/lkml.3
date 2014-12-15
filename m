Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaLOBVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 20:21:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27753 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLOBU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 20:20:59 -0500
Message-ID: <548E374D.1040003@oracle.com>
Date: Sun, 14 Dec 2014 20:20:13 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@kernel.org>, David Lang <david@lang.hm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141212185454.GB4716@redhat.com> <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com> <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz> <20141212203417.GE25340@linux.vnet.ibm.com> <548B5CEC.1040607@oracle.com> <20141213083055.GI32572@gmail.com> <548C60FF.9020607@oracle.com> <20141213180752.GI25340@linux.vnet.ibm.com> <20141214175007.GA6927@linux.vnet.ibm.com> <548E214D.6040706@oracle.com> <20141215001123.GK5310@linux.vnet.ibm.com>
In-Reply-To: <20141215001123.GK5310@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2014 07:11 PM, Paul E. McKenney wrote:
>> Does it depend on anything not currently in -next? My build fails with
>> > 
>> > kernel/rcu/tree.c: In function ‘rcu_report_qs_rdp’:
>> > kernel/rcu/tree.c:2099:6: error: ‘struct rcu_data’ has no member named ‘gpwrap’
>> >    rdp->gpwrap) {
> Indeed it does.  Please see below for a port to current mainline.

With the patch:


[  620.340045] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  620.341087]  (detected by 22, t=8407 jiffies, g=10452, c=10451, q=3622)
[  620.342154] All QSes seen, last rcu_preempt kthread activity 4294990929/4294999330, jiffies_till_next_fqs=1
[  643.710049] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  643.710073] INFO: rcu_sched detected stalls on CPUs/tasks:
[  643.710093]  0: (6 ticks this GP) idle=bd5/140000000000002/0 softirq=12421/12421 fqs=0 last_accelerate: 5283/8643, nonlazy_posted: 643841, ..
[  643.710110]  (detected by 1, t=2102 jiffies, g=-292, c=-293, q=0)
[  643.710112] Task dump for CPU 0:
[  643.710129] kworker/0:1     R  running task    13016   628      2 0x10080008
[  643.710148] Workqueue: events vmstat_update
[  643.710156]  ffffffffb0301dc4 ffff88006be15000 ffff880060ba1c70 0000000000000000
[  643.710161]  ffff88006be10680 ffff8800633efde8 ffffffffa0461f1b ffff88006a776000
[  643.710166]  ffff880060ba1cb8 ffff880060ba1c78 ffff880060ba1c80 ffff880060ba1c90
[  643.710168] Call Trace:
[  643.710181]  [<ffffffffb0301dc4>] ? _raw_spin_unlock_irq+0x64/0x200
[  643.710191]  [<ffffffffa0461f1b>] ? process_one_work+0x5fb/0x1660
[  643.710197]  [<ffffffffa0463545>] ? worker_thread+0x5c5/0x1680
[  643.710205]  [<ffffffffb02f0b6f>] ? __schedule+0xf6f/0x2fc0
[  643.710211]  [<ffffffffa0462f80>] ? process_one_work+0x1660/0x1660
[  643.710216]  [<ffffffffa047ae22>] ? kthread+0x1f2/0x2b0
[  643.710221]  [<ffffffffa047ac30>] ? kthread_worker_fn+0x6a0/0x6a0
[  643.710226]  [<ffffffffb030243c>] ? ret_from_fork+0x7c/0xb0
[  643.710233]  [<ffffffffa047ac30>] ? kthread_worker_fn+0x6a0/0x6a0
[  643.711486]
[  643.711486]  (detected by 22, t=2104 jiffies, g=10453, c=10452, q=1570)
[  643.711486] All QSes seen, last rcu_preempt kthread activity 4294999565/4295001669, jiffies_till_next_fqs=1


Thanks,
Sasha
