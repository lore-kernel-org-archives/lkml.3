Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab3BMSC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:02:26 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56740 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031Ab3BMR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:58 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
Date: Wed, 13 Feb 2013 09:51:01 -0800
Message-Id: <1360777934-5663-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+jOX5L6eP3tZJdVDYCGzKom7xK8sutnqA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 12/85] 9p: Modify v9fs_get_fsgid_for_create to return a kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Modify v9fs_get_fsgid_for_create to return a kgid and modify all of
the variables that hold the result of v9fs_get_fsgid_for_create to be
of type kgid_t.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/9p/vfs_inode_dotl.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 4089554..e278865 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -57,7 +57,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
  * group of the new file system object.
  */
 
-static gid_t v9fs_get_fsgid_for_create(struct inode *dir_inode)
+static kgid_t v9fs_get_fsgid_for_create(struct inode *dir_inode)
 {
 	BUG_ON(dir_inode == NULL);
 
@@ -246,7 +246,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 			  int *opened)
 {
 	int err = 0;
-	gid_t gid;
+	kgid_t gid;
 	umode_t mode;
 	char *name = NULL;
 	struct p9_qid qid;
@@ -391,7 +391,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 	int err;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL, *dfid = NULL;
-	gid_t gid;
+	kgid_t gid;
 	char *name;
 	umode_t mode;
 	struct inode *inode;
@@ -692,7 +692,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 		const char *symname)
 {
 	int err;
-	gid_t gid;
+	kgid_t gid;
 	char *name;
 	struct p9_qid qid;
 	struct inode *inode;
@@ -832,7 +832,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
 		dev_t rdev)
 {
 	int err;
-	gid_t gid;
+	kgid_t gid;
 	char *name;
 	umode_t mode;
 	struct v9fs_session_info *v9ses;
-- 
1.7.5.4

