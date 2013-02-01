Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3BAUyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:54:07 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:61231 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab3BAUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:52:40 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rcj@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 12/16] zcache/zbud: Fix compiler warnings.
Date: Fri,  1 Feb 2013 15:52:15 -0500
Message-Id: <1359751939-23584-13-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
References: <1359751939-23584-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
1.7.11.7

