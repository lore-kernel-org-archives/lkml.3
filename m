Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965450Ab3BMSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:16:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49133 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab3BMR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:53 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 13 Feb 2013 09:51:25 -0800
Message-Id: <1360777934-5663-36-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18h0eaV5scnmhwdR/8LwBt3AMpUtRnB4qo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 36/85] gfs2: Use kuid_t and kgid_t types where appropriate.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/gfs2/inode.c |    3 ++-
 fs/gfs2/quota.c |    8 ++++----
 fs/gfs2/quota.h |    8 ++++----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index aa10502..ce07ce4 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1580,7 +1580,8 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	u32 ouid, ogid, nuid, ngid;
+	kuid_t ouid, nuid;
+	kgid_t ogid, ngid;
 	int error;
 
 	ouid = inode->i_uid;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 0bbb040..87f2740 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -492,7 +492,7 @@ static void qdsb_put(struct gfs2_quota_data *qd)
 	qd_put(qd);
 }
 
-int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
+int gfs2_quota_hold(struct gfs2_inode *ip, kuid_t uid, kgid_t gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_quota_data **qd;
@@ -918,7 +918,7 @@ fail:
 	return error;
 }
 
-int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid)
+int gfs2_quota_lock(struct gfs2_inode *ip, kuid_t uid, kgid_t gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_quota_data *qd;
@@ -1039,7 +1039,7 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 	return 0;
 }
 
-int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
+int gfs2_quota_check(struct gfs2_inode *ip, kuid_t uid, kgid_t gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_quota_data *qd;
@@ -1088,7 +1088,7 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 }
 
 void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
-		       u32 uid, u32 gid)
+		       kuid_t uid, kgid_t gid)
 {
 	struct gfs2_quota_data *qd;
 	unsigned int x;
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index bef805d..4f5e6e4 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -17,15 +17,15 @@ struct shrink_control;
 #define NO_UID_QUOTA_CHANGE INVALID_UID
 #define NO_GID_QUOTA_CHANGE INVALID_GID
 
-extern int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid);
+extern int gfs2_quota_hold(struct gfs2_inode *ip, kuid_t uid, kgid_t gid);
 extern void gfs2_quota_unhold(struct gfs2_inode *ip);
 
-extern int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid);
+extern int gfs2_quota_lock(struct gfs2_inode *ip, kuid_t uid, kgid_t gid);
 extern void gfs2_quota_unlock(struct gfs2_inode *ip);
 
-extern int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid);
+extern int gfs2_quota_check(struct gfs2_inode *ip, kuid_t uid, kgid_t gid);
 extern void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
-			      u32 uid, u32 gid);
+			      kuid_t uid, kgid_t gid);
 
 extern int gfs2_quota_sync(struct super_block *sb, int type);
 extern int gfs2_quota_refresh(struct gfs2_sbd *sdp, struct kqid qid);
-- 
1.7.5.4

