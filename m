Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3GVQKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:16 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:51344 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3GVQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:09 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, wang di <di.wang@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 04/48] staging/lustre/llite: missing last bit in ll_have_md_lock
Date: Tue, 23 Jul 2013 00:06:25 +0800
Message-Id: <1374509230-3324-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang di <di.wang@intel.com>

Missing the last bit during INODELOCK check in ll_have_md_lock.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3385
Lustre-change: http://review.whamcloud.com/6438
Signed-off-by: wang di <di.wang@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index ed1e3f7..efe66d9 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2448,7 +2448,7 @@ int ll_have_md_lock(struct inode *inode, __u64 *bits,  ldlm_mode_t l_req_mode)
 	       ldlm_lockname[mode]);
 
 	flags = LDLM_FL_BLOCK_GRANTED | LDLM_FL_CBPENDING | LDLM_FL_TEST_LOCK;
-	for (i = 0; i < MDS_INODELOCK_MAXSHIFT && *bits != 0; i++) {
+	for (i = 0; i <= MDS_INODELOCK_MAXSHIFT && *bits != 0; i++) {
 		policy.l_inodebits.bits = *bits & (1 << i);
 		if (policy.l_inodebits.bits == 0)
 			continue;
-- 
1.7.9.5

