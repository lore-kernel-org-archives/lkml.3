Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162389Ab3LFNNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:13:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162065Ab3LFNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 243/272] nfsd4: fix discarded security labels on setattr
Date: Fri,  6 Dec 2013 12:58:52 +0000
Message-Id: <1386334761-25517-244-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 3378b7f40d79930f0f447a164c7e8fcbe4480e40 upstream.

Security labels in setattr calls are currently ignored because we forget
to set label->len.

Reported-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b6dbc8d..c6c727a13 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -411,6 +411,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		label->data = kzalloc(dummy32 + 1, GFP_KERNEL);
 		if (!label->data)
 			return nfserr_jukebox;
+		label->len = dummy32;
 		defer_free(argp, kfree, label->data);
 		memcpy(label->data, buf, dummy32);
 	}
-- 
1.8.3.2

