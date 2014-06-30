Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaF3LzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:55:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52066 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/181] net: cpsw: fix null dereference at probe
Date: Mon, 30 Jun 2014 13:51:58 +0200
Message-Id: <afe18b3ba90dbc307d603ce88848ca23f098af0f.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6954cc1f238199e971ec905c5cc87120806ac981 upstream.

Fix null-pointer dereference at probe when the mdio platform device is
missing (e.g. when it has been disabled in DT).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/ti/cpsw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index cc3ce557e4aa..498e808391a9 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1797,6 +1797,10 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 		mdio_node = of_find_node_by_phandle(be32_to_cpup(parp));
 		phyid = be32_to_cpup(parp+1);
 		mdio = of_find_device_by_node(mdio_node);
+		if (!mdio) {
+			pr_err("Missing mdio platform device\n");
+			return -EINVAL;
+		}
 		snprintf(slave_data->phy_id, sizeof(slave_data->phy_id),
 			 PHY_ID_FMT, mdio->name, phyid);
 
-- 
2.0.0

