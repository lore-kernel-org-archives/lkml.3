Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3BOR7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:59:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19093 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3BOR7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:59:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] zbud: Fix compile warnings due to usage of debugfs_create_size_t
Date: Fri, 15 Feb 2013 12:53:43 -0500
Message-Id: <1360950824-11032-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360950824-11032-1-git-send-email-konrad.wilk@oracle.com>
References: <20130214172926.GA17343@kroah.com>
 <1360950824-11032-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.
drivers/staging/zcache/zbud.c:336: warning: passing argument 4 of ‘debugfs_create_size_t’ from incompatible pointer type
include/linux/debugfs.h:80: note: expected ‘size_t *’ but argument is of type ‘long unsigned int *’
..

which is b/c we end up using 'unsigned' or 'unsigned long' instead
of 'ssize_t'. So lets fix this up and use the proper type.

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

