Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3BUUP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:15:27 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:45113 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3BUUPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:15:19 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, miletus@chromium.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 4/6] Platform: x86: chromeos_laptop - Add support for probing devices
Date: Thu, 21 Feb 2013 12:14:58 -0800
Message-Id: <1361477700-26342-5-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361477700-26342-1-git-send-email-bleung@chromium.org>
References: <1361477700-26342-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow support for devices that may appear at more than
one i2c address at boot time. The specific example is the atmel_mxt touch
devices, which may appear at a different address if it comes up
in bootloader mode.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 3e405d7..f3a292b 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -144,6 +144,26 @@ static int __init find_i2c_adapter_num(enum i2c_adapter_type type)
 }
 
 /*
+ * Takes a list of addresses in addrs as such :
+ * { addr1, ... , addrn, I2C_CLIENT_END };
+ * add_probed_i2c_device will use i2c_new_probed_device
+ * and probe for devices at all of the addresses listed.
+ * Returns NULL if no devices found.
+ * See Documentation/i2c/instantiating-devices for more information.
+ */
+static __init struct i2c_client *add_probed_i2c_device(
+		const char *name,
+		enum i2c_adapter_type type,
+		struct i2c_board_info *info,
+		const unsigned short *addrs)
+{
+	return __add_probed_i2c_device(name,
+				       find_i2c_adapter_num(type),
+				       info,
+				       addrs);
+}
+
+/*
  * Probes for a device at a single address, the one provided by
  * info->addr.
  * Returns NULL if no device found.
-- 
1.8.1.3

