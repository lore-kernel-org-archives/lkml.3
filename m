Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaJXAWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:22:16 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35803 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbaJXAWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:22:14 -0400
Date: Thu, 23 Oct 2014 17:18:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: hung tasks in 3.18.0-rc1-00221-gc3351df
Message-ID: <20141024001822.GK4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.11.1410231619340.11555@adalberg.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1410231619340.11555@adalberg.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102400-0025-0000-0000-000000D9AE6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 04:21:17PM +0300, Meelis Roos wrote:
> This is first real test on a computer where 3.17 did hang. Fist the hung 
> task info, then full dmesg.
> 
> [  960.346611] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
> [  960.346616]       Tainted: G        W      3.18.0-rc1-00221-gc3351df #150
> [  960.346618] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  960.346621] kworker/u16:0   D 0000000000000000     0     6      2 0x00000000
> [  960.346633] Workqueue: netns cleanup_net
> [  960.346635]  ffff880111c4d1e0 0000000000000002 ffff880111c4d1e0 ffff880111c53fd8
> [  960.346639]  ffff880111c4d1e0 000000000000a000 ffff880111c4d1e0 0000000000000296
> [  960.346642]  0000000000000000 7fffffffffffffff 7fffffffffffffff ffffffff8182e010
> [  960.346646] Call Trace:
> [  960.346654]  [<ffffffff8153dcfd>] ? schedule_timeout+0x18d/0x200
> [  960.346660]  [<ffffffff810915a0>] ? get_state_synchronize_rcu+0x10/0x10
> [  960.346664]  [<ffffffff8153c544>] ? wait_for_completion+0xb4/0x110
> [  960.346669]  [<ffffffff8153e5d5>] ? _raw_spin_unlock_irqrestore+0x5/0x10
> [  960.346672]  [<ffffffff8153c539>] ? wait_for_completion+0xa9/0x110
> [  960.346677]  [<ffffffff81069450>] ? wake_up_state+0x10/0x10
> [  960.346681]  [<ffffffff8109285a>] ? _rcu_barrier+0x14a/0x1d0
> [  960.346686]  [<ffffffff8145f13c>] ? netdev_run_todo+0x5c/0x310
> [  960.346691]  [<ffffffff81458775>] ? rollback_registered_many+0x265/0x2d0
> [  960.346696]  [<ffffffff81459db6>] ? default_device_exit_batch+0x136/0x150
> [  960.346701]  [<ffffffff8107a240>] ? __wake_up_sync+0x10/0x10
> [  960.346704]  [<ffffffff81454310>] ? cleanup_net+0xf0/0x1d0
> [  960.346709]  [<ffffffff8105b566>] ? process_one_work+0x136/0x380
> [  960.346713]  [<ffffffff81058ca7>] ? pwq_activate_delayed_work+0x27/0x40
> [  960.346716]  [<ffffffff8105ba83>] ? worker_thread+0x63/0x480
> [  960.346720]  [<ffffffff8105ba20>] ? rescuer_thread+0x270/0x270
> [  960.346723]  [<ffffffff8105fc9e>] ? kthread+0xce/0xf0
> [  960.346726]  [<ffffffff81060000>] ? queue_kthread_work+0x80/0x80
> [  960.346729]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
> [  960.346734]  [<ffffffff8153ed2c>] ? ret_from_fork+0x7c/0xb0
> [  960.346737]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
> [ 1080.363583] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
> [ 1080.363589]       Tainted: G        W      3.18.0-rc1-00221-gc3351df #150
> [ 1080.363591] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1080.363594] kworker/u16:0   D 0000000000000000     0     6      2 0x00000000
> [ 1080.363604] Workqueue: netns cleanup_net
> [ 1080.363607]  ffff880111c4d1e0 0000000000000002 ffff880111c4d1e0 ffff880111c53fd8
> [ 1080.363610]  ffff880111c4d1e0 000000000000a000 ffff880111c4d1e0 0000000000000296
> [ 1080.363614]  0000000000000000 7fffffffffffffff 7fffffffffffffff ffffffff8182e010
> [ 1080.363617] Call Trace:
> [ 1080.363625]  [<ffffffff8153dcfd>] ? schedule_timeout+0x18d/0x200
> [ 1080.363633]  [<ffffffff810915a0>] ? get_state_synchronize_rcu+0x10/0x10
> [ 1080.363637]  [<ffffffff8153c544>] ? wait_for_completion+0xb4/0x110
> [ 1080.363641]  [<ffffffff8153e5d5>] ? _raw_spin_unlock_irqrestore+0x5/0x10
> [ 1080.363645]  [<ffffffff8153c539>] ? wait_for_completion+0xa9/0x110
> [ 1080.363649]  [<ffffffff81069450>] ? wake_up_state+0x10/0x10
> [ 1080.363653]  [<ffffffff8109285a>] ? _rcu_barrier+0x14a/0x1d0
> [ 1080.363658]  [<ffffffff8145f13c>] ? netdev_run_todo+0x5c/0x310
> [ 1080.363663]  [<ffffffff81458775>] ? rollback_registered_many+0x265/0x2d0
> [ 1080.363667]  [<ffffffff81459db6>] ? default_device_exit_batch+0x136/0x150
> [ 1080.363672]  [<ffffffff8107a240>] ? __wake_up_sync+0x10/0x10
> [ 1080.363676]  [<ffffffff81454310>] ? cleanup_net+0xf0/0x1d0
> [ 1080.363681]  [<ffffffff8105b566>] ? process_one_work+0x136/0x380
> [ 1080.363684]  [<ffffffff81058ca7>] ? pwq_activate_delayed_work+0x27/0x40
> [ 1080.363688]  [<ffffffff8105ba83>] ? worker_thread+0x63/0x480
> [ 1080.363691]  [<ffffffff8105ba20>] ? rescuer_thread+0x270/0x270
> [ 1080.363695]  [<ffffffff8105fc9e>] ? kthread+0xce/0xf0
> [ 1080.363698]  [<ffffffff81060000>] ? queue_kthread_work+0x80/0x80
> [ 1080.363702]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
> [ 1080.363706]  [<ffffffff8153ed2c>] ? ret_from_fork+0x7c/0xb0
> [ 1080.363709]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180

The get_state_synchronize_rcu() from within the wait for _rcu_barrier()
looks a bit odd, but perhaps this is stack-tracing inaccuracy.

Could you please send your .config?

							Thanx, Paul

