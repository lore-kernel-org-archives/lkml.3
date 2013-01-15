Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3AOQ1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:27:39 -0500
Received: from zmc.proxad.net ([212.27.53.206]:34825 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab3AOQ1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:27:37 -0500
From: Florian Fainelli <florian@openwrt.org>
To: giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        Florian Fainelli <florian@openwrt.org>
Subject: [PATCH v2] pps: hide more configuration symbols behind CONFIG_PPS
Date: Tue, 15 Jan 2013 17:24:58 +0100
Message-Id: <1358267098-30789-1-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130108162754.GB7643@netboy.at.omicron.at>
References: <20130108162754.GB7643@netboy.at.omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes CONFIG_PPS_DEBUG and CONFIG_NTP_PPS be hidden if
CONFIG_PPS is not selected, such that we are not prompted for these
configuration options if CONFIG_PPS is not set.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes since v1:
- dropped the depends on PPS which is now useless

 drivers/pps/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 982d16b..7512e98 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -20,10 +20,10 @@ config PPS
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called pps_core.ko.
+if PPS
 
 config PPS_DEBUG
 	bool "PPS debugging messages"
-	depends on PPS
 	help
 	  Say Y here if you want the PPS support to produce a bunch of debug
 	  messages to the system log.  Select this if you are having a
@@ -31,13 +31,15 @@ config PPS_DEBUG
 
 config NTP_PPS
 	bool "PPS kernel consumer support"
-	depends on PPS && !NO_HZ
+	depends on !NO_HZ
 	help
 	  This option adds support for direct in-kernel time
 	  synchronization using an external PPS signal.
 
 	  It doesn't work on tickless systems at the moment.
 
+endif
+
 source drivers/pps/clients/Kconfig
 
 source drivers/pps/generators/Kconfig
-- 
1.7.10.4

