Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaD0RIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:20 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48062 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbaD0RIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:15 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 27/47] staging/lustre: shrink lu_object_header by 8 bytes on x86_64
Date: Sun, 27 Apr 2014 13:06:51 -0400
Message-Id: <1398618431-29757-28-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

Locate the loh_flags and loh_ref fields together in lu_object_header
to avoid holes and shrink the structure by 8 bytes.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-on: http://review.whamcloud.com/9185
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3059
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lu_object.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lu_object.h b/drivers/staging/lustre/lustre/include/lu_object.h
index 6773bca..98149f5 100644
--- a/drivers/staging/lustre/lustre/include/lu_object.h
+++ b/drivers/staging/lustre/lustre/include/lu_object.h
@@ -516,6 +516,10 @@ enum lu_object_header_attr {
  */
 struct lu_object_header {
 	/**
+	 * Fid, uniquely identifying this object.
+	 */
+	struct lu_fid		loh_fid;
+	/**
 	 * Object flags from enum lu_object_header_flags. Set and checked
 	 * atomically.
 	 */
@@ -525,10 +529,6 @@ struct lu_object_header {
 	 */
 	atomic_t	   loh_ref;
 	/**
-	 * Fid, uniquely identifying this object.
-	 */
-	struct lu_fid	  loh_fid;
-	/**
 	 * Common object attributes, cached for efficiency. From enum
 	 * lu_object_header_attr.
 	 */
-- 
1.8.5.3

