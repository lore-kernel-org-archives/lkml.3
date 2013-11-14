Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3KNPHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:07:40 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:43420 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880Ab3KNPHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:07:32 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
To: <devicetree@vger.kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@st.com>
Subject: [PATCH RFC] net: of_mdio: Scan PHYs which have device_type set to ethernet-phy
Date: Thu, 14 Nov 2013 15:05:56 +0000
Message-ID: <1384441556-20674-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/devicetree/bindings/net/phy.txt device_type
property of PHY nodes is mandatory, which should be set to
"ethernet-phy". This patch adds check in scanning phys and only scans
node which have device-type set to "ethernet-phy".

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/of/of_mdio.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index d5a57a9..78c53c7 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -57,6 +57,9 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 
 	/* Loop over the child nodes and register a phy_device for each one */
 	for_each_available_child_of_node(np, child) {
+		/* A PHY must have device_type set to "ethernet-phy" */
+		if (of_node_cmp(child->type, "ethernet-phy"))
+			continue;
 		/* A PHY must have a reg property in the range [0-31] */
 		paddr = of_get_property(child, "reg", &len);
 		if (!paddr || len < sizeof(*paddr)) {
@@ -112,6 +115,10 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 
 	/* auto scan for PHYs with empty reg property */
 	for_each_available_child_of_node(np, child) {
+		/* A PHY must have device_type set to "ethernet-phy" */
+		if (of_node_cmp(child->type, "ethernet-phy"))
+			continue;
+
 		/* Skip PHYs with reg property set */
 		paddr = of_get_property(child, "reg", &len);
 		if (paddr)
-- 
1.7.6.5

