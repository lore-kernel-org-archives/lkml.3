Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaLURVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:21:47 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37555 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaLURVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:21:46 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] i8k: Make fan module parameters an unsigned
Date: Sun, 21 Dec 2014 18:21:28 +0100
Message-Id: <1419182488-20157-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting negative fan multiplier or maximal fan speed does make any sense and
can cause problems. So ensure that negative values will not be accepted.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 48d701c..175bb9f 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -64,9 +64,9 @@ static DEFINE_MUTEX(i8k_mutex);
 static char bios_version[4];
 static struct device *i8k_hwmon_dev;
 static u32 i8k_hwmon_flags;
-static int i8k_fan_mult;
-static int i8k_pwm_mult;
-static int i8k_fan_max = I8K_FAN_HIGH;
+static uint i8k_fan_mult;
+static uint i8k_pwm_mult;
+static uint i8k_fan_max = I8K_FAN_HIGH;
 
 #define I8K_HWMON_HAVE_TEMP1	(1 << 0)
 #define I8K_HWMON_HAVE_TEMP2	(1 << 1)
@@ -95,12 +95,12 @@ static bool power_status;
 module_param(power_status, bool, 0600);
 MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
 
-static int fan_mult = I8K_FAN_MULT;
-module_param(fan_mult, int, 0);
+static uint fan_mult = I8K_FAN_MULT;
+module_param(fan_mult, uint, 0);
 MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
 
-static int fan_max = I8K_FAN_HIGH;
-module_param(fan_max, int, 0);
+static uint fan_max = I8K_FAN_HIGH;
+module_param(fan_max, uint, 0);
 MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed");
 
 static int i8k_open_fs(struct inode *inode, struct file *file);
@@ -696,8 +696,8 @@ static int __init i8k_init_hwmon(void)
 }
 
 struct i8k_config_data {
-	int fan_mult;
-	int fan_max;
+	uint fan_mult;
+	uint fan_max;
 };
 
 enum i8k_configs {
-- 
1.7.9.5

