Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab3D2TCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:02:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759502Ab3D2TCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 32/42] net: mvmdio: add select PHYLIB
Date: Mon, 29 Apr 2013 12:02:14 -0700
Message-Id: <20130429184756.038843452@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

[ Upstream commit 2e0cbf2cc2c9371f0aa198857d799175ffe231a6 ]

The mvmdio driver uses the phylib API, so it should select the PHYLIB
symbol, otherwise, a build with mvmdio (but without mvneta) fails to
build with undefined symbols such as mdiobus_unregister, mdiobus_free,
etc.

The mvneta driver does not use the phylib API directly, so it does not
need to select PHYLIB. It already selects the mvmdio driver anyway.

Historically, this problem is due to the fact that the PHY handling
was originally part of mvneta, and was later moved to a separate
driver, without updating the Kconfig select statements
accordingly. And since there was no functional reason to use mvmdio
without mvneta, this case was not tested.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -33,6 +33,7 @@ config MV643XX_ETH
 
 config MVMDIO
 	tristate "Marvell MDIO interface support"
+	select PHYLIB
 	---help---
 	  This driver supports the MDIO interface found in the network
 	  interface units of the Marvell EBU SoCs (Kirkwood, Orion5x,
@@ -45,7 +46,6 @@ config MVMDIO
 config MVNETA
 	tristate "Marvell Armada 370/XP network interface support"
 	depends on MACH_ARMADA_370_XP
-	select PHYLIB
 	select MVMDIO
 	---help---
 	  This driver supports the network interface units in the


