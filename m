Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaBKUPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:15:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaBKTGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.12 040/107] nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
Date: Tue, 11 Feb 2014 11:05:06 -0800
Message-Id: <20140211184749.337316706@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7561,7 +7561,7 @@ nfs41_proc_secinfo_no_name(struct nfs_se
 		switch (err) {
 		case 0:
 		case -NFS4ERR_WRONGSEC:
-		case -NFS4ERR_NOTSUPP:
+		case -ENOTSUPP:
 			goto out;
 		default:
 			err = nfs4_handle_exception(server, err, &exception);
@@ -7595,7 +7595,7 @@ nfs41_find_root_sec(struct nfs_server *s
 	 * Fall back on "guess and check" method if
 	 * the server doesn't support SECINFO_NO_NAME
 	 */
-	if (err == -NFS4ERR_WRONGSEC || err == -NFS4ERR_NOTSUPP) {
+	if (err == -NFS4ERR_WRONGSEC || err == -ENOTSUPP) {
 		err = nfs4_find_root_sec(server, fhandle, info);
 		goto out_freepage;
 	}


