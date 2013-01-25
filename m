Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab3AYRqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:46:49 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58058 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208Ab3AYRqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:46:45 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: zsmalloc: make CLASS_DELTA relative to PAGE_SIZE
Date: Fri, 25 Jan 2013 11:46:18 -0600
Message-Id: <1359135978-15119-5-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012517-5806-0000-0000-00001EC1877B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now ZS_SIZE_CLASS_DELTA is hardcoded to be 16.  This
creates 254 classes for systems with 4k pages. However, on
PPC64 with 64k pages, it creates 4095 classes which is far
too many.

This patch makes ZS_SIZE_CLASS_DELTA relative to PAGE_SIZE
so that regardless of the page size, there will be the same
number of classes.

Acked-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 12f66c3..13018b7 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -141,7 +141,7 @@
  *  ZS_MIN_ALLOC_SIZE and ZS_SIZE_CLASS_DELTA must be multiple of ZS_ALIGN
  *  (reason above)
  */
-#define ZS_SIZE_CLASS_DELTA	16
+#define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> 8)
 #define ZS_SIZE_CLASSES		((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / \
 					ZS_SIZE_CLASS_DELTA + 1)
 
-- 
1.7.9.5

