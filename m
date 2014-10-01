Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaJAL7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:59:06 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42902 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJAL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:59:04 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: Fix build warning for !PM_SLEEP
Date: Wed,  1 Oct 2014 13:59:00 +0200
Message-Id: <1412164740-32452-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The dsa_switch_suspend() and dsa_switch_resume() functions are only used
when PM_SLEEP is enabled, so they need #ifdef CONFIG_PM_SLEEP protection
to avoid a compiler warning.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 net/dsa/dsa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 6905f2d84c44..22f34cf4cb27 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -238,6 +238,7 @@ static void dsa_switch_destroy(struct dsa_switch *ds)
 {
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int dsa_switch_suspend(struct dsa_switch *ds)
 {
 	int i, ret = 0;
@@ -280,6 +281,7 @@ static int dsa_switch_resume(struct dsa_switch *ds)
 
 	return 0;
 }
+#endif
 
 
 /* link polling *************************************************************/
-- 
2.1.0

