Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3KNQrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:47:19 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41809 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3KNQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:42 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, wang di <di.wang@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 19/26] staging/lustre/mdt: return EXDEV for cross-MDT rename
Date: Fri, 15 Nov 2013 00:43:06 +0800
Message-Id: <1384447393-13838-20-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang di <di.wang@intel.com>

If target does not exist, and source directory is remote
directory, it should return -EXDEV.

Add test in test_24x to verify it.

Create local directory for test_214, since cross-MDT rename
is not allowed yet.

Lustre-change: http://review.whamcloud.com/7579
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3894
Signed-off-by: wang di <di.wang@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
[picked only client side of change -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_fid.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index 84a897e..c33db9e 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -289,6 +289,11 @@ static inline int fid_is_quota(const struct lu_fid *fid)
 	       fid_seq(fid) == FID_SEQ_QUOTA_GLB;
 }
 
+static inline int fid_is_name_llog(const struct lu_fid *fid)
+{
+	return fid_seq(fid) == FID_SEQ_LLOG_NAME;
+}
+
 static inline int fid_is_namespace_visible(const struct lu_fid *fid)
 {
 	const __u64 seq = fid_seq(fid);
-- 
1.7.9.5

