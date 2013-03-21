Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3CUMUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:20:23 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:60420 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3CUMUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:20:22 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Mar 2013 08:20:22 EDT
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Richard Cochran <richardcochran@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mugunthan V N <mugunthanvnm@ti.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [BUGFIX PATCH] net: ethernet: cpsw: fix erroneous condition in error check
Date: Thu, 21 Mar 2013 13:20:11 +0100
Message-Id: <1363868411-25318-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error check in cpsw_probe_dt() has an '&&' where an '||' is
meant to be. This causes a NULL pointer dereference when incomplet DT
data is passed to the driver ('phy_id' property for cpsw_emac1
missing).


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/ti/cpsw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 5ceaa4c3..7aebc0c 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1504,7 +1504,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 		struct platform_device *mdio;
 
 		parp = of_get_property(slave_node, "phy_id", &lenp);
-		if ((parp == NULL) && (lenp != (sizeof(void *) * 2))) {
+		if ((parp == NULL) || (lenp != (sizeof(void *) * 2))) {
 			pr_err("Missing slave[%d] phy_id property\n", i);
 			ret = -EINVAL;
 			goto error_ret;
-- 
1.7.2.5

