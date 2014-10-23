Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaJWQTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:19:43 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:49675 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbaJWQTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:19:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqASAI0pSVRbtA79/2dsb2JhbABcgw66QwUBdJo4BAKBExcBfYQwLyOBGjeIRQG6FI5NLIYlijMdhDUFj2eNdoxoiUWBRwGCMjsvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] 9P: remove unused variable in p9_fd_create()
Date: Thu, 23 Oct 2014 18:19:35 +0200
Message-Id: <1414081175-6244-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p is initialized but unused.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/9p/trans_fd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 80d08f6..c73b894 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1013,7 +1013,6 @@ p9_fd_create(struct p9_client *client, const char *addr, char *args)
 {
 	int err;
 	struct p9_fd_opts opts;
-	struct p9_trans_fd *p;
 
 	parse_opts(args, &opts);
 
@@ -1026,7 +1025,6 @@ p9_fd_create(struct p9_client *client, const char *addr, char *args)
 	if (err < 0)
 		return err;
 
-	p = (struct p9_trans_fd *) client->trans;
 	p9_conn_create(client);
 
 	return 0;
-- 
1.9.3

