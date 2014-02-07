Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaBGLud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:50:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41957 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaBGLua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 120/233] nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
Date: Fri,  7 Feb 2014 11:45:39 +0000
Message-Id: <1391773652-25214-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@primarydata.com>

commit 78b19bae0813bd6f921ca58490196abd101297bd upstream.

Don't check for -NFS4ERR_NOTSUPP, it's already been mapped to -ENOTSUPP
by nfs4_stat_to_errno.

This allows the client to mount v4.1 servers that don't support
SECINFO_NO_NAME by falling back to the "guess and check" method of
nfs4_find_root_sec.

Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a1e1f2f..bdaa5a1 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7109,7 +7109,7 @@ nfs41_proc_secinfo_no_name(struct nfs_server *server, struct nfs_fh *fhandle,
 		switch (err) {
 		case 0:
 		case -NFS4ERR_WRONGSEC:
-		case -NFS4ERR_NOTSUPP:
+		case -ENOTSUPP:
 			goto out;
 		default:
 			err = nfs4_handle_exception(server, err, &exception);
@@ -7141,7 +7141,7 @@ nfs41_find_root_sec(struct nfs_server *server, struct nfs_fh *fhandle,
 	 * Fall back on "guess and check" method if
 	 * the server doesn't support SECINFO_NO_NAME
 	 */
-	if (err == -NFS4ERR_WRONGSEC || err == -NFS4ERR_NOTSUPP) {
+	if (err == -NFS4ERR_WRONGSEC || err == -ENOTSUPP) {
 		err = nfs4_find_root_sec(server, fhandle, info);
 		goto out_freepage;
 	}
-- 
1.8.3.2

