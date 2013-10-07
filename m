Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3JGGzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:55:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3JGGzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:55:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nick Bowler <nbowler@elliptictech.com>, <netdev@vger.kernel.org>
Subject: [PATCH 02/11] mdio_bus: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:41 -0700
Message-Id: <1381128950-28125-3-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the MDIO bus code to use the
correct field.

Cc: David S. Miller <davem@davemloft.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: <netdev@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

David, I can take this through my driver-core tree if you like, just let
me know what would be the easiest for you.

 drivers/net/phy/mdio_bus.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index dc92097..5617876 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -438,17 +438,19 @@ phy_id_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 	return sprintf(buf, "0x%.8lx\n", (unsigned long)phydev->phy_id);
 }
+static DEVICE_ATTR_RO(phy_id);
 
-static struct device_attribute mdio_dev_attrs[] = {
-	__ATTR_RO(phy_id),
-	__ATTR_NULL
+static struct attribute *mdio_dev_attrs[] = {
+	&dev_attr_phy_id.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(mdio_dev);
 
 struct bus_type mdio_bus_type = {
 	.name		= "mdio_bus",
 	.match		= mdio_bus_match,
 	.pm		= MDIO_BUS_PM_OPS,
-	.dev_attrs	= mdio_dev_attrs,
+	.dev_groups	= mdio_dev_groups,
 };
 EXPORT_SYMBOL(mdio_bus_type);
 
-- 
1.8.4.6.g82e253f.dirty

