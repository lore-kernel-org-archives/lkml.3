Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330Ab3BMSSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:18:21 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56617 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964974Ab3BMR5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>
Date: Wed, 13 Feb 2013 09:51:03 -0800
Message-Id: <1360777934-5663-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/CckYdpW9HhiiwqIfBOJ8kE0v6HlPx4S0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 14/85] afs: Remove unused structure afs_store_status
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

While looking for kuid_t and kgid_t conversions I found this
structure that has never been used since it was added to the
kernel in 2007.  The obvious for this structure to be used
is in xdr_encode_AFS_StoreStatus and that function uses a
small handful of local variables instead.

So remove the unnecessary structure to prevent confusion.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/afs/afs.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/afs/afs.h b/fs/afs/afs.h
index c548aa3..3d8fd35 100644
--- a/fs/afs/afs.h
+++ b/fs/afs/afs.h
@@ -133,13 +133,6 @@ struct afs_file_status {
 /*
  * AFS file status change request
  */
-struct afs_store_status {
-	u32			mask;		/* which bits of the struct are set */
-	u32			mtime_client;	/* last time client changed data */
-	u32			owner;		/* owner ID */
-	u32			group;		/* group ID */
-	umode_t			mode;		/* UNIX mode */
-};
 
 #define AFS_SET_MTIME		0x01		/* set the mtime */
 #define AFS_SET_OWNER		0x02		/* set the owner ID */
-- 
1.7.5.4

