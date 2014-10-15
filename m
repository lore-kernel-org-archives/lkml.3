Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaJOUD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:03:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:40678 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbaJOUDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:03:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="400857917"
From: Octavian Purdila <octavian.purdila@intel.com>
To: wsa@the-dreams.de
Cc: linux@roeck-us.net, johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATH v3 2/4] i2c: document struct i2c_adapter
Date: Wed, 15 Oct 2014 23:03:29 +0300
Message-Id: <1413403411-8895-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com>
References: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the i2c_adapter fields that must be initialized before
calling i2c_add_adapter().

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 include/linux/i2c.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a95efeb..36041e2 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -418,9 +418,19 @@ int i2c_recover_bus(struct i2c_adapter *adap);
 int i2c_generic_gpio_recovery(struct i2c_adapter *adap);
 int i2c_generic_scl_recovery(struct i2c_adapter *adap);
 
-/*
- * i2c_adapter is the structure used to identify a physical i2c bus along
- * with the access algorithms necessary to access it.
+/**
+ * struct i2c_adapter - represents an I2C physical bus
+ *
+ * The following members must be set by the adapter driver before
+ * calling i2c_add_adapter():
+ *
+ * @owner: the module owner, usually THIS_MODULE
+ * @class: bitmask of I2C_CLASS_*
+ * @algo: see struct i2c_algorithm
+ * @dev.parent: set this to the struct device of the driver (e.g. pci_dev->dev,
+ *	usb->interface->dev, platform_device->dev etc.)
+ * @name: name of this i2c bus
+ * @bus_recovery_info: see struct i2c_bus_recovery_info. Optional.
  */
 struct i2c_adapter {
 	struct module *owner;
-- 
1.9.1

