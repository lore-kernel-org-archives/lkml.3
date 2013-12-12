Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3LLXq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:46:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab3LLXqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:46:53 -0500
Date: Thu, 12 Dec 2013 17:51:19 -0500
From: Dave Jones <davej@redhat.com>
To: linux-mm@kvack.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: kernel BUG at mm/mempolicy.c:1204!
Message-ID: <20131212225119.GA18718@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this with my fuzz tester.

kernel BUG at mm/mempolicy.c:1204!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 3 PID: 7056 Comm: trinity-child3 Not tainted 3.13.0-rc3+ #2
task: ffff8801ca5295d0 ti: ffff88005ab20000 task.ti: ffff88005ab20000
RIP: 0010:[<ffffffff8119f200>]  [<ffffffff8119f200>] new_vma_page+0x70/0x90
RSP: 0000:ffff88005ab21db0  EFLAGS: 00010246
RAX: fffffffffffffff2 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000008040075 RSI: ffff8801c3d74600 RDI: ffffea00079a8b80
RBP: ffff88005ab21dc8 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: fffffffffffffff2
R13: ffffea00079a8b80 R14: 0000000000400000 R15: 0000000000400000
FS:  00007ff49c6f4740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff49c68f994 CR3: 000000005a205000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
 ffffea00079a8b80 ffffea00079a8bc0 ffffea00079a8ba0 ffff88005ab21e50
 ffffffff811adc7a 0000000000000000 ffff8801ca5295d0 0000000464e224f8
 0000000000000000 0000000000000002 0000000000000000 ffff88020ce75c00
Call Trace:
 [<ffffffff811adc7a>] migrate_pages+0x12a/0x850
 [<ffffffff8119f190>] ? alloc_pages_vma+0x1b0/0x1b0
 [<ffffffff8119fa13>] SYSC_mbind+0x513/0x6a0
 [<ffffffff810aa7de>] ? lock_release_holdtime.part.29+0xee/0x170
 [<ffffffff8119fbae>] SyS_mbind+0xe/0x10
 [<ffffffff817626a9>] ia32_do_call+0x13/0x13
Code: 85 c0 75 2f 4c 89 e1 48 89 da 31 f6 bf da 00 02 00 65 44 8b 04 25 08 f7 1c 00 e8 ec fd ff ff 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 <0f> 0b 66 0f 1f 44 00 00 4c 89 e6 48 89 df ba 01 00 00 00 e8 48 
RIP  [<ffffffff8119f200>] new_vma_page+0x70/0x90
 RSP <ffff88005ab21db0>


That's..

1200         /*
1201          * queue_pages_range() confirms that @page belongs to some vma,
1202          * so vma shouldn't be NULL.
1203          */
1204         BUG_ON(!vma);
1205 

