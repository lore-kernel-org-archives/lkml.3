Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaKXWbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:31:32 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:53739 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaKXWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:31:31 -0500
From: Sadasivan Shaiju <sshaiju@mvista.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdAINmH7Dx/za5LDQzCSyob2kXXF3A==
Date: Mon, 24 Nov 2014 14:31:26 -0800
Message-ID: <d1b4ee5706f2dcb796b53ffb41cad1f8@mail.gmail.com>
Subject: Network throughput is reducedof in total bandwidth in Mips.
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

When  using iperf   with  small  buffers  there  is a performance
degradation   for  3.10  kernel   from  2.6.32  kernel .   Using
profiling  tools   I am getting  the  following  data.

2.6.32   kerne  data
........
samples  %        symbol name
160321   39.1122  r4k_wait
43731    10.6687  __do_softirq
27547     6.7204  cvm_oct_napi_poll_68
16569     4.0422  _raw_spin_unlock_irqrestore
12537     3.0586  cvm_oct_xmit
7362      1.7960  kfree
5916      1.4433  tcp_ack
5480      1.3369  net_rx_action
5353      1.3059  __copy_user_common
5097      1.2435  put_page
4447      1.0849  __kmalloc
4361      1.0639  kmem_cache_alloc
4359      1.0634  skb_segment
4309      1.0512  tcp_v4_rcv
4120      1.0051  __inet_lookup_established
4016      0.9798  ip_route_input
4010      0.9783  napi_complete
3766      0.9188  tcp_write_xmit
3297      0.8043  free_hot_cold_page
3189      0.7780  kmem_cache_free

3.10  kernel  data
.......
samples  %        symbol name
186       8.6431  __do_softirq
127       5.9015  cvm_oct_napi_poll_68
80        3.7175  tcp_sendmsg
76        3.5316  tcp_write_xmit
72        3.3457  cvm_oct_xmit_lockless
71        3.2993  _raw_spin_lock_bh
48        2.2305  tcp_release_cb
47        2.1840  release_sock
44        2.0446  add_preempt_count
44        2.0446  tcp_transmit_skb
34        1.5799  skb_split
31        1.4405  sub_preempt_count
27        1.2546  dev_hard_start_xmit
25        1.1617  __srcu_read_lock
25        1.1617  skb_release_data
24        1.1152  tcp_ack
23        1.0688  __bzero
23        1.0688  _raw_spin_unlock_irqrestore
23        1.0688  ip_finish_output
22        1.0223  __copy_skb_header
21        0.9758  __kfree_skb
21        0.9758  ip_queue_xmit

Looks  like  mainly the  delay  is  causing   by  tcp_sendmsg()  and
tcp_write_xmit()   from  the  stack .   However   if  the  buffer  is
increased   to  default  (128k)  there  is  no  performance
Degradation .  This is  happening  only    for  small  buffers.

When  iperf is    used   as  below    the  bandwidth  on  3.10 kernel  is
only  around   600Mbps    compared   to  900Mbps   in  2.6.32  kernel.

./iperf3 -c 10.162.103.131 -l 1500

When  iperf  is  ran  with  default  buffers  as  follows  the  bandwidth
is same  in 3.10  kernel  and 2.6.32  kernel.

./iperf3 -c 10.162.103.131

Please  let me know  if  there is any fixes  available for  this .
