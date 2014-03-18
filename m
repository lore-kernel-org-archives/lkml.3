Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443AbaCRU5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:57:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:13521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbaCRUxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172360"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 03/13] mei: me: add power gating isolation register write wrappers
Date: Tue, 18 Mar 2014 22:51:57 +0200
Message-Id: <1395175927-10562-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry and exit power gating isolation register
write handler.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hw-me.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 8dbdaae..fc5d001 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -431,6 +431,35 @@ static int mei_me_read_slots(struct mei_device *dev, unsigned char *buffer,
 }
 
 /**
+ * mei_me_pg_enter - write pg enter register to mei device.
+ *
+ * @dev: the device structure
+ */
+static void mei_me_pg_enter(struct mei_device *dev)
+{
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 reg = mei_me_reg_read(hw, H_HPG_CSR);
+	reg |= H_HPG_CSR_PGI;
+	mei_me_reg_write(hw, H_HPG_CSR, reg);
+}
+
+/**
+ * mei_me_pg_enter - write pg enter register to mei device.
+ *
+ * @dev: the device structure
+ */
+static void mei_me_pg_exit(struct mei_device *dev)
+{
+	struct mei_me_hw *hw = to_me_hw(dev);
+	u32 reg = mei_me_reg_read(hw, H_HPG_CSR);
+
+	WARN(!(reg & H_HPG_CSR_PGI), "PGI is not set\n");
+
+	reg |= H_HPG_CSR_PGIHEXR;
+	mei_me_reg_write(hw, H_HPG_CSR, reg);
+}
+
+/**
  * mei_me_irq_quick_handler - The ISR of the MEI device
  *
  * @irq: The irq number
-- 
1.8.5.3

