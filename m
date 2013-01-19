Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3ASJLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:11:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:12414 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab3ASJDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:03:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,498,1355126400"; 
   d="scan'208";a="192921427"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 09/21] NTB: namespacecheck cleanups
Date: Sat, 19 Jan 2013 02:02:23 -0700
Message-Id: <1358586155-23322-10-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare ntb_bus_type static to remove it from name space, and remove
unused ntb_get_max_spads function.  Found via `make namespacecheck`.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c        |   14 --------------
 drivers/ntb/ntb_transport.c |    2 +-
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 2357c2d..18cb5dc 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -238,20 +238,6 @@ void ntb_unregister_transport(struct ntb_device *ndev)
 }
 
 /**
- * ntb_get_max_spads() - get the total scratch regs usable
- * @ndev: pointer to ntb_device instance
- *
- * This function returns the max 32bit scratchpad registers usable by the
- * upper layer.
- *
- * RETURNS: total number of scratch pad registers available
- */
-int ntb_get_max_spads(struct ntb_device *ndev)
-{
-	return ndev->limits.max_spads;
-}
-
-/**
  * ntb_write_local_spad() - write to the secondary scratchpad register
  * @ndev: pointer to ntb_device instance
  * @idx: index to the scratchpad register, 0 based
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index c0eca02..903a72e 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -212,7 +212,7 @@ static int ntb_client_remove(struct device *dev)
 	return 0;
 }
 
-struct bus_type ntb_bus_type = {
+static struct bus_type ntb_bus_type = {
 	.name = "ntb_bus",
 	.match = ntb_match_bus,
 	.probe = ntb_client_probe,
-- 
1.7.9.5

