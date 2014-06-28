Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaF1Szx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:55:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaF1RtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 004/110] net: cpsw: fix null dereference at probe
Date: Sat, 28 Jun 2014 10:46:01 -0700
Message-Id: <20140628174545.590416446@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 6954cc1f238199e971ec905c5cc87120806ac981 upstream.

Fix null-pointer dereference at probe when the mdio platform device is
missing (e.g. when it has been disabled in DT).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/cpsw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1884,6 +1884,10 @@ static int cpsw_probe_dt(struct cpsw_pla
 		mdio_node = of_find_node_by_phandle(be32_to_cpup(parp));
 		phyid = be32_to_cpup(parp+1);
 		mdio = of_find_device_by_node(mdio_node);
+		if (!mdio) {
+			pr_err("Missing mdio platform device\n");
+			return -EINVAL;
+		}
 		snprintf(slave_data->phy_id, sizeof(slave_data->phy_id),
 			 PHY_ID_FMT, mdio->name, phyid);
 


