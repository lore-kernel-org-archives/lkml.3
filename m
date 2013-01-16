Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab3APQEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:04:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab3APQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 113/222] SUNRPC: continue run over clients list on PipeFS event instead of break
Date: Wed, 16 Jan 2013 13:55:13 -0200
Message-Id: <1358351822-7675-114-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit cd6c5968582a273561464fe6b1e8cc8214be02df upstream.

There are SUNRPC clients, which program doesn't have pipe_dir_name. These
clients can be skipped on PipeFS events, because nothing have to be created or
destroyed. But instead of breaking in case of such a client was found, search
for suitable client over clients list have to be continued. Otherwise some
clients could not be covered by PipeFS event handler.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index aaf70aa..631a75d 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -234,7 +234,7 @@ static struct rpc_clnt *rpc_get_client_for_event(struct net *net, int event)
 	spin_lock(&sn->rpc_client_lock);
 	list_for_each_entry(clnt, &sn->all_clients, cl_clients) {
 		if (clnt->cl_program->pipe_dir_name == NULL)
-			break;
+			continue;
 		if (rpc_clnt_skip_event(clnt, event))
 			continue;
 		if (atomic_inc_not_zero(&clnt->cl_count) == 0)
-- 
1.7.9.5

