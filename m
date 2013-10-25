Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3JYPD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:03:58 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61077 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab3JYPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:03:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the block tree
Date: Fri, 25 Oct 2013 17:03:46 +0200
Message-Id: <1382713426-2680-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382713426-2680-1-git-send-email-treding@nvidia.com>
References: <1382713426-2680-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next tree of the block tree got conflicts in

	include/linux/blk_types.h

caused by commits 1063cee (nfs: simplify swap) and 8382f11 (block: make
rq->cmd_flags be 64-bit).

I fixed them up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc include/linux/blk_types.h
index 1bea25f,238ef0e..2c1c8c9
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@@ -176,7 -176,9 +176,8 @@@ enum rq_flag_bits 
  	__REQ_FLUSH_SEQ,	/* request for flush sequence */
  	__REQ_IO_STAT,		/* account I/O stat */
  	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 -	__REQ_KERNEL, 		/* direct IO to kernel pages */
  	__REQ_PM,		/* runtime pm request */
+ 	__REQ_END,		/* last of chain of requests */
  	__REQ_NR_BITS,		/* stops here */
  };
  
@@@ -205,27 -207,29 +206,28 @@@
  #define REQ_NOMERGE_FLAGS \
  	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
  
- #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
- #define REQ_THROTTLED		(1 << __REQ_THROTTLED)
- 
- #define REQ_SORTED		(1 << __REQ_SORTED)
- #define REQ_SOFTBARRIER		(1 << __REQ_SOFTBARRIER)
- #define REQ_FUA			(1 << __REQ_FUA)
- #define REQ_NOMERGE		(1 << __REQ_NOMERGE)
- #define REQ_STARTED		(1 << __REQ_STARTED)
- #define REQ_DONTPREP		(1 << __REQ_DONTPREP)
- #define REQ_QUEUED		(1 << __REQ_QUEUED)
- #define REQ_ELVPRIV		(1 << __REQ_ELVPRIV)
- #define REQ_FAILED		(1 << __REQ_FAILED)
- #define REQ_QUIET		(1 << __REQ_QUIET)
- #define REQ_PREEMPT		(1 << __REQ_PREEMPT)
- #define REQ_ALLOCED		(1 << __REQ_ALLOCED)
- #define REQ_COPY_USER		(1 << __REQ_COPY_USER)
- #define REQ_FLUSH		(1 << __REQ_FLUSH)
- #define REQ_FLUSH_SEQ		(1 << __REQ_FLUSH_SEQ)
- #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
- #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
- #define REQ_SECURE		(1 << __REQ_SECURE)
- #define REQ_PM			(1 << __REQ_PM)
+ #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
+ #define REQ_THROTTLED		(1ULL << __REQ_THROTTLED)
+ 
+ #define REQ_SORTED		(1ULL << __REQ_SORTED)
+ #define REQ_SOFTBARRIER		(1ULL << __REQ_SOFTBARRIER)
+ #define REQ_FUA			(1ULL << __REQ_FUA)
+ #define REQ_NOMERGE		(1ULL << __REQ_NOMERGE)
+ #define REQ_STARTED		(1ULL << __REQ_STARTED)
+ #define REQ_DONTPREP		(1ULL << __REQ_DONTPREP)
+ #define REQ_QUEUED		(1ULL << __REQ_QUEUED)
+ #define REQ_ELVPRIV		(1ULL << __REQ_ELVPRIV)
+ #define REQ_FAILED		(1ULL << __REQ_FAILED)
+ #define REQ_QUIET		(1ULL << __REQ_QUIET)
+ #define REQ_PREEMPT		(1ULL << __REQ_PREEMPT)
+ #define REQ_ALLOCED		(1ULL << __REQ_ALLOCED)
+ #define REQ_COPY_USER		(1ULL << __REQ_COPY_USER)
+ #define REQ_FLUSH		(1ULL << __REQ_FLUSH)
+ #define REQ_FLUSH_SEQ		(1ULL << __REQ_FLUSH_SEQ)
+ #define REQ_IO_STAT		(1ULL << __REQ_IO_STAT)
+ #define REQ_MIXED_MERGE		(1ULL << __REQ_MIXED_MERGE)
+ #define REQ_SECURE		(1ULL << __REQ_SECURE)
 -#define REQ_KERNEL		(1ULL << __REQ_KERNEL)
+ #define REQ_PM			(1ULL << __REQ_PM)
+ #define REQ_END			(1ULL << __REQ_END)
  
  #endif /* __LINUX_BLK_TYPES_H */
