Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3LCDva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:51:30 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:41515 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3LCDv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:51:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7rbf7dwSZ12uoVXaf6HoRNDn0Pxxy-Vo_6F9kk+p07Qg@mail.gmail.com>
References: <CAFi4uRvcUPvKvaeO5gZnjhMCFS+08MhEixJw-iN0AWbeBfiHvQ@mail.gmail.com>
	<CAErSpo7rbf7dwSZ12uoVXaf6HoRNDn0Pxxy-Vo_6F9kk+p07Qg@mail.gmail.com>
Date: Tue, 3 Dec 2013 11:51:25 +0800
Message-ID: <CABawtvNbkeXdQiBYD9Q+oRijw6VnT=FHdiFkjvFfh8Uw8KvO_A@mail.gmail.com>
Subject: Re: NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Nick Pegg <nick@nickpegg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Jin Feng <joe.jin@oracle.com>, konrad.wilk@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,
   Seems not the same bug as  http://sourceforge.net/p/e1000/bugs/367/
,  Nick is not running his kernel on bare metal, per the error log,
he runs his kernel as HVM DomU guest or Dom0 on XEN ?  so just a check
of NULL will not fix that.

Thanks,
Ethan

On Thu, Nov 21, 2013 at 5:22 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc e1000-devel]
>
> On Wed, Nov 20, 2013 at 11:44 AM, Nick Pegg <nick@nickpegg.com> wrote:
>> Hello,
>>
>> I've been seeing some servers hit a condition where they receive a
>> large number of packets (over 500,000 per second, for example) which
>> causes a kernel panic due to a null pointer dereference. I've included
>> the tracebacks below.
>>
>> I have not been able to reproduce this in my lab, but out in the field
>> I've seen this happen with kernel versions 3.7.6 through 3.9.2 (e1000e
>> driver versions 2.1.4-k through 2.2.14-k), running with Intel 82574L
>> NICs.
>>
>> I've seen previous posts to this mailing list suggesting that this is
>> a hardware issue (the mitigation being turning TSO/GSO off), however
>> those tracebacks didn't show the interface getting unexpectedly reset,
>> causing the null pointer dereference. Is this possibly a problem with
>> the e1000e driver where it's not gracefully handling the reset?
>>
>> Let me know if more information is needed. And please CC me in replies
>> since I'm not subscribed to this list. Thanks!
>
> Intel maintains newer drivers out-of-tree at
> http://sourceforge.net/projects/e1000/, and it's possible this is some
> bug that has already been fixed.  The current version there looks like
> e1000e-2.5.4, released 2013-09-05.
>
> Possible similar report: http://sourceforge.net/p/e1000/bugs/367/ (no
> real data there).
>
>> --------
>> Nov 16 07:03:19 rx ------------[ cut here ]------------
>> Nov 16 07:03:19 rx WARNING: at net/sched/sch_generic.c:255
>> dev_watchdog+0x25b/0x270()
>> Nov 16 07:03:19 rx Hardware name: X8DT6
>> Nov 16 07:03:19 rx NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
>> Nov 16 07:03:19 rx Modules linked in: xt_u32 xt_physdev
>> ip6table_mangle ip6_tables ebt_comment ebt_set ebt_arp ebt_limit
>> ebt_ip6 ebt_ip ip_set_hash_net ip_set ebtable_nat xen_gntdev bonding
>> ebtable_filter 8021q mrp e1000e ptp pps_core
>> Nov 16 07:03:19 rx Pid: 14268, comm: kworker/0:0 Not tainted 3.9.2-1 #1
>> Nov 16 07:03:19 rx Call Trace:
>> Nov 16 07:03:19 rx  <IRQ>  [<ffffffff8105070a>] warn_slowpath_common+0x7a/0xc0
>> Nov 16 07:03:19 rx  [<ffffffff810507f1>] warn_slowpath_fmt+0x41/0x50
>> Nov 16 07:03:19 rx  [<ffffffff8168e2ab>] dev_watchdog+0x25b/0x270
>> Nov 16 07:03:19 rx  [<ffffffff8168e050>] ? __netdev_watchdog_up+0x80/0x80
>> Nov 16 07:03:19 rx  [<ffffffff81060464>] call_timer_fn+0x44/0x120
>> Nov 16 07:03:19 rx  [<ffffffff81060a71>] run_timer_softirq+0x241/0x2b0
>> Nov 16 07:03:19 rx  [<ffffffff8168e050>] ? __netdev_watchdog_up+0x80/0x80
>> Nov 16 07:03:19 rx  [<ffffffff8105893f>] __do_softirq+0xef/0x270
>> Nov 16 07:03:19 rx  [<ffffffff81058bc5>] irq_exit+0xb5/0xc0
>> Nov 16 07:03:19 rx  [<ffffffff81435a8f>] xen_evtchn_do_upcall+0x2f/0x40
>> Nov 16 07:03:19 rx  [<ffffffff817a24fe>] xen_do_hypervisor_callback+0x1e/0x30
>> Nov 16 07:03:19 rx  <EOI>  [<ffffffff813b3722>] ? delay_tsc+0x32/0x80
>> Nov 16 07:03:19 rx  [<ffffffff813b373a>] ? delay_tsc+0x4a/0x80
>> Nov 16 07:03:19 rx  [<ffffffff813b36e8>] ? __const_udelay+0x28/0x30
>> Nov 16 07:03:19 rx  [<ffffffffa0025b0e>] ?
>> e1000e_read_phy_reg_mdic+0xce/0x120 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffffa0018bd0>] ?
>> e1000_get_hw_semaphore_82574+0x20/0x40 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffffa0027a75>] ?
>> e1000e_read_phy_reg_bm2+0x55/0xb0 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffffa00330d6>] ?
>> e1000e_flush_descriptors+0x96/0x270 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffffa00181b7>] ?
>> e1000_check_phy_82574+0x27/0x60 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffffa0034178>] ?
>> e1000_watchdog_task+0x648/0x830 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffff81797877>] ? __schedule+0x3a7/0x7c0
>> Nov 16 07:03:19 rx  [<ffffffff8106c74e>] ? process_one_work+0x16e/0x430
>> Nov 16 07:03:19 rx  [<ffffffff8106ea3c>] ? worker_thread+0x11c/0x410
>> Nov 16 07:03:19 rx  [<ffffffff8106e920>] ? manage_workers+0x360/0x360
>> Nov 16 07:03:19 rx  [<ffffffff810738f6>] ? kthread+0xc6/0xd0
>> Nov 16 07:03:19 rx  [<ffffffff81003869>] ? xen_end_context_switch+0x19/0x20
>> Nov 16 07:03:19 rx  [<ffffffff81073830>] ?
>> kthread_freezable_should_stop+0x70/0x70
>> Nov 16 07:03:19 rx  [<ffffffff817a10bc>] ? ret_from_fork+0x7c/0xb0
>> Nov 16 07:03:19 rx  [<ffffffff81073830>] ?
>> kthread_freezable_should_stop+0x70/0x70
>> Nov 16 07:03:19 rx ---[ end trace f896af6c9f44182d ]---
>> Nov 16 07:03:19 rx e1000e 0000:03:00.0 eth0: Reset adapter unexpectedly
>> Nov 16 07:03:19 rx BUG: unable to handle kernel NULL pointer
>> dereference at 00000000000000d0
>> Nov 16 07:03:19 rx IP: [<ffffffffa0031d51>]
>> e1000_clean_rx_irq+0x101/0x490 [e1000e]
>> Nov 16 07:03:19 rx PGD 4a6c3067 PUD 4f440067 PMD 0
>> Nov 16 07:03:19 rx Oops: 0000 [#1] SMP
>> Nov 16 07:03:19 rx Modules linked in: xt_u32 xt_physdev
>> ip6table_mangle ip6_tables ebt_comment ebt_set ebt_arp ebt_limit
>> ebt_ip6 ebt_ip ip_set_hash_net ip_set ebtable_nat xen_gntdev bonding
>> ebtable_filter 8021q mrp e1000e ptp pps_core
>> Nov 16 07:03:19 rx CPU 0
>> Nov 16 07:03:19 rx Pid: 14268, comm: kworker/0:0 Tainted: G        W
>>  3.9.2-1 #1 Supermicro X8DT6/X8DT6
>> Nov 16 07:03:19 rx RIP: e030:[<ffffffffa0031d51>]
>> [<ffffffffa0031d51>] e1000_clean_rx_irq+0x101/0x490 [e1000e]
>> Nov 16 07:03:19 rx RSP: e02b:ffff88008ea03d98  EFLAGS: 00010202
>> Nov 16 07:03:19 rx RAX: 000000000000001a RBX: ffffc900115f9000 RCX:
>> ffff88008ea03e64
>> Nov 16 07:03:19 rx RDX: ffff88008ea03e64 RSI: ffff880002dc6e00 RDI:
>> ffff8800844026c0
>> Nov 16 07:03:19 rx RBP: ffff88008ea03e38 R08: 00000000000169e0 R09:
>> ffffea00000b7180
>> Nov 16 07:03:19 rx R10: 0000000000020063 R11: 0000000000000000 R12:
>> 0000000000000000
>> Nov 16 07:03:19 rx R13: ffff880081fb6000 R14: ffff88008016c700 R15:
>> ffff880081fb6000
>> Nov 16 07:03:19 rx FS:  00007fde5acb8700(0000)
>> GS:ffff88008ea00000(0000) knlGS:0000000000000000
>> Nov 16 07:03:19 rx CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
>> Nov 16 07:03:19 rx CR2: 00000000000000d0 CR3: 0000000071e80000 CR4:
>> 0000000000002660
>> Nov 16 07:03:19 rx DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> Nov 16 07:03:19 rx DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> Nov 16 07:03:19 rx Process kworker/0:0 (pid: 14268, threadinfo
>> ffff880045f8a000, task ffff88005c9c0000)
>> Nov 16 07:03:19 rx Stack:
>> Nov 16 07:03:19 rx  ffff880080220000 ffff880002dc6a00 000001d70000003c
>> 0000001100020063
>> Nov 16 07:03:19 rx  000000408ea03e18 ffff880083d7d000 000005dc00000019
>> ffff88008016c000
>> Nov 16 07:03:19 rx  ffff880083d7d098 0000000000000000 ffffc900115f9000
>> ffff88008ea03e64
>> Nov 16 07:03:19 rx Call Trace:
>> Nov 16 07:03:19 rx  <IRQ>
>> Nov 16 07:03:19 rx  [<ffffffffa003354d>] e1000e_poll+0xbd/0x2d0 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffff81673d7f>] net_rx_action+0xaf/0x220
>> Nov 16 07:03:19 rx  [<ffffffff810c4e72>] ? handle_edge_irq+0x92/0x140
>> Nov 16 07:03:19 rx  [<ffffffff8105893f>] __do_softirq+0xef/0x270
>> Nov 16 07:03:19 rx  [<ffffffff81058bc5>] irq_exit+0xb5/0xc0
>> Nov 16 07:03:19 rx  [<ffffffff81435a8f>] xen_evtchn_do_upcall+0x2f/0x40
>> Nov 16 07:03:19 rx  [<ffffffff817a24fe>] xen_do_hypervisor_callback+0x1e/0x30
>> Nov 16 07:03:19 rx  <EOI>
>> Nov 16 07:03:19 rx  [<ffffffff81664200>] ? skb_release_data+0x80/0xf0
>> Nov 16 07:03:19 rx  [<ffffffff8113291b>] ? __slab_free+0x14b/0x380
>> Nov 16 07:03:19 rx  [<ffffffff810f9dcb>] ? __free_pages_ok+0x8b/0xa0
>> Nov 16 07:03:19 rx  [<ffffffff810f9df6>] ? free_compound_page+0x16/0x20
>> Nov 16 07:03:19 rx  [<ffffffff810fdf27>] ? __put_compound_page+0x17/0x20
>> Nov 16 07:03:19 rx  [<ffffffff81132dcc>] ? kmem_cache_free+0x14c/0x170
>> Nov 16 07:03:19 rx  [<ffffffff816642f2>] ? __kfree_skb+0x42/0xa0
>> Nov 16 07:03:19 rx  [<ffffffff816643bc>] ? consume_skb+0x2c/0x70
>> Nov 16 07:03:19 rx  [<ffffffffa00324d7>] ?
>> e1000_clean_rx_ring+0xb7/0x2c0 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffffa0034bec>] ? e1000e_down+0x10c/0x260 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffffa0037ff4>] ?
>> e1000e_reinit_locked+0x44/0x60 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffffa0038102>] ? e1000_reset_task+0x42/0x7b0 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffff8106145a>] ? mod_timer+0x11a/0x1f0
>> Nov 16 07:03:19 rx  [<ffffffffa00340a6>] ?
>> e1000_watchdog_task+0x576/0x830 [e1000e]
>> Nov 16 07:03:19 rx  [<ffffffff81797877>] ? __schedule+0x3a7/0x7c0
>> Nov 16 07:03:19 rx  [<ffffffff8106c74e>] ? process_one_work+0x16e/0x430
>> Nov 16 07:03:19 rx  [<ffffffff8106ea3c>] ? worker_thread+0x11c/0x410
>> Nov 16 07:03:19 rx  [<ffffffff8106e920>] ? manage_workers+0x360/0x360
>> Nov 16 07:03:19 rx  [<ffffffff810738f6>] ? kthread+0xc6/0xd0
>> Nov 16 07:03:19 rx  [<ffffffff81003869>] ? xen_end_context_switch+0x19/0x20
>> Nov 16 07:03:19 rx  [<ffffffff81073830>] ?
>> kthread_freezable_should_stop+0x70/0x70
>> Nov 16 07:03:19 rx  [<ffffffff817a10bc>] ? ret_from_fork+0x7c/0xb0
>> Nov 16 07:03:19 rx  [<ffffffff81073830>] ?
>> kthread_freezable_should_stop+0x70/0x70
>> Nov 16 07:03:19 rx Code: 3b 45 84 0f 8d f1 01 00 00 48 8b 5d b0 4d 89
>> fd 48 03 5d a8 48 8b 4d b8 ff c0 89 01 0f ae e8 4c 8b 63 08 48 c7 43
>> 08 00 00 00 00 <49> 8b 84 24 d0 00 00 00 48 8b 75 c0 ff 45 cc 0f 18 08
>> 8b 45 cc
>> Nov 16 07:03:19 rx RIP  [<ffffffffa0031d51>]
>> e1000_clean_rx_irq+0x101/0x490 [e1000e]
>> Nov 16 07:03:19 rx  RSP <ffff88008ea03d98>
>> Nov 16 07:03:19 rx CR2: 00000000000000d0
>> Nov 16 07:03:19 rx ---[ end trace f896af6c9f44182e ]---
>> Nov 16 07:03:19 rx Kernel panic - not syncing: Fatal exception in interrupt
>> --------
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
