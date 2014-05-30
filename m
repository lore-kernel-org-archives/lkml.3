Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaE3AJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 20:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaE3AJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 20:09:51 -0400
Date: Thu, 29 May 2014 20:09:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org
Subject: sleeping function warning from __put_anon_vma
Message-ID: <20140530000944.GA29942@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:47
in_atomic(): 0, irqs_disabled(): 0, pid: 5787, name: trinity-c27
Preemption disabled at:[<ffffffff990acc7e>] vtime_account_system+0x1e/0x50
CPU: 0 PID: 5787 Comm: trinity-c27 Not tainted 3.15.0-rc7+ #219
 ffffffff99a47203 0000000099b50bef ffff880239f138c8 ffffffff99739dfb
 0000000000000000 ffff880239f138f0 ffffffff990a026c ffff8801078b5458
 ffff8801078b5450 ffffea00044be980 ffff880239f13908 ffffffff99741c30
Call Trace:
 [<ffffffff99739dfb>] dump_stack+0x4e/0x7a
 [<ffffffff990a026c>] __might_sleep+0x11c/0x1b0
 [<ffffffff99741c30>] down_write+0x20/0x40
 [<ffffffff9919337d>] __put_anon_vma+0x3d/0xc0
 [<ffffffff99193998>] page_get_anon_vma+0x68/0xb0
 [<ffffffff991b97e9>] migrate_pages+0x449/0x880
 [<ffffffff9917dc00>] ? isolate_freepages_block+0x360/0x360
 [<ffffffff9917ec8a>] compact_zone+0x38a/0x580
 [<ffffffff9917ef29>] compact_zone_order+0xa9/0x130
 [<ffffffff9917f329>] try_to_compact_pages+0xe9/0x140
 [<ffffffff991616da>] __alloc_pages_direct_compact+0x7a/0x250
 [<ffffffff99161fbb>] __alloc_pages_nodemask+0x70b/0xbb0
 [<ffffffff991a9c3f>] alloc_pages_vma+0xaf/0x1c0
 [<ffffffff991bdc8d>] do_huge_pmd_anonymous_page+0xed/0x3d0
 [<ffffffff991871b4>] handle_mm_fault+0x1b4/0xc50
 [<ffffffff9974358d>] ? retint_restore_args+0xe/0xe
 [<ffffffff99746939>] __do_page_fault+0x1c9/0x630
 [<ffffffff99118acb>] ? __acct_update_integrals+0x8b/0x120
 [<ffffffff9974725b>] ? preempt_count_sub+0xab/0x100
 [<ffffffff99746dbe>] do_page_fault+0x1e/0x70
 [<ffffffff997437f2>] page_fault+0x22/0x30

