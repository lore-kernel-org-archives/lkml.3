Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaBKTIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:08:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaBKTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.4 13/30] nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
Date: Tue, 11 Feb 2014 11:06:13 -0800
Message-Id: <20140211184647.522754270@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6394,7 +6394,7 @@ nfs41_proc_secinfo_no_name(struct nfs_se
 		switch (err) {
 		case 0:
 		case -NFS4ERR_WRONGSEC:
-		case -NFS4ERR_NOTSUPP:
+		case -ENOTSUPP:
 			goto out;
 		default:
 			err = nfs4_handle_exception(server, err, &exception);
@@ -6426,7 +6426,7 @@ nfs41_find_root_sec(struct nfs_server *s
 	 * Fall back on "guess and check" method if
 	 * the server doesn't support SECINFO_NO_NAME
 	 */
-	if (err == -NFS4ERR_WRONGSEC || err == -NFS4ERR_NOTSUPP) {
+	if (err == -NFS4ERR_WRONGSEC || err == -ENOTSUPP) {
 		err = nfs4_find_root_sec(server, fhandle, info);
 		goto out_freepage;
 	}


