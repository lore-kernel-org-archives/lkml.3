Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbaDJJg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:36:26 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:40929 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965656AbaDJJgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:36:19 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat4jNPvwo0=
X-RZG-CLASS-ID: mo00
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] tca8418: fix loading this driver as a module from a device tree
Date: Thu, 10 Apr 2014 11:29:58 +0200
Message-Id: <8CC80032-D358-4643-B3AD-95C280525EAC@goldelico.com>
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loading the tca8418 driver as a module on a device tree based system needs
a MODULE_ALIAS because the driver name does not match the automatic
name generation rules of a 'compatible' entry on i2c bus.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/input/keyboard/tca8418_keypad.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/input/keyboard/tca8418_keypad.c b/drivers/input/keyboard/tca8418_keypad.c
index 55c1530..3556360 100644
--- a/drivers/input/keyboard/tca8418_keypad.c
+++ b/drivers/input/keyboard/tca8418_keypad.c
@@ -392,6 +392,11 @@ static const struct of_device_id tca8418_dt_ids[] = {
 	{ }
 };
 MODULE_DEVICE_TABLE(of, tca8418_dt_ids);
+/* the device tree based i2c loader looks for
+ * "i2c:" + second_component_of(property("compatible"))
+ * and therefore we need an alias to be found.
+ */
+MODULE_ALIAS("i2c:tca8418");
 #endif
 
 static struct i2c_driver tca8418_keypad_driver = {
-- 
1.9.1


