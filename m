Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3BNDFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:05:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19976 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3BNDFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 12/16] zcache/zbud: Fix compiler warnings.
Date: Wed, 13 Feb 2013 22:05:02 -0500
Message-Id: <1360811106-2679-13-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get tons of:
drivers/staging/zcache/zbud.c: In function ‘zbud_debugfs_init’:
drivers/staging/zcache/zbud.c:323:2: warning: passing argument 4 of
‘debugfs_create_size_t’ from incompatible pointer type [enabled by
default]
In file included from drivers/staging/zcache/zbud.c:305:0:

This fixes it

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zbud.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/zcache/zbud.c b/drivers/staging/zcache/zbud.c
index 6835fab..4654978 100644
--- a/drivers/staging/zcache/zbud.c
+++ b/drivers/staging/zcache/zbud.c
@@ -281,26 +281,26 @@ static inline char *zbud_data(void *zbpg,
  * debugfs viewers, some of these should also be atomic_long_t, but
  * I don't know how to expose atomics via debugfs either...
  */
-static unsigned long zbud_eph_pageframes;
-static unsigned long zbud_pers_pageframes;
-static unsigned long zbud_eph_zpages;
-static unsigned long zbud_pers_zpages;
+static ssize_t zbud_eph_pageframes;
+static ssize_t zbud_pers_pageframes;
+static ssize_t zbud_eph_zpages;
+static ssize_t zbud_pers_zpages;
 static u64 zbud_eph_zbytes;
 static u64 zbud_pers_zbytes;
-static unsigned long zbud_eph_evicted_pageframes;
-static unsigned long zbud_pers_evicted_pageframes;
-static unsigned long zbud_eph_cumul_zpages;
-static unsigned long zbud_pers_cumul_zpages;
+static ssize_t zbud_eph_evicted_pageframes;
+static ssize_t zbud_pers_evicted_pageframes;
+static ssize_t zbud_eph_cumul_zpages;
+static ssize_t zbud_pers_cumul_zpages;
 static u64 zbud_eph_cumul_zbytes;
 static u64 zbud_pers_cumul_zbytes;
-static unsigned long zbud_eph_cumul_chunk_counts[NCHUNKS];
-static unsigned long zbud_pers_cumul_chunk_counts[NCHUNKS];
-static unsigned long zbud_eph_buddied_count;
-static unsigned long zbud_pers_buddied_count;
-static unsigned long zbud_eph_unbuddied_count;
-static unsigned long zbud_pers_unbuddied_count;
-static unsigned long zbud_eph_zombie_count;
-static unsigned long zbud_pers_zombie_count;
+static ssize_t zbud_eph_cumul_chunk_counts[NCHUNKS];
+static ssize_t zbud_pers_cumul_chunk_counts[NCHUNKS];
+static ssize_t zbud_eph_buddied_count;
+static ssize_t zbud_pers_buddied_count;
+static ssize_t zbud_eph_unbuddied_count;
+static ssize_t zbud_pers_unbuddied_count;
+static ssize_t zbud_eph_zombie_count;
+static ssize_t zbud_pers_zombie_count;
 static atomic_t zbud_eph_zombie_atomic;
 static atomic_t zbud_pers_zombie_atomic;
 
-- 
1.8.0.2

