Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaEBNlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:41:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52185 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751643AbaEBNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:41:49 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] Kmemleak updates
Date: Fri,  2 May 2014 14:41:04 +0100
Message-Id: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series contains a few kmemleak updates:

- Avoid false positives caused by not tracking all memblock allocations
  and disabling the kmemleak early logging slightly earlier
- Debugging improvements for places where pre-allocation happens
  (mempool and radix tree)
- minor printk correction

Catalin Marinas (5):
  mm: Introduce kmemleak_update_trace()
  lib: Update the kmemleak allocation stack trace for kmemleak
  mm: Update the kmemleak stack trace for mempool allocations
  mm: Call kmemleak directly from memblock_(alloc|free)
  mm: Postpone the disabling of kmemleak early logging

Jianpeng Ma (1):
  mm/kmemleak.c: Use %u to print ->checksum.

 Documentation/kmemleak.txt |  1 +
 include/linux/kmemleak.h   |  4 ++++
 lib/radix-tree.c           |  6 ++++++
 mm/kmemleak.c              | 43 ++++++++++++++++++++++++++++++++++++++-----
 mm/memblock.c              |  9 ++++++++-
 mm/mempool.c               |  6 ++++++
 mm/nobootmem.c             |  2 --
 7 files changed, 63 insertions(+), 8 deletions(-)

