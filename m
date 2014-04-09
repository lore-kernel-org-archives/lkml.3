Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbaDIStV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:49:21 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45217 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaDIStT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1ivSYeQcGf2d9kB-0R0TmCy=zaFg4WeJ2mgG_=K41hsoizyA@mail.gmail.com>
References: <CAF1ivSbZKbDc+rzd+CUqCzNmSgZmZTE-QeSU-2WmSiuEs-Kw_w@mail.gmail.com>
	<20140409182553.GE10526@twins.programming.kicks-ass.net>
	<CAF1ivSYeQcGf2d9kB-0R0TmCy=zaFg4WeJ2mgG_=K41hsoizyA@mail.gmail.com>
Date: Wed, 9 Apr 2014 11:49:17 -0700
Message-ID: <CAF1ivSbVf0+PTzFdO+tNo33C6h6=HiBeKVF2jRvMQe=+RnPVxA@mail.gmail.com>
Subject: Re: current->sched_class->yield_task is NULL, any hint?
From: Lin Ming <minggr@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 11:32 AM, Lin Ming <minggr@gmail.com> wrote:
> On Wed, Apr 9, 2014 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, Apr 09, 2014 at 10:43:32AM -0700, Lin Ming wrote:
>>> Hi Peter,
>>>
>>> I hit a panic in sys_sched_yield() because(for some unknown reason)
>>> current->sched_class->yield_task is NULL.
>>> It's an ARM embedded board with 3.4-rt kernel.
>>>
>>> Could you share any hint for the possible causes?
>>
>> What class does current->sched_class point to?
>
> [12890.088232] Process swapper/0 (pid: 0, stack limit = 0xc07042f0)
>
> It's idle task. I think it should be idle_sched_class.
> But let me double check it.

idle_sched_class has no "yield_task" defined.
Does it mean that idle task should not call yield() at all?

[12890.088232] Process swapper/0 (pid: 0, stack limit = 0xc07042f0)
[12890.094092] Stack: (0xc0705860 to 0xc0706000)
[12890.584616] Backtrace:
[12890.586996] [<c007a364>] (sys_sched_yield+0x0/0x90) from
[<c03cbf90>] (yield+0x2c/0x30)
[12890.598258] [<c03cbf64>] (yield+0x0/0x30) from [<c02eb650>]
(netlink_broadcast_filtered+0x3ec/0x400)
[12890.607170] [<c02eb264>] (netlink_broadcast_filtered+0x0/0x400)
from [<c02eb68c>] (netlink_broadcast+0x28/0x30)
[12890.616998] [<c02eb664>] (netlink_broadcast+0x0/0x30) from
[<c02ed420>] (msg_netlink_broadcast+0xa8/0xb4)
[12890.626337] [<c02ed378>] (msg_netlink_broadcast+0x0/0xb4) from
[<c039ad10>] (br_igmp_send_netlink_msg+0xb0/0xbc)
[12890.636256] [<c039ac60>] (br_igmp_send_netlink_msg+0x0/0xbc) from
[<c039b4a0>] (br_igmp_mc_fdb_add+0x424/0x6c0)
[12890.646084] [<c039b07c>] (br_igmp_mc_fdb_add+0x0/0x6c0) from
[<c039bd34>] (br_igmp_process_v3+0x4a8/0x518)
[12890.655515] [<c039b88c>] (br_igmp_process_v3+0x0/0x518) from
[<c039c110>] (br_igmp_snooping+0x36c/0x3e4)
[12890.664762] [<c039bda4>] (br_igmp_snooping+0x0/0x3e4) from
[<c039c204>] (br_igmp_mc_forward+0x7c/0x270)
[12890.673918] [<c039c188>] (br_igmp_mc_forward+0x0/0x270) from
[<c0393120>] (br_handle_frame_finish+0x160/0x358)
[12890.683654] [<c0392fc0>] (br_handle_frame_finish+0x0/0x358) from
[<c0398e7c>] (br_nf_pre_routing_finish+0x348/0x364)
[12890.693940] [<c0398b34>] (br_nf_pre_routing_finish+0x0/0x364) from
[<c03994c4>] (br_nf_pre_routing+0x5e0/0x630)
[12890.709291] [<c0398ee4>] (br_nf_pre_routing+0x0/0x630) from
[<c02eebf8>] (nf_iterate+0x68/0xa4)
[12890.717746] [<c02eeb90>] (nf_iterate+0x0/0xa4) from [<c02eec9c>]
(nf_hook_slow+0x68/0x124)
[12890.725803] [<c02eec34>] (nf_hook_slow+0x0/0x124) from [<c03935ac>]
(br_handle_frame+0x294/0x2e4)
[12890.734471] [<c0393318>] (br_handle_frame+0x0/0x2e4) from
[<c02c9eb0>] (__netif_receive_skb+0x3b0/0x514)
[12890.743718] [<c02c9b00>] (__netif_receive_skb+0x0/0x514) from
[<c02cabf0>] (netif_receive_skb+0xa8/0xbc)
[12890.752966] [<c02cab48>] (netif_receive_skb+0x0/0xbc) from
[<c02cd730>] (napi_skb_finish+0x34/0x50)
[12890.765235] [<c02cd6fc>] (napi_skb_finish+0x0/0x50) from
[<c02cd848>] (napi_gro_receive+0xfc/0x100)
[12890.777566] [<c02cd74c>] (napi_gro_receive+0x0/0x100) from
[<bf1a1618>] (nss_gmac_receive+0x48/0x4c [qca_nss_gmac])
[12890.787759] [<bf1a15d0>] (nss_gmac_receive+0x0/0x4c [qca_nss_gmac])
from [<bf186e40>] (nss_core_handle_napi+0x440/0xa78 [qca_nss_drv])
[12890.802989] [<bf186a00>] (nss_core_handle_napi+0x0/0xa78
[qca_nss_drv]) from [<c02cade4>] (net_rx_action+0x84/0x174)
[12890.813244] [<c02cad60>] (net_rx_action+0x0/0x174) from
[<c005ad80>] (__do_softirq+0xbc/0x160)
[12890.821637] [<c005acc4>] (__do_softirq+0x0/0x160) from [<c005b250>]
(irq_exit+0x58/0xa4)
[12890.829542] [<c005b1f8>] (irq_exit+0x0/0xa4) from [<c000ed60>]
(handle_IRQ+0x8c/0xb8)
[12890.840651] [<c000ecd4>] (handle_IRQ+0x0/0xb8) from [<c0008608>]
(gic_handle_irq+0x70/0xc4)
[12890.857681] [<c0008598>] (gic_handle_irq+0x0/0xc4) from
[<c000e080>] (__irq_svc+0x40/0x70)

>
> Thanks.
