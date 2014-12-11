Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbaLKBEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:04:00 -0500
Received: from [141.84.69.5] ([141.84.69.5]:41251 "EHLO mail.stusta.mhn.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbaLKBDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:03:47 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2014 20:03:46 EST
From: Markus Kaindl <markus.kaindl@stustanet.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: BUG: kernel panic nf_ct_del_from_dying_or_unconfirmed_list
Date: Thu, 11 Dec 2014 01:55:09 +0100
Message-ID: <1855695.mhsXPet1XK@lhotse>
Organization: StuStaNet e. V.
User-Agent: KMail/4.14.3 (Linux/3.17.5-gentoo; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

shortly after changing from wireless to wired network connection, both using 
IPv4 and Isatap, I experienced the following kernel panic. I was doing a 
speedtest on the wired connection when the panic occured.

I tried to reproduce it, but I was not able to.

[...] (could not get more scroll back...)
[13139.648381] ffff880174d149e0 ffff88000cb8b828 ffff8800a73b7858 ffffffff81864dbe
[13139.648429] ffff88000cb8b828 ffff8800a?3b?B?0 ffffffffB1825e85 ffff88000cb8b828
[13139.648472] Call Trace:
[13139.648490] [<ffffffff81869885>] destroy_conntrack+0x55/0xc0
[13139.648521] [<ffffffff81864dbe>] nf_conntrack_destroy+0x1e/0x30
[13139.648555] [<ffffffff81825e85>] skb_release_head_state+0xa5/0xf0
[13139.648590] [<ffffffff8182682d>] skb_release_all+0xd/0x30
[13139.648620] [<ffffffff818268a2>] kfree_skb+0x32/0xa0
[13139.648649] [<ffffffff81884630>] ? ip_fragment+0x8d0/0x8d0
[13139.848681] [<ffffffff81864fd8>] nf_hook_slow+0x108/0x120
[13139.648712] [<ffffffff81884630>] ? ip_fragment+0x8d0/0x8d0
[13139.648745] [<ffffffffB18861e5>] ip_output+0x75/0x90
[13139.648775] [<ffffffff8188592b>] ip_local_out_sk+0x2b/0x30
[13139.648807] [<ffffffff818c71ab>] iptunnel_xmit+0xfb/0x120
[13139.648839] [<ffffffff8192548e>] sit_tunnel_xmit+0x3de/0x700
[13139.648870] [<ffffffff8112563e>] ? internal_add_timer+0x5e/0x80
[13139.648902] [<ffffffff81838c1?>] dev_hard_start_xmit+0x337/0x660
[13139.648933] [<ffffffff81839253>] __dev_queue_xmit+0x313/0x510
[13139.648965] [<ffffffff8183945b>] dev_queue_xmit+0xb/0x10
[13139.648995] [<ffffffff8184022c>] neigh_direct_output+0xc/0x10
[13139.649028] [<ffffffff818eb609>] ip6_finish_output2+0x159/0x490
[13139.649062] [<ffffffff818ee7f0>] ? ip6_fragment+0xa90/0xa90
[13139.649094] [<ffffffff818ee877>] ip6_finish_output+0x87/0xc0
[13139.649125] [<ffffffff818ee920>] ip6_output+0x70/0xb0
[13139.649154] [<ffffffff818ebd2a>] ip6_xmit+0x3ea/0x4d0
[13139.649184] [<ffffffff819195ba>] inet6_csk_xmit+0x6a/0xb0
[13139.649216] [<ffffffff8189cfc0>] tcp_transmit_skb+0x490/0x920
[13139.649249] [<ffffffff8189eba2>] tcp_connect+0x7d2/0x8f0
[13139.649280] [<£fffffff8191209a>] tcp_v6_connect+0x32a/0x620
[13139.649313] [<ffffffff8181d8ca>] ? sock_destroy_inode+0x2a/0x30
[13139.650532] [<ffffffff818b85c5>] __inet_stream_connect+0x95/0x310
[13139.651647] [<ffffffff810f323d>] ? get_parent_ip+0xd/0x50
[13139.652770] [<ffffffff810f32cd>] ? preempt_count_add+0x4d/0xa0
[13139.653904] [<ffffffff810d2b3e>] ? __local_bh_enable_ip+0x3e/0xa0
[13139.651985] [<ffffffff818b8873>] inet_stream_connect+0x33/0x50
[13139.656001] [<ffffffff8181ea57>] SYSC_connect+0xc7/0x100
[13139.656801] [<ffffffff81468a43>] ? __this_cpu_preempt_check+0x13/0x20
[13139.657584] [<ffffffff81011012>] ? syscall_trace_enter+0x232/0x260
[13139.658371] [<ffffffff8181f919>] SyS_connect+0x9/0x10
[13139.659154] [<ffffffff81a1608b>] tracesys+0xdd/0xe2
[13139.659923] Code: 98 e0 07 00 00 0f b7 47 06 48 03 1c c5 20 84 0d 82 48 89 
df e8 84 ce 1d 00 49 8b 44 24 10 48 85 c0 74 2d 49 8b 54 24 08 f6 c2 01 <48> 
89 10 75 04 48 89 42 08 48 b8 00 02 20 00 00 00 ad de 48 89
[13139.661710] RIP [<ffffffff81868b5e>] 
nf_ct_del_from_dying_or_unconfirmed_list+0x3e/0x70
[13139.662579] RSP (ffff8800a?3b?810>
[13139.669137] Kernel panic — not syncing: Fatal exception in interrupt
[13139.670262] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 
0xffffffff80000000-0xffffffff9fffffff)
[13139.671137] drm_kms_helper: panic occurred, switching back to text console


Any guesses?

Thanks,
Markus
