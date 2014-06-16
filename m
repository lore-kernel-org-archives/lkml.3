Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaFPE3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:29:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41526 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaFPE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:29:27 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v3 7/7] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Mon, 16 Jun 2014 14:28:36 +1000
Message-Id: <1402892916-5298-7-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402892916-5298-1-git-send-email-askb23@gmail.com>
References: <1402892916-5298-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed: WARNING: line over 80 characters and indent after the conditional
statement

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index c180a20..8fed70c 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -825,6 +825,7 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
 	loff_t	  pos   = start + count - 1;
 	loff_t kms;
 	int result;
+	unsigned long cur_index;
 
 	/*
 	 * Consistency guarantees: following possibilities exist for the
@@ -864,11 +865,13 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
 				 * linux-2.6.18-128.1.1 miss to do that.
 				 * --bug 17336 */
 				loff_t size = cl_isize_read(inode);
-				unsigned long cur_index = start >> PAGE_CACHE_SHIFT;
+
+				cur_index = start >> PAGE_CACHE_SHIFT;
+				loff_t check = ((size - 1) >> PAGE_CACHE_SHIFT);
 
 				if ((size == 0 && cur_index != 0) ||
-				    (((size - 1) >> PAGE_CACHE_SHIFT) < cur_index))
-				*exceed = 1;
+				    (check < cur_index))
+					*exceed = 1;
 			}
 			return result;
 		} else {
-- 
1.9.0

