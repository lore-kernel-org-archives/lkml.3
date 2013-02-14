Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab3BNDHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:07:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48014 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/16] zcache: Make the debug code use pr_debug
Date: Wed, 13 Feb 2013 22:04:56 -0500
Message-Id: <1360811106-2679-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as if you are debugging this driver you would be using 'debug'
on the command line anyhow - and this would dump the debug
data on the proper loglevel.

While at it also remove the unconditional #define ZCACHE_DEBUG.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 85 +++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 4bd4107..d4bf4a2 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -355,71 +355,68 @@ static int zcache_debugfs_init(void)
 #undef	zdfs64
 #endif
 
-#define ZCACHE_DEBUG
-#ifdef ZCACHE_DEBUG
 /* developers can call this in case of ooms, e.g. to find memory leaks */
 void zcache_dump(void)
 {
-	pr_info("zcache: obj_count=%zd\n", zcache_obj_count);
-	pr_info("zcache: obj_count_max=%zd\n", zcache_obj_count_max);
-	pr_info("zcache: objnode_count=%zd\n", zcache_objnode_count);
-	pr_info("zcache: objnode_count_max=%zd\n", zcache_objnode_count_max);
-	pr_info("zcache: flush_total=%zd\n", zcache_flush_total);
-	pr_info("zcache: flush_found=%zd\n", zcache_flush_found);
-	pr_info("zcache: flobj_total=%zd\n", zcache_flobj_total);
-	pr_info("zcache: flobj_found=%zd\n", zcache_flobj_found);
-	pr_info("zcache: failed_eph_puts=%zd\n", zcache_failed_eph_puts);
-	pr_info("zcache: failed_pers_puts=%zd\n", zcache_failed_pers_puts);
-	pr_info("zcache: failed_get_free_pages=%zd\n",
+	pr_debug("zcache: obj_count=%zd\n", zcache_obj_count);
+	pr_debug("zcache: obj_count_max=%zd\n", zcache_obj_count_max);
+	pr_debug("zcache: objnode_count=%zd\n", zcache_objnode_count);
+	pr_debug("zcache: objnode_count_max=%zd\n", zcache_objnode_count_max);
+	pr_debug("zcache: flush_total=%zd\n", zcache_flush_total);
+	pr_debug("zcache: flush_found=%zd\n", zcache_flush_found);
+	pr_debug("zcache: flobj_total=%zd\n", zcache_flobj_total);
+	pr_debug("zcache: flobj_found=%zd\n", zcache_flobj_found);
+	pr_debug("zcache: failed_eph_puts=%zd\n", zcache_failed_eph_puts);
+	pr_debug("zcache: failed_pers_puts=%zd\n", zcache_failed_pers_puts);
+	pr_debug("zcache: failed_get_free_pages=%zd\n",
 				zcache_failed_getfreepages);
-	pr_info("zcache: failed_alloc=%zd\n", zcache_failed_alloc);
-	pr_info("zcache: put_to_flush=%zd\n", zcache_put_to_flush);
-	pr_info("zcache: compress_poor=%zd\n", zcache_compress_poor);
-	pr_info("zcache: mean_compress_poor=%zd\n",
+	pr_debug("zcache: failed_alloc=%zd\n", zcache_failed_alloc);
+	pr_debug("zcache: put_to_flush=%zd\n", zcache_put_to_flush);
+	pr_debug("zcache: compress_poor=%zd\n", zcache_compress_poor);
+	pr_debug("zcache: mean_compress_poor=%zd\n",
 				zcache_mean_compress_poor);
-	pr_info("zcache: eph_ate_tail=%zd\n", zcache_eph_ate_tail);
-	pr_info("zcache: eph_ate_tail_failed=%zd\n",
+	pr_debug("zcache: eph_ate_tail=%zd\n", zcache_eph_ate_tail);
+	pr_debug("zcache: eph_ate_tail_failed=%zd\n",
 				zcache_eph_ate_tail_failed);
-	pr_info("zcache: pers_ate_eph=%zd\n", zcache_pers_ate_eph);
-	pr_info("zcache: pers_ate_eph_failed=%zd\n",
+	pr_debug("zcache: pers_ate_eph=%zd\n", zcache_pers_ate_eph);
+	pr_debug("zcache: pers_ate_eph_failed=%zd\n",
 				zcache_pers_ate_eph_failed);
-	pr_info("zcache: evicted_eph_zpages=%zd\n", zcache_evicted_eph_zpages);
-	pr_info("zcache: evicted_eph_pageframes=%zd\n",
+	pr_debug("zcache: evicted_eph_zpages=%zd\n", zcache_evicted_eph_zpages);
+	pr_debug("zcache: evicted_eph_pageframes=%zd\n",
 				zcache_evicted_eph_pageframes);
-	pr_info("zcache: eph_pageframes=%zd\n", zcache_eph_pageframes);
-	pr_info("zcache: eph_pageframes_max=%zd\n", zcache_eph_pageframes_max);
-	pr_info("zcache: pers_pageframes=%zd\n", zcache_pers_pageframes);
-	pr_info("zcache: pers_pageframes_max=%zd\n",
+	pr_debug("zcache: eph_pageframes=%zd\n", zcache_eph_pageframes);
+	pr_debug("zcache: eph_pageframes_max=%zd\n", zcache_eph_pageframes_max);
+	pr_debug("zcache: pers_pageframes=%zd\n", zcache_pers_pageframes);
+	pr_debug("zcache: pers_pageframes_max=%zd\n",
 				zcache_pers_pageframes_max);
-	pr_info("zcache: eph_zpages=%zd\n", zcache_eph_zpages);
-	pr_info("zcache: eph_zpages_max=%zd\n", zcache_eph_zpages_max);
-	pr_info("zcache: pers_zpages=%zd\n", zcache_pers_zpages);
-	pr_info("zcache: pers_zpages_max=%zd\n", zcache_pers_zpages_max);
-	pr_info("zcache: last_active_file_pageframes=%zd\n",
+	pr_debug("zcache: eph_zpages=%zd\n", zcache_eph_zpages);
+	pr_debug("zcache: eph_zpages_max=%zd\n", zcache_eph_zpages_max);
+	pr_debug("zcache: pers_zpages=%zd\n", zcache_pers_zpages);
+	pr_debug("zcache: pers_zpages_max=%zd\n", zcache_pers_zpages_max);
+	pr_debug("zcache: last_active_file_pageframes=%zd\n",
 				zcache_last_active_file_pageframes);
-	pr_info("zcache: last_inactive_file_pageframes=%zd\n",
+	pr_debug("zcache: last_inactive_file_pageframes=%zd\n",
 				zcache_last_inactive_file_pageframes);
-	pr_info("zcache: last_active_anon_pageframes=%zd\n",
+	pr_debug("zcache: last_active_anon_pageframes=%zd\n",
 				zcache_last_active_anon_pageframes);
-	pr_info("zcache: last_inactive_anon_pageframes=%zd\n",
+	pr_debug("zcache: last_inactive_anon_pageframes=%zd\n",
 				zcache_last_inactive_anon_pageframes);
-	pr_info("zcache: eph_nonactive_puts_ignored=%zd\n",
+	pr_debug("zcache: eph_nonactive_puts_ignored=%zd\n",
 				zcache_eph_nonactive_puts_ignored);
-	pr_info("zcache: pers_nonactive_puts_ignored=%zd\n",
+	pr_debug("zcache: pers_nonactive_puts_ignored=%zd\n",
 				zcache_pers_nonactive_puts_ignored);
-	pr_info("zcache: eph_zbytes=%llu\n",
+	pr_debug("zcache: eph_zbytes=%llu\n",
 				zcache_eph_zbytes);
-	pr_info("zcache: eph_zbytes_max=%llu\n",
+	pr_debug("zcache: eph_zbytes_max=%llu\n",
 				zcache_eph_zbytes_max);
-	pr_info("zcache: pers_zbytes=%llu\n",
+	pr_debug("zcache: pers_zbytes=%llu\n",
 				zcache_pers_zbytes);
-	pr_info("zcache: pers_zbytes_max=%llu\n",
+	pr_debug("zcache: pers_zbytes_max=%llu\n",
 				zcache_pers_zbytes_max);
-	pr_info("zcache: outstanding_writeback_pages=%zd\n",
+	pr_debug("zcache: outstanding_writeback_pages=%zd\n",
 				zcache_outstanding_writeback_pages);
-	pr_info("zcache: writtenback_pages=%zd\n", zcache_writtenback_pages);
+	pr_debug("zcache: writtenback_pages=%zd\n", zcache_writtenback_pages);
 }
-#endif
 
 /*
  * zcache core code starts here
-- 
1.8.0.2

