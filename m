Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966590AbaFRMWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:22:06 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37956 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966548AbaFRMWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:22:01 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: netdev@vger.kernel.org
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v3 2/3] ieee802154: cc2520: add driver to kernel build system
Date: Wed, 18 Jun 2014 17:50:31 +0530
Message-Id: <1403094032-6121-3-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403094032-6121-1-git-send-email-varkab@cdac.in>
References: <1403094032-6121-1-git-send-email-varkab@cdac.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/net/ieee802154/Kconfig  |   11 +++++++++++
 drivers/net/ieee802154/Makefile |    1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ieee802154/Kconfig b/drivers/net/ieee802154/Kconfig
index 3e89bea..680422f 100644
--- a/drivers/net/ieee802154/Kconfig
+++ b/drivers/net/ieee802154/Kconfig
@@ -51,3 +51,14 @@ config IEEE802154_MRF24J40
 
 	  This driver can also be built as a module. To do so, say M here.
 	  the module will be called 'mrf24j40'.
+
+config IEEE802154_CC2520
+	depends on IEEE802154_DRIVERS && MAC802154
+	tristate "cc2520 transceiver driver"
+	depends on SPI
+	---help---
+	  Say Y here to enable the CC2520 SPI 802.15.4 wireless
+	  controller.
+
+	  This driver can also be built as a module. To do so, say M here.
+	  the module will be called 'cc2520'.
diff --git a/drivers/net/ieee802154/Makefile b/drivers/net/ieee802154/Makefile
index abb0c08..655cb95 100644
--- a/drivers/net/ieee802154/Makefile
+++ b/drivers/net/ieee802154/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_IEEE802154_FAKEHARD) += fakehard.o
 obj-$(CONFIG_IEEE802154_FAKELB) += fakelb.o
 obj-$(CONFIG_IEEE802154_AT86RF230) += at86rf230.o
 obj-$(CONFIG_IEEE802154_MRF24J40) += mrf24j40.o
+obj-$(CONFIG_IEEE802154_CC2520) += cc2520.o
-- 
1.7.9.5

