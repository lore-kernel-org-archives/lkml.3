Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbaI2SPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:15:54 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35768 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaI2SPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:15:52 -0400
From: Thibaut Robert <thibaut.robert@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michalis Pappas <mpappas@fastmail.fm>,
        Davide Gianforte <davide@gengisdave.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Thibaut Robert <thibaut.robert@gmail.com>
Subject: [PATCH] Staging: gdm72xx: fix coding style
Date: Mon, 29 Sep 2014 20:15:35 +0200
Message-Id: <1412014535-24239-1-git-send-email-thibaut.robert@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove a checkstyle warning in netlink_k.c.
Note: This is my homework of the day.

Signed-off-by: Thibaut Robert <thibaut.robert@gmail.com>
---
 drivers/staging/gdm72xx/netlink_k.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 9bf00e6..0a5831a 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -147,12 +147,11 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 
 	if (!ret) {
 		return len;
-	} else {
-		if (ret != -ESRCH) {
-			pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
-			       group, type, len, ret);
-		}
-		ret = 0;
 	}
-	return ret;
+
+	if (ret != -ESRCH) {
+		pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
+		       group, type, len, ret);
+	}
+	return 0;
 }
-- 
1.9.1

