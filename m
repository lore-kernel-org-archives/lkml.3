Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbaEMJ76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:59:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60824 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760076AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 065/182] nfsd: set timeparms.to_maxval in setup_callback_client
Date: Tue, 13 May 2014 11:26:57 +0200
Message-Id: <9b12a32cbfd14560d3e54674ce82f9fe05e292fb.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3758cf7e14b753838fe754ede3862af10b35fdac upstream.

...otherwise the logic in the timeout handling doesn't work correctly.

Spotted-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4callback.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 7f05cd140de3..3eaa6e30a2dc 100644
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
1.9.3

