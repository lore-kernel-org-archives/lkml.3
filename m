Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965377Ab3BMSJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:09:55 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60111 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965189Ab3BMSCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:48 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:04 -0800
Message-Id: <1360777934-5663-75-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+mGAsi4pkxdw47U+PmT/ejK1h5uXDlMk4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0105]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 75/85] cifs: Pass GLOBAL_ROOT_UID and GLOBAL_ROOT_GID to keyring_alloc
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

keyring_alloc has been updated to take a kuid_t and kgid_t so
pass GLOBAL_ROOT_UID instead of 0 for the uid and GLOBAL_ROOT_GID
instead of 0 for the gid.

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/cifsacl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 2e811f4..aaaf5ce 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -347,7 +347,8 @@ init_cifs_idmap(void)
 	if (!cred)
 		return -ENOMEM;
 
-	keyring = keyring_alloc(".cifs_idmap", 0, 0, cred,
+	keyring = keyring_alloc(".cifs_idmap",
+				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
 				(KEY_POS_ALL & ~KEY_POS_SETATTR) |
 				KEY_USR_VIEW | KEY_USR_READ,
 				KEY_ALLOC_NOT_IN_QUOTA, NULL);
-- 
1.7.5.4

