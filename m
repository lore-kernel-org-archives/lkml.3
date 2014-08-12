Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaHLNg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:36:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63861 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaHLNgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:36:25 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: tj@kernel.org, cl@linux-foundation.org, linux-mm@kvack.org,
        user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Honggang Li <enjoymindful@gmail.com>
Subject: [linux-next PATCH] Free percpu allocation info for uniprocessor system
Date: Tue, 12 Aug 2014 21:36:14 +0800
Message-Id: <1407850575-18794-1-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uniprocessor system should free percpu allocation info after use as SMP system.

Following table is the bootmem allocation information of one x86 UML virtual
machine with 256MB memory. The virtual machine is running linux-3.12.6. 
Page (0x8c07000) is wasted.
|------------------------------------------------------------------------------
|0x8a02000 empty_zero_page                         size=4096,    align=4096
|0x8a03000 empty_bad_page                          size=4096,    align=4096
|0x8a04000 mem_map,contig_page_data->node_mem_map  size=2097152, align=32
|0x8c04000 contig_page_data->pageblock_flags       size=24,      align=32
|0x8c04020 contig_page_data->wait_table            size=2048,    align=32
|0x8c05000 pte_t*                                  size=4096,    align=4096
|0x8c06000 saved_command_line                      size=91,      align=32
|0x8c06060 static_command_line                     size=91,      align=32
|0x8c060c0 pcpu_alloc_info *ai                     size=4096,    align=32
|0x8c08000 pcpu_base_addr                          size=32768,   align=4096
|0x8c10000 pcpu_group_offsets                      size=4,       align=32
|0x8c10020 pcpu_group_sizes                        size=4,       align=32
|0x8c10040 pcpu_unit_map                           size=4,       align=32
|0x8c10060 pcpu_unit_offsets                       size=4,       align=32
|0x8c10080 pcpu_slot                               size=120,     align=32
|0x8c10100 pcpu_first_chunk                        size=44,      align=32
|0x8c10140 pid_hash                                size=4096,    align=32
|0x8c11140 dentry_hashtable                        size=131072,  align=32
|0x8c31140 inode_hashtable                         size=65536,   align=32
|------------------------------------------------------------------------------

Recent UML is broken because of the commit:
"resource: provide new functions to walk through resources"

As a result, the patch had been tested on x86 and x86_64 UML virtual 
machines based on linux-next-v3.16.

Honggang Li (1):
  Free percpu allocation info for uniprocessor system

 mm/percpu.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
1.8.3.1

