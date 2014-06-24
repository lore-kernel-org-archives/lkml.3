Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaFXUiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:38:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbaFXUdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:33:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 29/65] net: cpsw: fix null dereference at probe
Date: Tue, 24 Jun 2014 13:29:49 -0700
Message-Id: <1403641825-12825-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 6954cc1f238199e971ec905c5cc87120806ac981 upstream.

Fix null-pointer dereference at probe when the mdio platform device is
missing (e.g. when it has been disabled in DT).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/ti/cpsw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 3b1be52..06d2e09 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1119,6 +1119,10 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
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
1.9.1

