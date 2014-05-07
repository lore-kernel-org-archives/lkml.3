Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbaEGNdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:33:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbaEGNOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 14/70] nfsd: set timeparms.to_maxval in setup_callback_client
Date: Wed,  7 May 2014 14:12:17 +0100
Message-Id: <1399468393-10140-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 3758cf7e14b753838fe754ede3862af10b35fdac upstream.

...otherwise the logic in the timeout handling doesn't work correctly.

Spotted-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4callback.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 7f05cd1..3eaa6e3 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -637,9 +637,11 @@ static struct rpc_cred *get_backchannel_cred(struct nfs4_client *clp, struct rpc
 
 static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *conn, struct nfsd4_session *ses)
 {
+	int maxtime = max_cb_time(clp->net);
 	struct rpc_timeout	timeparms = {
-		.to_initval	= max_cb_time(clp->net),
+		.to_initval	= maxtime,
 		.to_retries	= 0,
+		.to_maxval	= maxtime,
 	};
 	struct rpc_create_args args = {
 		.net		= clp->net,
-- 
1.9.1

