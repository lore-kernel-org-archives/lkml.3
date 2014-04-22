Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaDVGcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:32:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:47119 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaDVGcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:32:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,901,1389772800"; 
   d="scan'208";a="524673093"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, tianyu.lan@intel.com
Subject: [Resend Patch 5/9] I2C: Add smbus quick read/write helper function
Date: Tue, 22 Apr 2014 14:24:11 +0800
Message-Id: <1398147855-9868-6-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c_smbus_quick_write/read() helper function. These will be used
in the implementation of i2c ACPI address space handler.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/i2c/i2c-core.c | 30 ++++++++++++++++++++++++++++++
 include/linux/i2c.h    |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 7c7f4b8..3bf0048 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -2162,6 +2162,36 @@ static int i2c_smbus_check_pec(u8 cpec, struct i2c_msg *msg)
 }
 
 /**
+ * i2c_smbus_quick_write - SMBus "quick write" protocol
+ * @client: Handle to slave device
+ *
+ * This executes the SMBus "quick write" protocol, returning negative errno
+ * else zero on success.
+ */
+s32 i2c_smbus_quick_write(const struct i2c_client *client)
+{
+	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
+				I2C_SMBUS_WRITE, 0,
+				I2C_SMBUS_QUICK, NULL);
+}
+EXPORT_SYMBOL_GPL(i2c_smbus_quick_write);
+
+/**
+ * i2c_smbus_quick_read - SMBus "quick read" protocol
+ * @client: Handle to slave device
+ *
+ * This executes the SMBus "quick read" protocol, returning negative errno
+ * else zero on success.
+ */
+s32 i2c_smbus_quick_read(const struct i2c_client *client)
+{
+	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
+				I2C_SMBUS_READ, 0,
+				I2C_SMBUS_QUICK, NULL);
+}
+EXPORT_SYMBOL_GPL(i2c_smbus_quick_read);
+
+/**
  * i2c_smbus_read_byte - SMBus "receive byte" protocol
  * @client: Handle to slave device
  *
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index b556e0a..3e6ea90 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -82,6 +82,8 @@ extern s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 /* Now follow the 'nice' access routines. These also document the calling
    conventions of i2c_smbus_xfer. */
 
+extern s32 i2c_smbus_quick_write(const struct i2c_client *client);
+extern s32 i2c_smbus_quick_read(const struct i2c_client *client);
 extern s32 i2c_smbus_read_byte(const struct i2c_client *client);
 extern s32 i2c_smbus_write_byte(const struct i2c_client *client, u8 value);
 extern s32 i2c_smbus_read_byte_data(const struct i2c_client *client,
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

