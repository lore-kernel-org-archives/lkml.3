Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaJKMmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 08:42:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47419 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaJKMmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 08:42:06 -0400
Message-ID: <54392576.30707@oracle.com>
Date: Sat, 11 Oct 2014 08:41:26 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "David S. Miller" <davem@davemloft.net>, tgraf@suug.ch,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rhashtable: hang while running tests on boot
References: <5437E1B3.6020409@oracle.com> <20141010142247.GU4880@linux.vnet.ibm.com>
In-Reply-To: <20141010142247.GU4880@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 10:22 AM, Paul E. McKenney wrote:
> I am guessing that this happens only when running the resizable hashtable
> tests -- if that guess is incorrect, please let me know.

Paul, I'm not sure if it's related or not - but I'm also seeing quite a few
unexplainable (read: which I can't explain) RCU stalls:

[ 2121.852211] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2121.852233]  0: (244 ticks this GP) idle=1f7/140000000000002/0 softirq=18045/18045 last_accelerate: 7794/c7aa, nonlazy_posted: 576737, ..
[ 2121.852260]  (detected by 7, t=20502 jiffies, g=16439, c=16438, q=63119)
[ 2121.852265] Task dump for CPU 0:
[ 2121.852294] ksoftirqd/0     R  running task    13504     3      2 0x10080008
[ 2121.852307]  ffff880068203d88 ffffffff8efe9a34 ffff880068203d48 0000000000000000
[ 2121.852317]  ffff8800681c3000 ffff880068200010 ffff880068200000 000001bae312d5a9
[ 2121.852327]  ffff880064a5b000 ffff880064a5b000 ffff880068203d78 0000000000000000
[ 2121.852330] Call Trace:
[ 2121.852354]  [<ffffffff8efe9a34>] ? __schedule+0x614/0xdd0
[ 2121.852364]  [<ffffffff8efea230>] schedule+0x40/0xb0
[ 2121.852378]  [<ffffffff8a1fe4a8>] smpboot_thread_fn+0x1b8/0x420
[ 2121.852389]  [<ffffffff8a1c7a90>] ? tasklet_init+0x70/0x70
[ 2121.852399]  [<ffffffff8a1fe2f0>] ? SyS_setgroups+0x1e0/0x1e0
[ 2121.852410]  [<ffffffff8a1f7aa4>] kthread+0x144/0x170
[ 2121.852420]  [<ffffffff8efec2cf>] ? wait_for_completion+0x10f/0x160
[ 2121.852431]  [<ffffffff8a1f7960>] ? flush_kthread_work+0x1d0/0x1d0
[ 2121.852440]  [<ffffffff8eff4a3c>] ret_from_fork+0x7c/0xb0
[ 2121.852450]  [<ffffffff8a1f7960>] ? flush_kthread_work+0x1d0/0x1d0


Thanks,
Sasha
