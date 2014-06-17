Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaFQFs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:48:58 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42796 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaFQFse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:48:34 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v6 7/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Tue, 17 Jun 2014 15:43:58 +1000
Message-Id: <1402983839-3549-8-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402983839-3549-1-git-send-email-askb23@gmail.com>
References: <1402983839-3549-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed: WARNING: line over 80 characters, used a new variable 'size_index' to
store the offset. Replaceed "unsigned long" with  "loff_t" type for
'cur_index'

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 2f51b76..e2da397 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -821,10 +821,11 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
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

