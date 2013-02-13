Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275Ab3BMSKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:10:43 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60092 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965185Ab3BMSCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:47 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:54 -0800
Message-Id: <1360777934-5663-65-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+r9uxvgjn1KO0EGIfrR1IqMULlGMyJniI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0813]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 65/85] nfsd: Remove nfsd_luid, nfsd_lgid, nfsd_ruid and nfsd_rgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

These trivial macros that don't currently do anything are the last
vestiages of an old attempt at uid mapping that was removed from the
kernel in September of 2002.  Remove them to make it clear what the
code is currently doing.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfsd/auth.h    |    6 ------
 fs/nfsd/nfs3xdr.c |    4 ++--
 fs/nfsd/nfsxdr.c  |    4 ++--
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/auth.h b/fs/nfsd/auth.h
index 78b3c0e..53325a1 100644
--- a/fs/nfsd/auth.h
+++ b/fs/nfsd/auth.h
@@ -1,6 +1,5 @@
 /*
  * nfsd-specific authentication stuff.
- * uid/gid mapping not yet implemented.
  *
  * Copyright (C) 1995, 1996 Olaf Kirch <okir@monad.swb.de>
  */
@@ -8,11 +7,6 @@
 #ifndef LINUX_NFSD_AUTH_H
 #define LINUX_NFSD_AUTH_H
 
-#define nfsd_luid(rq, uid)	((u32)(uid))
-#define nfsd_lgid(rq, gid)	((u32)(gid))
-#define nfsd_ruid(rq, uid)	((u32)(uid))
-#define nfsd_rgid(rq, gid)	((u32)(gid))
-
 /*
  * Set the current process's fsuid/fsgid etc to those of the NFS
  * client user
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 324c0ba..1884a3f 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -167,8 +167,8 @@ encode_fattr3(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	*p++ = htonl(nfs3_ftypes[(stat->mode & S_IFMT) >> 12]);
 	*p++ = htonl((u32) stat->mode);
 	*p++ = htonl((u32) stat->nlink);
-	*p++ = htonl((u32) nfsd_ruid(rqstp, stat->uid));
-	*p++ = htonl((u32) nfsd_rgid(rqstp, stat->gid));
+	*p++ = htonl((u32) stat->uid);
+	*p++ = htonl((u32) stat->gid);
 	if (S_ISLNK(stat->mode) && stat->size > NFS3_MAXPATHLEN) {
 		p = xdr_encode_hyper(p, (u64) NFS3_MAXPATHLEN);
 	} else {
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 979b421..1e51e70 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -151,8 +151,8 @@ encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	*p++ = htonl(nfs_ftypes[type >> 12]);
 	*p++ = htonl((u32) stat->mode);
 	*p++ = htonl((u32) stat->nlink);
-	*p++ = htonl((u32) nfsd_ruid(rqstp, stat->uid));
-	*p++ = htonl((u32) nfsd_rgid(rqstp, stat->gid));
+	*p++ = htonl((u32) stat->uid);
+	*p++ = htonl((u32) stat->gid);
 
 	if (S_ISLNK(type) && stat->size > NFS_MAXPATHLEN) {
 		*p++ = htonl(NFS_MAXPATHLEN);
-- 
1.7.5.4

