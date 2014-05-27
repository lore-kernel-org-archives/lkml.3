Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaE0VjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:39:07 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:58360 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbaE0VjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:39:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] tlan: Enable activity LED on Olicom OC-2325 and OC-2326
Date: Tue, 27 May 2014 23:38:39 +0200
Message-Id: <1401226727-5508-2-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401226727-5508-1-git-send-email-linux@rainbow-software.org>
References: <1401226727-5508-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olicom OC-2325 and OC-2326 ethernet cards have an activity LED but it does not
work with tlan driver as it's not enabled. Enable it.
Tested with OC-2326.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/ti/tlan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 591437e..e7449cb 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -107,8 +107,10 @@ static struct board {
 	{ "Compaq Netelligent 10/100 TX Embedded UTP",
 	  TLAN_ADAPTER_NONE, 0x83 },
 	{ "Olicom OC-2183/2185", TLAN_ADAPTER_USE_INTERN_10, 0x83 },
-	{ "Olicom OC-2325", TLAN_ADAPTER_UNMANAGED_PHY, 0xf8 },
-	{ "Olicom OC-2326", TLAN_ADAPTER_USE_INTERN_10, 0xf8 },
+	{ "Olicom OC-2325", TLAN_ADAPTER_ACTIVITY_LED |
+	  TLAN_ADAPTER_UNMANAGED_PHY, 0xf8 },
+	{ "Olicom OC-2326", TLAN_ADAPTER_ACTIVITY_LED |
+	  TLAN_ADAPTER_USE_INTERN_10, 0xf8 },
 	{ "Compaq Netelligent 10/100 TX UTP", TLAN_ADAPTER_ACTIVITY_LED, 0x83 },
 	{ "Compaq Netelligent 10 T/2 PCI UTP/coax", TLAN_ADAPTER_NONE, 0x83 },
 	{ "Compaq NetFlex-3/E",
-- 
Ondrej Zary

