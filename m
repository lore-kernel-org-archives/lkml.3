Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3JHAVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:21:52 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35528 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3JHAVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:21:49 -0400
MIME-Version: 1.0
Date: Mon, 7 Oct 2013 20:21:47 -0400
Message-ID: <CAKON4OwxwRHw6KvkCpt-NxjxLO+Wce7nf99rMteKkWw9_rXdBQ@mail.gmail.com>
Subject: Allocation failure of USB URB in interrupt
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Stefan Monnier <monnier@iro.umontreal.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this USB driver out of DMA zone space? There seems to be plenty of
memory around.
How do you fix something like this?

---------- Forwarded message ----------
From: Stefan Monnier <monnier@iro.umontreal.ca>
Date: Mon, Oct 7, 2013 at 6:44 PM
Subject: [linux-sunxi] Re: Daily (or so) freezes of Mele A2000
To: linux-sunxi@googlegroups.com


>> My Mele A2000 (which is up 24/7, used mostly as a server) freezes on
>> a regular basis, sometimes once a day.

Also it turns out that I haven't been able to reproduce the freeze so
easily with the internal wifi (the wifi itself seems to get wedged such
that wpa_supplicant thinks it properly associates with the WPA
access-point, but no packet passes through (no DHCP, obviously, but
nothing on tcpdump either).  Taking the interface down and back up gets
it back into working order).  So, with the internal wifi, the problem
seems to be more squarely in the proprietary driver, tho I also get
a backtrace about a page allocation failure (but of order:2, see
backtrace below).


        Stefan


Non-fatal backtrace with the internal rtc8188cus wifi, which repeats
a few times and then stops.

[87304.960000] emacs: page allocation failure: order:2, mode:0x4020
[87304.960000] [<c0014bb8>] (unwind_backtrace+0x0/0x124) from
[<c00c5698>] (warn_alloc_failed+0xfc/0x124)
[87304.960000] [<c00c5698>] (warn_alloc_failed+0xfc/0x124) from
[<c00c7e94>] (__alloc_pages_nodemask+0x684/0x774)
[87304.960000] [<c00c7e94>] (__alloc_pages_nodemask+0x684/0x774) from
[<c00c7fa4>] (__get_free_pages+0x20/0x34)
[87304.960000] [<c00c7fa4>] (__get_free_pages+0x20/0x34) from
[<c00f2fb4>] (kmalloc_order_trace+0x28/0x90)
[87304.960000] [<c00f2fb4>] (kmalloc_order_trace+0x28/0x90) from
[<c031509c>] (alloc_temp_buffer+0x14/0x30)
[87304.960000] [<c031509c>] (alloc_temp_buffer+0x14/0x30) from
[<c031528c>] (sunxi_hcd_map_urb_for_dma+0x5c/0x17c)
[87304.960000] [<c031528c>] (sunxi_hcd_map_urb_for_dma+0x5c/0x17c)
from [<c02fa8c4>] (usb_hcd_submit_urb+0x600/0x768)
[87304.960000] [<c02fa8c4>] (usb_hcd_submit_urb+0x600/0x768) from
[<bf03779c>] (usb_read_port+0x1a4/0x1e0 [8192cu])
[87304.960000] [<bf03779c>] (usb_read_port+0x1a4/0x1e0 [8192cu]) from
[<bf00cab0>] (_rtw_read_port+0x44/0x48 [8192cu])
[87304.960000] [<bf00cab0>] (_rtw_read_port+0x44/0x48 [8192cu]) from
[<bf037914>] (usb_read_port_complete+0x13c/0x1d8 [8192cu])
[87304.960000] [<bf037914>] (usb_read_port_complete+0x13c/0x1d8
[8192cu]) from [<c02f9458>] (usb_hcd_giveback_urb+0x9c/0xf4)
[87304.960000] [<c02f9458>] (usb_hcd_giveback_urb+0x9c/0xf4) from
[<c030afa8>] (ehci_urb_done+0x8c/0x90)
[87304.960000] [<c030afa8>] (ehci_urb_done+0x8c/0x90) from
[<c030b060>] (qh_completions+0xb4/0x4bc)
[87304.960000] [<c030b060>] (qh_completions+0xb4/0x4bc) from
[<c030f6cc>] (ehci_work+0xc4/0x1dc)
[87304.960000] [<c030f6cc>] (ehci_work+0xc4/0x1dc) from [<c030ff90>]
(ehci_irq+0x310/0x374)
[87304.960000] [<c030ff90>] (ehci_irq+0x310/0x374) from [<c02f8950>]
(usb_hcd_irq+0x34/0x4c)
[87304.960000] [<c02f8950>] (usb_hcd_irq+0x34/0x4c) from [<c0092b68>]
(handle_irq_event_percpu+0x5c/0x220)
[87304.960000] [<c0092b68>] (handle_irq_event_percpu+0x5c/0x220) from
[<c0092d5c>] (handle_irq_event+0x30/0x40)
[87304.960000] [<c0092d5c>] (handle_irq_event+0x30/0x40) from
[<c00951a4>] (handle_level_irq+0xbc/0xcc)
[87304.960000] [<c00951a4>] (handle_level_irq+0xbc/0xcc) from
[<c0092580>] (generic_handle_irq+0x28/0x38)
[87304.960000] [<c0092580>] (generic_handle_irq+0x28/0x38) from
[<c000f064>] (handle_IRQ+0x68/0x8c)
[87304.960000] [<c000f064>] (handle_IRQ+0x68/0x8c) from [<c04c7e70>]
(__irq_usr+0x30/0x100)
[87304.960000] Mem-info:
[87304.960000] Normal per-cpu:
[87304.960000] CPU    0: hi:  186, btch:  31 usd: 120
[87304.960000] active_anon:2555 inactive_anon:6084 isolated_anon:0
[87304.960000]  active_file:49945 inactive_file:51786 isolated_file:0
[87304.960000]  unevictable:0 dirty:45 writeback:0 unstable:0
[87304.960000]  free:1656 slab_reclaimable:5250 slab_unreclaimable:2861
[87304.960000]  mapped:2882 shmem:47 pagetables:351 bounce:0
[87304.960000] Normal free:6624kB min:2884kB low:3604kB high:4324kB
active_anon:10220kB inactive_anon:24336kB active_file:199780kB
inactive_file:207144kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:520192kB mlocked:0kB dirty:180kB
writeback:0kB mapped:11528kB shmem:188kB slab_reclaimable:21000kB
slab_unreclaimable:11444kB kernel_stack:1128kB pagetables:1404kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[87304.960000] lowmem_reserve[]: 0 0 0
[87304.960000] Normal: 884*4kB 382*8kB 2*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6624kB
[87304.960000] 101945 total pagecache pages
[87304.960000] 167 pages in swap cache
[87304.960000] Swap cache stats: add 808, delete 641, find 941/964
[87304.960000] Free swap  = 1046116kB
[87304.960000] Total swap = 1048572kB
[87304.960000] 131072 pages of RAM
[87304.960000] 2117 free pages
[87304.960000] 8335 reserved pages
[87304.960000] 5795 slab pages
[87304.960000] 60689 pages shared
[87304.960000] 167 pages swap cached

--
You received this message because you are subscribed to the Google
Groups "linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send
an email to linux-sunxi+unsubscribe@googlegroups.com.
For more options, visit https://groups.google.com/groups/opt_out.


-- 
Jon Smirl
jonsmirl@gmail.com
