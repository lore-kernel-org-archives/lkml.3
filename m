Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaEMFZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:25:50 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:37699 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaEMFZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:25:48 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-mm@kvack.org,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/2] zsmalloc: make zsmalloc module-buildable
Date: Tue, 13 May 2014 14:28:07 +0900
Message-Id: <1399958887-8432-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399958887-8432-1-git-send-email-minchan@kernel.org>
References: <1399958887-8432-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we can build zsmalloc as module because unmap_kernel_range
was exported.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 30cb6cb008f5..709a77a0fb55 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -558,7 +558,7 @@ config MEM_SOFT_DIRTY
 	  See Documentation/vm/soft-dirty.txt for more details.
 
 config ZSMALLOC
-	bool "Memory allocator for compressed pages"
+	tristate "Memory allocator for compressed pages"
 	depends on MMU
 	default n
 	help
-- 
1.9.2

