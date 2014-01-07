Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaAGPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:16:58 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:52375 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAGPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:16:50 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, tangchen@cn.fujitsu.com, tj@kernel.org,
        toshi.kani@hp.com, Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: [PATCH 0/2] Small fixes to memblock and nobootmem
Date: Tue,  7 Jan 2014 16:16:12 +0100
Message-Id: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010715-8372-0000-0000-00000843F9A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on the conversion of the s390 port to use memblock and
nobootmem instead of bootmem I discovered two small bugs:

alloc_memory_core_early() in mm/nobootmem.c called memblock_reserve()
without forwarding the return value of memblock_reserve().

free_low_memory_core() (used by free_all_bootmem) in mm/nobootmem.c
already took care of releasing the memblock.reserved array in case
it has been allocated using memblock itself. This behaviour was
missing for memblock.memory.
Cases where memblock.memory grows bigger than the initial 128 entries
have been seen. So this should be supported as well.

Philipp Hachtmann (2):
  mm, nobootmem: Add return value check in __alloc_memory_core_early()
  mm: free memblock.memory in free_all_bootmem

 include/linux/memblock.h |  1 +
 mm/memblock.c            | 12 ++++++++++++
 mm/nobootmem.c           | 11 +++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

-- 
1.8.4.5

