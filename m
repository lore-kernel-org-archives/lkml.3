Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaBOLH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:07:58 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:63589 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBOLHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:07:55 -0500
MIME-Version: 1.0
Date: Sat, 15 Feb 2014 13:07:54 +0200
Message-ID: <CA+ydwtpXTcfcx246_ZEUtKeBQtOfS4CHdRnHO2id1P89E95a+w@mail.gmail.com>
Subject: BUG: Bad page state in process trinity-c19
From: Tommi Rantala <tt.rantala@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, trinity@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hit the following bug while fuzzing with trinity. I can see that Dave
reported similar bad page state problems for 3.13-rc4, but this one
does not seem to be AIO related.

https://lkml.org/lkml/2013/12/18/932

Tommi


BUG: Bad page state in process trinity-c19  pfn:2429e
page:ffffea000090a780 count:0 mapcount:0 mapping:ffff88003a018758 index:0xed
page flags: 0x100000000000008(uptodate)
page dumped because: non-NULL mapping
CPU: 1 PID: 28094 Comm: trinity-c19 Not tainted 3.14.0-rc2-00209-g45f7fdc #1
Hardware name: Hewlett-Packard HP Compaq dc5750 Small Form
Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
 ffffffff828f4590 ffff880054591758 ffffffff82363c9d ffffea000090a780
 ffff880054591780 ffffffff8235d165 ffffea000090a780 0000000000000000
 ffffea000090a780 ffff8800545917d8 ffffffff8121a010 ffffffff828f457f
Call Trace:
 [<ffffffff82363c9d>] dump_stack+0x4d/0x66
 [<ffffffff8235d165>] bad_page+0xd5/0xf2
 [<ffffffff8121a010>] free_pages_prepare+0x1f0/0x2b0
 [<ffffffff8121b00b>] free_hot_cold_page+0x3b/0x150
 [<ffffffff8121b22e>] free_hot_cold_page_list+0x10e/0x190
 [<ffffffff81221fec>] release_pages+0x1dc/0x210
 [<ffffffff812220f3>] pagevec_lru_move_fn+0xd3/0xf0
 [<ffffffff81220910>] ? __put_single_page+0x20/0x20
 [<ffffffff81222692>] __pagevec_lru_add+0x12/0x20
 [<ffffffff81222886>] __lru_cache_add+0x66/0x90
 [<ffffffff812228e5>] lru_cache_add+0x35/0x40
 [<ffffffff81226dda>] putback_lru_page+0x4a/0xd0
 [<ffffffff8126b98b>] migrate_pages+0x84b/0x880
 [<ffffffff81238130>] ? isolate_freepages_block+0x440/0x440
 [<ffffffff812391e9>] compact_zone+0x249/0x770
 [<ffffffff812399f6>] compact_zone_order+0xb6/0xf0
 [<ffffffff810a00c1>] ? native_send_call_func_single_ipi+0x31/0x40
 [<ffffffff81239ae2>] try_to_compact_pages+0xb2/0x110
 [<ffffffff8235d2ce>] __alloc_pages_direct_compact+0xa5/0x1b5
 [<ffffffff8235db18>] __alloc_pages_slowpath+0x73a/0x79e
 [<ffffffff81179f6d>] ? sched_clock_local+0x1d/0x90
 [<ffffffff8121cf26>] __alloc_pages_nodemask+0x226/0x3b0
 [<ffffffff8126004f>] alloc_pages_vma+0x16f/0x1e0
 [<ffffffff81270958>] ? do_huge_pmd_anonymous_page+0x218/0x3f0
 [<ffffffff81270958>] do_huge_pmd_anonymous_page+0x218/0x3f0
 [<ffffffff81240617>] handle_mm_fault+0x1d7/0x320
 [<ffffffff810b0db0>] __do_page_fault+0x4d0/0x540
 [<ffffffff811919b5>] ? trace_hardirqs_on_caller+0x185/0x220
 [<ffffffff81191a5d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8237d327>] ? _raw_spin_unlock_irq+0x27/0x40
 [<ffffffff8116dcd1>] ? finish_task_switch+0x81/0x130
 [<ffffffff8116dc93>] ? finish_task_switch+0x43/0x130
 [<ffffffff81546e5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff810b0e49>] do_page_fault+0x9/0x10
 [<ffffffff8237e438>] page_fault+0x28/0x30
Disabling lock debugging due to kernel taint
