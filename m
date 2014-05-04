Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaEDQpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:45:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaEDPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.14 080/158] nfsd: set timeparms.to_maxval in setup_callback_client
Date: Sun,  4 May 2014 11:39:49 -0400
Message-Id: <20140504154040.779911006@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 3758cf7e14b753838fe754ede3862af10b35fdac upstream.

...otherwise the logic in the timeout handling doesn't work correctly.

Spotted-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4callback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -637,9 +637,11 @@ static struct rpc_cred *get_backchannel_
 
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


