Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3KNQRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:17:55 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38246 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3KNQQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:16:39 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mikhail Pershin <mike.pershin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 34/40] staging/lustre/seq: unified SEQ handler
Date: Fri, 15 Nov 2013 00:13:36 +0800
Message-Id: <1384445622-12346-35-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Pershin <mike.pershin@intel.com>

move SEQ handler from MDT to the FID module so it can
be used from any target.

Lustre-change: http://review.whamcloud.com/6765
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3467
Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: wangdi <di.wang@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_fid.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index ff11953..84a897e 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -431,12 +431,6 @@ struct lu_server_seq {
 	struct seq_server_site  *lss_site;
 };
 
-struct com_thread_info;
-int seq_query(struct com_thread_info *info);
-
-struct ptlrpc_request;
-int seq_handle(struct ptlrpc_request *req);
-
 /* Server methods */
 
 int seq_server_init(struct lu_server_seq *seq,
-- 
1.7.9.5

