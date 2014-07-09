Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaGILSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:18:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61610 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaGILKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:22 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-37-53bd2319a465
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 09/21] mm: Makefile: kasan: don't instrument slub.c
 and slab_common.c files
Date: Wed, 09 Jul 2014 15:01:06 +0400
Message-id: <1404903678-8257-10-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7qSynuDDVY/MLbY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+Pt7ldsBYtZKqZN7WZuYNzN3MXIySEhYCJx
	tGEFC4QtJnHh3nq2LkYuDiGBpYwS97ves0A4fUwSC+e/ZQWpYhPQk/g3azsbiC0ioCCxufcZ
	WJxZQEdi47VWJhBbWCBd4tWke2AbWARUJR7MmwcW5xVwk3i99ik7xDYFiWXLZ4L1cgLFe3oW
	gNUICbhKrP68jXECI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFh8HUH49JjVocY
	BTgYlXh4X+zeEyzEmlhWXJl7iFGCg1lJhNdWdG+wEG9KYmVValF+fFFpTmrxIUYmDk6pBkbR
	n2Z60+V4hZ1Uf7yeyRQtfidGwEpkd8ddqZ9Gm6Os3VLnHXrsH28RL6rSkvLKYK6/enlwYOzz
	PzM3V5+8cJD1969F7vaaEtzBq5kONs20YF9wNNKmPGhp4lsFaYNJv63cjzqYiX8waDjcLaXd
	w8S4YIe26kfliKm7DdjXfHrnvseHYesVTiWW4oxEQy3mouJEADDaqBvhAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code in slub.c and slab_common.c files could validly access to object's
redzones

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/Makefile b/mm/Makefile
index 6a9c3f8..59cc184 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -3,6 +3,8 @@
 #
 
 KASAN_SANITIZE_page_alloc.o := n
+KASAN_SANITIZE_slab_common.o := n
+KASAN_SANITIZE_slub.o := n
 
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= gup.o highmem.o madvise.o memory.o mincore.o \
-- 
1.8.5.5

