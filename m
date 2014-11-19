Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaKSP2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:28:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:1978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbaKSP23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:28:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="639756122"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, andrew.kim@intel.com
Subject: [PATCHv5 1/7] phy: safer to_phy() macro
Date: Wed, 19 Nov 2014 17:28:17 +0200
Message-Id: <1416410903-162369-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes to_phy() macro work with other variable names
besides "dev".

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/phy/phy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 8cb6f81..9fda683 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -110,7 +110,7 @@ struct phy_init_data {
 	.port		= _port,				\
 }
 
-#define	to_phy(dev)	(container_of((dev), struct phy, dev))
+#define	to_phy(a)	(container_of((a), struct phy, dev))
 
 #define	of_phy_provider_register(dev, xlate)	\
 	__of_phy_provider_register((dev), THIS_MODULE, (xlate))
-- 
2.1.3

