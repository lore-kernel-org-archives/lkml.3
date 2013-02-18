Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab3BRBMD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:12:03 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40299 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab3BRBL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:11:59 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, Dave Chinner <david@fromorbit.com>
Date: Sun, 17 Feb 2013 17:11:02 -0800
Message-Id: <1361149870-27732-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1897dTLYfQ+HiAZA3R/j8EWCWbZrmnhTl4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 09/16] xfs: Modify xfs_qm_vop_dqalloc to take kuids, kgids, and kprojids.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_qm.c    |    6 +++---
 fs/xfs/xfs_quota.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6fce3d3..80b8c81 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1617,9 +1617,9 @@ xfs_qm_write_sb_changes(
 int
 xfs_qm_vop_dqalloc(
 	struct xfs_inode	*ip,
-	uid_t			uid,
-	gid_t			gid,
-	prid_t			prid,
+	kuid_t			uid,
+	kgid_t			gid,
+	kprojid_t		prid,
 	uint			flags,
 	struct xfs_dquot	**O_udqpp,
 	struct xfs_dquot	**O_gdqpp)
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index b50ec5b..f48f801 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -311,7 +311,7 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, long, long, uint);
 
-extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
+extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t, kprojid_t, uint,
 		struct xfs_dquot **, struct xfs_dquot **);
 extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
 		struct xfs_dquot *, struct xfs_dquot *);
@@ -332,7 +332,7 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
 #else
 static inline int
-xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid, prid_t prid,
+xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t uid, kgid_t gid, kprojid_t prid,
 		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp)
 {
 	*udqp = NULL;
-- 
1.7.5.4

