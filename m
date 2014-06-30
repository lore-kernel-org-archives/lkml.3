Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaF3RvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:51:06 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:57333 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256AbaF3RvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:51:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgJAGiisVNbtAo1/2dsb2JhbABagw2sQQUBAQEBAQEFAW4BmUaBERd1hDEvI4EaN4hGAcgpF4VkiSMdhC0Fml6LP4g+g0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        linux-nfs@vger.kernel.org
Subject: [PATCH 1/1] NFS: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Mon, 30 Jun 2014 19:49:39 +0200
Message-Id: <1404150579-8092-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macro definition

Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: linux-nfs@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/nfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 084af10..c08e837 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1027,8 +1027,7 @@ static bool nfs_auth_info_add(struct nfs_auth_info *auth_info,
 			      rpc_authflavor_t flavor)
 {
 	unsigned int i;
-	unsigned int max_flavor_len = (sizeof(auth_info->flavors) /
-				       sizeof(auth_info->flavors[0]));
+	unsigned int max_flavor_len = ARRAY_SIZE(auth_info->flavors);
 
 	/* make sure this flavor isn't already in the list */
 	for (i = 0; i < auth_info->flavor_len; i++) {
-- 
1.8.4.5

