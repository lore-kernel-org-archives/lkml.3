Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab3KNQxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:53:06 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39573 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab3KNQkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:19 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "Christopher J. Morrone" <morrone2@llnl.gov>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 29/39] staging/lustre/changelogs: Account for changelog_ext_rec in CR_MAXSIZE
Date: Fri, 15 Nov 2013 00:32:52 +0800
Message-Id: <1384446782-13741-30-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Christopher J. Morrone" <morrone2@llnl.gov>

CR_MAXSIZE needs to account for an llog_changelog_rec that actually
contains a changelog_ext_rec structure rather than a changelog_rec.
With out doing so, a file size approaching the Linux kernel NAME_MAX
length that is renamed to a size also close to, or at, NAME_MAX will
exceed CR_MAXSIZE and trip an assertion.

Lustre-change: http://review.whamcloud.com/6993
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3587
Signed-off-by: Christopher J. Morrone <morrone2@llnl.gov>
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 0ad524a..ffb56d7 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -766,7 +766,8 @@ static inline void hsm_set_cl_error(int *flags, int error)
 	*flags |= (error << CLF_HSM_ERR_L);
 }
 
-#define CR_MAXSIZE cfs_size_round(2*NAME_MAX + 1 + sizeof(struct changelog_rec))
+#define CR_MAXSIZE cfs_size_round(2*NAME_MAX + 1 + \
+				  sizeof(struct changelog_ext_rec))
 
 struct changelog_rec {
 	__u16		 cr_namelen;
-- 
1.7.9.5

