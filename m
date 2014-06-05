Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaFEMzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:55:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:20239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbaFEMx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:53:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,981,1392192000"; 
   d="scan'208";a="441253799"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCHv2 1/6] phy: safer to_phy() macro
Date: Thu,  5 Jun 2014 15:52:53 +0300
Message-Id: <1401972778-5880-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes to_phy() macro work with other variable names
besides "dev".

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 include/linux/phy/phy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 2760744..10d9714 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -108,7 +108,7 @@ struct phy_init_data {
 	.port		= _port,				\
 }
 
-#define	to_phy(dev)	(container_of((dev), struct phy, dev))
+#define	to_phy(a)	(container_of((a), struct phy, dev))
 
 #define	of_phy_provider_register(dev, xlate)	\
 	__of_phy_provider_register((dev), THIS_MODULE, (xlate))
-- 
2.0.0.rc4

