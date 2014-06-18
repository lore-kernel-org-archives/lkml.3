Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaFROH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:07:56 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48376 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737AbaFROHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:07:51 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: netdev@vger.kernel.org
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v4 2/3] ieee802154: cc2520: add driver to kernel build system
Date: Wed, 18 Jun 2014 19:36:42 +0530
Message-Id: <1403100403-6429-3-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403100403-6429-1-git-send-email-varkab@cdac.in>
References: <1403100403-6429-1-git-send-email-varkab@cdac.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/net/ieee802154/Kconfig  |   11 +++++++++++
 drivers/net/ieee802154/Makefile |    1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ieee802154/Kconfig b/drivers/net/ieee802154/Kconfig
index 3e89bea..8b7ae51 100644
--- a/drivers/net/ieee802154/Kconfig
+++ b/drivers/net/ieee802154/Kconfig
@@ -51,3 +51,14 @@ config IEEE802154_MRF24J40
 
 	  This driver can also be built as a module. To do so, say M here.
 	  the module will be called 'mrf24j40'.
+
+config IEEE802154_CC2520
+	depends on IEEE802154_DRIVERS && MAC802154
+	tristate "CC2520 transceiver driver"
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

