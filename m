Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab3BMR6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:58:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59259 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917Ab3BMR5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:50 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:17 -0800
Message-Id: <1360777934-5663-28-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+EDywnkaecdvX9Nou+wgOQxxSE+juggvE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0873]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 28/85] gfs2: Split NO_QUOTA_CHANGE inot NO_UID_QUTOA_CHANGE and NO_GID_QUTOA_CHANGE
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Split NO_QUOTA_CHANGE into NO_UID_QUTOA_CHANGE and NO_GID_QUTOA_CHANGE
so the constants may be well typed.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/bmap.c  |    2 +-
 fs/gfs2/dir.c   |    2 +-
 fs/gfs2/inode.c |   10 +++++-----
 fs/gfs2/quota.c |    4 ++--
 fs/gfs2/quota.h |    5 +++--
 fs/gfs2/super.c |    2 +-
 fs/gfs2/xattr.c |    4 ++--
 7 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index a68e91b..10c54e3 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1098,7 +1098,7 @@ static int trunc_dealloc(struct gfs2_inode *ip, u64 size)
 	if (error)
 		return error;
 
-	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	error = gfs2_quota_hold(ip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (error)
 		return error;
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 9a35670..6d3e3e2 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1849,7 +1849,7 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	if (!ht)
 		return -ENOMEM;
 
-	error = gfs2_quota_hold(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	error = gfs2_quota_hold(dip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (error)
 		goto out;
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 2b6f569..aa10502 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -548,7 +548,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 	if (error)
 		return error;
 
-	error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	error = gfs2_quota_lock(dip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (error)
 		goto fail;
 
@@ -1589,15 +1589,15 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	ngid = attr->ia_gid;
 
 	if (!(attr->ia_valid & ATTR_UID) || ouid == nuid)
-		ouid = nuid = NO_QUOTA_CHANGE;
+		ouid = nuid = NO_UID_QUOTA_CHANGE;
 	if (!(attr->ia_valid & ATTR_GID) || ogid == ngid)
-		ogid = ngid = NO_QUOTA_CHANGE;
+		ogid = ngid = NO_GID_QUOTA_CHANGE;
 
 	error = gfs2_quota_lock(ip, nuid, ngid);
 	if (error)
 		return error;
 
-	if (ouid != NO_QUOTA_CHANGE || ogid != NO_QUOTA_CHANGE) {
+	if (ouid != NO_UID_QUOTA_CHANGE || ogid != NO_GID_QUOTA_CHANGE) {
 		error = gfs2_quota_check(ip, nuid, ngid);
 		if (error)
 			goto out_gunlock_q;
@@ -1611,7 +1611,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	if (error)
 		goto out_end_trans;
 
-	if (ouid != NO_QUOTA_CHANGE || ogid != NO_QUOTA_CHANGE) {
+	if (ouid != NO_UID_QUOTA_CHANGE || ogid != NO_GID_QUOTA_CHANGE) {
 		u64 blocks = gfs2_get_inode_blocks(&ip->i_inode);
 		gfs2_quota_change(ip, -blocks, ouid, ogid);
 		gfs2_quota_change(ip, blocks, nuid, ngid);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index e4f6ccf..dbfacaa 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -524,7 +524,7 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 	ip->i_res->rs_qa_qd_num++;
 	qd++;
 
-	if (uid != NO_QUOTA_CHANGE && uid != ip->i_inode.i_uid) {
+	if (uid != NO_UID_QUOTA_CHANGE && uid != ip->i_inode.i_uid) {
 		error = qdsb_get(sdp, QUOTA_USER, uid, qd);
 		if (error)
 			goto out;
@@ -532,7 +532,7 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 		qd++;
 	}
 
-	if (gid != NO_QUOTA_CHANGE && gid != ip->i_inode.i_gid) {
+	if (gid != NO_GID_QUOTA_CHANGE && gid != ip->i_inode.i_gid) {
 		error = qdsb_get(sdp, QUOTA_GROUP, gid, qd);
 		if (error)
 			goto out;
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index f25d98b..7f67323 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -14,7 +14,8 @@ struct gfs2_inode;
 struct gfs2_sbd;
 struct shrink_control;
 
-#define NO_QUOTA_CHANGE ((u32)-1)
+#define NO_UID_QUOTA_CHANGE INVALID_UID
+#define NO_GID_QUOTA_CHANGE INVALID_GID
 
 extern int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid);
 extern void gfs2_quota_unhold(struct gfs2_inode *ip);
@@ -41,7 +42,7 @@ static inline int gfs2_quota_lock_check(struct gfs2_inode *ip)
 	int ret;
 	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
 		return 0;
-	ret = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	ret = gfs2_quota_lock(ip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (ret)
 		return ret;
 	if (sdp->sd_args.ar_quota != GFS2_QUOTA_ON)
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d648867..7cc5a60 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1429,7 +1429,7 @@ static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	if (error)
 		return error;
 
-	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	error = gfs2_quota_hold(ip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (error)
 		return error;
 
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 76c144b..80c25ae 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -331,7 +331,7 @@ static int ea_remove_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 	if (error)
 		return error;
 
-	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	error = gfs2_quota_hold(ip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (error)
 		goto out_alloc;
 
@@ -1461,7 +1461,7 @@ int gfs2_ea_dealloc(struct gfs2_inode *ip)
 	if (error)
 		return error;
 
-	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	error = gfs2_quota_hold(ip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
 	if (error)
 		return error;
 
-- 
1.7.5.4

