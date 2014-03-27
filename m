Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaC0OrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:47:09 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64860 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbaC0OrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:47:08 -0400
MIME-Version: 1.0
Date: Thu, 27 Mar 2014 17:47:06 +0300
Message-ID: <CACVxJT-d=Sm1-N9wvojgXj0voBABwxrgV728fAyZuPX2BK-3vg@mail.gmail.com>
Subject: 3.14-rc6: BUG: Bad page map in process objdump pte:483d2025 pmd:daa04067
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hell knows what happened, I did nothing unusual...
This is the first time I see this message on this box.

[15173.408570] BUG: Bad page map in process objdump  pte:483d2025 pmd:daa04067
[15173.408578] page:ffffea000120f480 count:1 mapcount:-1
mapping:ffff88005316bb10 index:0x9a22
[15173.408580] page flags:
0x400000000002002c(referenced|uptodate|lru|mappedtodisk)
[15173.408585] page dumped because: bad pte
[15173.408588] addr:00007fe290749000 vm_flags:00000075 anon_vma:
   (null) mapping:ffff88007fe518c0 index:24
[15173.408593] vma->vm_ops->fault: filemap_fault+0x0/0x420
[15173.408597] vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x60
[15173.408601] CPU: 1 PID: 10326 Comm: objdump Not tainted 3.14.0-rc6 #13
[15173.408603] Hardware name: Hewlett-Packard HP Compaq dc7800
Convertible Minitower/0AACh, BIOS 786F1 v01.28 02/26/2009
[15173.408605]  ffff8800bb77faa8 ffff880047899c78 ffffffff814649d0
0000000000000007
[15173.408608]  00007fe290749000 ffff880047899cc8 ffffffff810f7ece
ffffea0002edf840
[15173.408611]  ffff88007fe518c0 ffff880047899ca8 00007fe29075e000
ffff8800daa04a48
[15173.408614] Call Trace:
[15173.408620]  [<ffffffff814649d0>] dump_stack+0x4e/0x71
[15173.408624]  [<ffffffff810f7ece>] print_bad_pte+0x18e/0x240
[15173.408627]  [<ffffffff810f94eb>] unmap_single_vma+0x5cb/0x5f0
[15173.408630]  [<ffffffff810f9c09>] unmap_vmas+0x49/0x90
[15173.408633]  [<ffffffff8110144d>] exit_mmap+0xbd/0x170
[15173.408637]  [<ffffffff81072cbc>] mmput+0x3c/0xb0
[15173.408640]  [<ffffffff81076db6>] do_exit+0x1f6/0x900
[15173.408644]  [<ffffffff8109e1cb>] ? local_clock+0x1b/0x30
[15173.408647]  [<ffffffff8109eb28>] ? vtime_account_user+0x58/0x70
[15173.408650]  [<ffffffff810775da>] do_group_exit+0x3a/0xa0
[15173.408652]  [<ffffffff81077652>] SyS_exit_group+0x12/0x20
[15173.408656]  [<ffffffff8146a459>] tracesys+0xd0/0xd5
[15173.408658] Disabling lock debugging due to kernel taint
[15173.408741] BUG: Bad page state in process objdump  pfn:483d2
[15173.408743] page:ffffea000120f480 count:0 mapcount:-1
mapping:ffff88005316bb10 index:0x9a22
[15173.408745] page flags: 0x400000000002000c(referenced|uptodate|mappedtodisk)
[15173.408748] page dumped because: non-NULL mapping
[15173.408750] Modules linked in: usbhid uhci_hcd
[15173.408755] CPU: 1 PID: 10326 Comm: objdump Tainted: G    B
3.14.0-rc6 #13
[15173.408756] Hardware name: Hewlett-Packard HP Compaq dc7800
Convertible Minitower/0AACh, BIOS 786F1 v01.28 02/26/2009
[15173.408758]  ffffffff816f248a ffff880047899bd8 ffffffff814649d0
0000000000000007
[15173.408761]  ffffea000120f480 ffff880047899c08 ffffffff810e2761
ffffea00034d2400
[15173.408764]  ffffea000120f480 0000000000000000 ffffffff816f248a
ffff880047899c58
[15173.408767] Call Trace:
[15173.408770]  [<ffffffff814649d0>] dump_stack+0x4e/0x71
[15173.408773]  [<ffffffff810e2761>] bad_page+0xc1/0x110
[15173.408776]  [<ffffffff810e2885>] free_pages_prepare+0xd5/0x100
[15173.408778]  [<ffffffff810e3e3c>] free_hot_cold_page+0x2c/0x120
[15173.408781]  [<ffffffff810e43a8>] free_hot_cold_page_list+0x38/0x60
[15173.408784]  [<ffffffff810e78da>] release_pages+0x7a/0x1a0
[15173.408788]  [<ffffffff81109cc5>] free_pages_and_swap_cache+0x95/0xb0
[15173.408791]  [<ffffffff810f8024>] tlb_flush_mmu+0x54/0x90
[15173.408794]  [<ffffffff810f806f>] tlb_finish_mmu+0xf/0x40
[15173.408796]  [<ffffffff8110147c>] exit_mmap+0xec/0x170
[15173.408799]  [<ffffffff81072cbc>] mmput+0x3c/0xb0
[15173.408802]  [<ffffffff81076db6>] do_exit+0x1f6/0x900
[15173.408804]  [<ffffffff8109e1cb>] ? local_clock+0x1b/0x30
[15173.408807]  [<ffffffff8109eb28>] ? vtime_account_user+0x58/0x70
[15173.408810]  [<ffffffff810775da>] do_group_exit+0x3a/0xa0
[15173.408813]  [<ffffffff81077652>] SyS_exit_group+0x12/0x20
[15173.408816]  [<ffffffff8146a459>] tracesys+0xd0/0xd5
