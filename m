Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975Ab3DHKHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:07:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935788Ab3DHJwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Masatake YAMATO <yamato@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 064/102] genetlink: trigger BUG_ON if a group name is too long
Date: Mon,  8 Apr 2013 10:50:19 +0100
Message-Id: <1365414657-29191-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masatake YAMATO <yamato@redhat.com>

commit f1e79e208076ffe7bad97158275f1c572c04f5c7 upstream.

Trigger BUG_ON if a group name is longer than GENL_NAMSIZ.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netlink/genetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 2cc7c1e..4be473d 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -142,6 +142,7 @@ int genl_register_mc_group(struct genl_family *family,
 	int err = 0;
 
 	BUG_ON(grp->name[0] == '\0');
+	BUG_ON(memchr(grp->name, '\0', GENL_NAMSIZ) == NULL);
 
 	genl_lock();
 
-- 
1.8.1.2

