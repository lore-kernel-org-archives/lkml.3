Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab3IGJPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 05:15:32 -0400
Received: from baa.muuh.co.uk ([85.119.83.99]:45704 "EHLO baa.muuh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3IGJPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 05:15:30 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Sep 2013 05:15:30 EDT
Message-ID: <522AED1C.8010505@jeffray.co.uk>
Date: Sat, 07 Sep 2013 10:08:44 +0100
From: Ian Jeffray <ian@jeffray.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Daily oops's with 3.11
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

A previously stable solid system Core2 upgraded from 3.9.2 to
3.11 is now showing oops's more than every 24 hours.

Would appreciate any advice on how to begin to help debug this
as it appears to be deep in areas of the kernel I'm unfamiliar
with (I generally just tickle drivers)

TIA,

Ian.


BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<c10e6b40>] drop_buffers+0x20/0xa0
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: bttv tveeprom btcx_risc videobuf_dma_sg videobuf_core 
ahci libahci
CPU: 0 PID: 507 Comm: kswapd0 Not tainted 3.11.0 #2
Hardware name: System manufacturer P5KC/P5KC, BIOS 0701    07/03/2007
task: f618a680 ti: f611e000 task.ti: f611e000
EIP: 0060:[<c10e6b40>] EFLAGS: 00010286 CPU: 0
EIP is at drop_buffers+0x20/0xa0
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: f611fd30
ESI: f2d4df18 EDI: f700d620 EBP: f611fd28 ESP: f611fd18
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 01707000 CR4: 000007d0
Stack:
  f611fd30 f700d620 00000000 c18d59b4 f611fd40 c10e86ea 00000000 00000000
  00000000 c18d59b4 f611fd50 c1092157 f700d634 f611ff30 f611fde8 c109dc26
  f611fda8 00000000 f611fe3c 00000000 f618a680 c1698480 f618a680 00000000
Call Trace:
  [<c10e86ea>] try_to_free_buffers+0x3a/0x90
  [<c1092157>] try_to_release_page+0x47/0x60
  [<c109dc26>] shrink_page_list+0x696/0x7d0
  [<c109ceb9>] ? isolate_lru_pages.isra.47+0x49/0xd0
  [<c109e24f>] shrink_inactive_list+0x1ef/0x350
  [<c109e802>] shrink_lruvec+0x452/0x590
  [<c109c89d>] ? zone_balanced+0x1d/0x30
  [<c109ecbe>] kswapd+0x37e/0x700
  [<c14f1639>] ? __schedule+0x1d9/0x650
  [<c109e940>] ? shrink_lruvec+0x590/0x590
  [<c104f8ef>] kthread+0x8f/0xa0
  [<c14f3437>] ret_from_kernel_thread+0x1b/0x28
  [<c104f860>] ? __kthread_parkme+0x60/0x60
Code: 01 5b 5e 5f 5d c3 90 8d 74 26 00 55 89 e5 57 89 c7 56 53 83 ec 04 
89 55 f0 8b 00 f6 c4 08 0f 84 81 00 00 00 8b 77 1c 89 f1 66 90 <8b> 01 
f6 c4 08 74 0c 8b 47 04 85 c0 74 05 f0 80 48 4b 02 8b 19
EIP: [<c10e6b40>] drop_buffers+0x20/0xa0 SS:ESP 0068:f611fd18
CR2: 0000000000000000
---[ end trace 5439949abeda267a ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 507 at kernel/exit.c:703 do_exit+0x37/0x860()
Modules linked in: bttv tveeprom btcx_risc videobuf_dma_sg videobuf_core 
ahci libahci
CPU: 0 PID: 507 Comm: kswapd0 Tainted: G      D      3.11.0 #2
Hardware name: System manufacturer P5KC/P5KC, BIOS 0701    07/03/2007
  00000000 00000000 f611fb34 c14eec5c 00000000 f611fb64 c1037fda c15af4a4
  00000000 000001fb c15ad72d 000002bf c10394d7 c10394d7 00000009 00000246
  f618a680 f611fb74 c103801d 00000009 00000000 f611fbcc c10394d7 00000000
Call Trace:
  [<c14eec5c>] dump_stack+0x41/0x52
  [<c1037fda>] warn_slowpath_common+0x7a/0xa0
  [<c10394d7>] ? do_exit+0x37/0x860
  [<c10394d7>] ? do_exit+0x37/0x860
  [<c103801d>] warn_slowpath_null+0x1d/0x20
  [<c10394d7>] do_exit+0x37/0x860
  [<c14eb9a1>] ? printk+0x38/0x3a
  [<c1037f5a>] ? print_oops_end_marker+0x2a/0x30
  [<c1005067>] oops_end+0x67/0x90
  [<c14eaf9c>] no_context+0x188/0x190
  [<c14eb26d>] __bad_area_nosemaphore+0x128/0x130
  [<c129bd68>] ? blk_queue_bio+0x238/0x2b0
  [<c1093e9e>] ? mempool_alloc_slab+0xe/0x10
  [<c102f060>] ? vmalloc_sync_all+0x100/0x100
  [<c14eb287>] bad_area_nosemaphore+0x12/0x14
  [<c102edcd>] __do_page_fault+0x28d/0x420
  [<c10987ec>] ? test_set_page_writeback+0x9c/0x140
  [<c10b76ed>] ? __swap_writepage+0x13d/0x1e0
  [<c102f060>] ? vmalloc_sync_all+0x100/0x100
  [<c102f068>] do_page_fault+0x8/0x10
  [<c14f3246>] error_code+0x5a/0x60
  [<c102f060>] ? vmalloc_sync_all+0x100/0x100
  [<c10e6b40>] ? drop_buffers+0x20/0xa0
  [<c10e86ea>] try_to_free_buffers+0x3a/0x90
  [<c1092157>] try_to_release_page+0x47/0x60
  [<c109dc26>] shrink_page_list+0x696/0x7d0
  [<c109ceb9>] ? isolate_lru_pages.isra.47+0x49/0xd0
  [<c109e24f>] shrink_inactive_list+0x1ef/0x350
  [<c109e802>] shrink_lruvec+0x452/0x590
  [<c109c89d>] ? zone_balanced+0x1d/0x30
  [<c109ecbe>] kswapd+0x37e/0x700
  [<c14f1639>] ? __schedule+0x1d9/0x650
  [<c109e940>] ? shrink_lruvec+0x590/0x590
  [<c104f8ef>] kthread+0x8f/0xa0
  [<c14f3437>] ret_from_kernel_thread+0x1b/0x28
  [<c104f860>] ? __kthread_parkme+0x60/0x60
---[ end trace 5439949abeda267b ]---
