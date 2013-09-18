Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3IRC7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 22:59:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:7951 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3IRC7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 22:59:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,928,1371106800"; 
   d="scan'208";a="296208854"
Subject: [PATCH V2] ahci: Changing two module params with static and
 __read_mostly
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tj@kernel.org, joe@perches.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
In-Reply-To: <1379436518.26153.31.camel@cliu38-desktop-build>
References: <1379436518.26153.31.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Sep 2013 20:21:49 +0800
Message-ID: <1379506909.26153.33.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here module parameters ahci_em_messages and devslp_idle_timeout can
be set as static and __read_mostly.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/ata/libahci.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index acfd0f7..b67086f 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -189,14 +189,15 @@ struct ata_port_operations ahci_pmp_retry_srst_ops = {
 };
 EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
 
-int ahci_em_messages = 1;
+static bool ahci_em_messages __read_mostly = true;
 EXPORT_SYMBOL_GPL(ahci_em_messages);
-module_param(ahci_em_messages, int, 0444);
+module_param(ahci_em_messages, bool, 0444);
 /* add other LED protocol types when they become supported */
 MODULE_PARM_DESC(ahci_em_messages,
 	"AHCI Enclosure Management Message control (0 = off, 1 = on)");
 
-int devslp_idle_timeout = 1000;	/* device sleep idle timeout in ms */
+/* device sleep idle timeout in ms */
+static int devslp_idle_timeout __read_mostly = 1000;
 module_param(devslp_idle_timeout, int, 0644);
 MODULE_PARM_DESC(devslp_idle_timeout, "device sleep idle timeout");
 
-- 
1.7.9.5



