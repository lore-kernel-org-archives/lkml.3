Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3BDQZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:25:09 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:43186 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3BDQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:25:07 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: zsmalloc: replace local MAX() with max()
Date: Mon,  4 Feb 2013 10:23:53 -0600
Message-Id: <1359995033-30225-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.1
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020416-3620-0000-0000-000001125E9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the local define MAX() macro with the
kernel-wide max() macro from kernel.h

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
Based on greg/staging-next

 drivers/staging/zsmalloc/zsmalloc-main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 06f73a9..fd63b67 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -122,10 +122,9 @@
 #define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS)
 #define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
 
-#define MAX(a, b) ((a) >= (b) ? (a) : (b))
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
+	max(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
 /*
-- 
1.8.1.1

