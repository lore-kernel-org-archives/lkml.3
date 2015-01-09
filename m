Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbbAIMGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:06:14 -0500
Received: from nautica.notk.org ([91.121.71.147]:37651 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbbAIMGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:06:14 -0500
From: Dominique Martinet <dominique.martinet@cea.fr>
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>
Subject: [PATCH] net/9p: Initialize opts->privport as it should be.
Date: Fri,  9 Jan 2015 13:05:56 +0100
Message-Id: <1420805156-16555-1-git-send-email-dominique.martinet@cea.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're currently using an uninitialized value if option privport is not set,
thus (almost) always using a privileged port.

Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
---
 net/9p/trans_fd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 80d08f6..748703e 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -734,6 +734,7 @@ static int parse_opts(char *params, struct p9_fd_opts *opts)
 	opts->port = P9_PORT;
 	opts->rfd = ~0;
 	opts->wfd = ~0;
+	opts->privport = 0;
 
 	if (!params)
 		return 0;
-- 
1.9.3

