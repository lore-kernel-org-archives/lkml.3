Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426Ab3BMSR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:17:57 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56628 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964979Ab3BMR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:53 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Date: Wed, 13 Feb 2013 09:51:13 -0800
Message-Id: <1360777934-5663-24-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18gv4KrsUWdlDOBeuNwAqbHLBYmw3klpGA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 
X-Spam-Combo: ******;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 24/85] ocfs2: For tracing report the uid and gid values in the initial user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ocfs2/file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 37d313e..8ee9332 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1116,7 +1116,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    dentry->d_name.len, dentry->d_name.name,
 			    attr->ia_valid, attr->ia_mode,
-			    attr->ia_uid, attr->ia_gid);
+			    from_kuid(&init_user_ns, attr->ia_uid),
+			    from_kgid(&init_user_ns, attr->ia_gid));
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
-- 
1.7.5.4

