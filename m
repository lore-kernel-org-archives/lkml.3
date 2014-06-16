Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaFPQXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:23:32 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51151 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbaFPQX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:23:29 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com, tao.peng@emc.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v5 7/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Tue, 17 Jun 2014 02:22:21 +1000
Message-Id: <1402935742-18788-8-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402935742-18788-1-git-send-email-askb23@gmail.com>
References: <1402935742-18788-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed: WARNING: line over 80 characters, used a new variable 'size_index' to
store the offset. Replace "unsigned long" with  "u64" type for
'cur_index'

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index c180a20..6c5b828 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -864,10 +864,11 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
 				 * linux-2.6.18-128.1.1 miss to do that.
 				 * --bug 17336 */
 				loff_t size = cl_isize_read(inode);
-				unsigned long cur_index = start >> PAGE_CACHE_SHIFT;
+				loff_t cur_index = start >> PAGE_CACHE_SHIFT;
+				loff_t size_index = ((size - 1) >> PAGE_CACHE_SHIFT);
 
 				if ((size == 0 && cur_index != 0) ||
-				    (((size - 1) >> PAGE_CACHE_SHIFT) < cur_index))
+				    (size_index < cur_index))
 				*exceed = 1;
 			}
 			return result;
-- 
1.9.0

