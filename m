Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbbATTWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:22:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42185 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbATTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:22:39 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [net-next] net: netcp: remove unused kconfig option and code
Date: Tue, 20 Jan 2015 14:22:36 -0500
Message-ID: <1421781756-11151-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently CPTS is built into the netcp driver even though there is no
call out to the CPTS driver. This patch removes the dependency in Kconfig
and remove cpts.o from the Makefile for NetCP.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/net/ethernet/ti/Kconfig  |    2 +-
 drivers/net/ethernet/ti/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index e11bcfa..824e376 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -73,7 +73,7 @@ config TI_CPSW
 config TI_CPTS
 	boolean "TI Common Platform Time Sync (CPTS) Support"
 	depends on TI_CPSW
-	depends on TI_CPSW || TI_KEYSTONE_NET
+	depends on TI_CPSW
 	select PTP_1588_CLOCK
 	---help---
 	  This driver supports the Common Platform Time Sync unit of
diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index 465d03d..0a9813b 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -13,4 +13,4 @@ ti_cpsw-y := cpsw_ale.o cpsw.o cpts.o
 
 obj-$(CONFIG_TI_KEYSTONE_NETCP) += keystone_netcp.o
 keystone_netcp-y := netcp_core.o netcp_ethss.o	netcp_sgmii.o \
-			netcp_xgbepcsr.o cpsw_ale.o cpts.o
+			netcp_xgbepcsr.o cpsw_ale.o
-- 
1.7.9.5

