Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaAUVZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:56520 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaAUVZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 46/73] drivers/power: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:49 -0500
Message-ID: <1390339396-3479-47-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/power/abx500_chargalg.c        | 1 -
 drivers/power/da9030_battery.c         | 1 -
 drivers/power/generic-adc-battery.c    | 1 -
 drivers/power/gpio-charger.c           | 1 -
 drivers/power/intel_mid_battery.c      | 1 -
 drivers/power/isp1704_charger.c        | 1 -
 drivers/power/max17040_battery.c       | 1 -
 drivers/power/max17042_battery.c       | 1 -
 drivers/power/pcf50633-charger.c       | 1 -
 drivers/power/reset/gpio-poweroff.c    | 1 -
 drivers/power/reset/restart-poweroff.c | 1 -
 drivers/power/s3c_adc_battery.c        | 1 -
 drivers/power/sbs-battery.c            | 1 -
 drivers/power/smb347-charger.c         | 1 -
 drivers/power/tps65090-charger.c       | 1 -
 drivers/power/wm97xx_battery.c         | 1 -
 16 files changed, 16 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 6d27236..6f20748 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -12,7 +12,6 @@
  *	Author: Imre Sunyi <imre.sunyi@sonymobile.com>
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/hrtimer.h>
diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index ae6c418..9fde83a 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -11,7 +11,6 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 59a1421..d37bb1a 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -17,7 +17,6 @@
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/iio/consumer.h>
diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index a0024b2..13a42aa 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -15,7 +15,6 @@
 
 #include <linux/device.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index 4520811..d470136 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 80edb7d..2c71520 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index c7ff6d6..7761290 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 66da691..3dfbf31 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -22,7 +22,6 @@
  * This driver is based on max17040_battery.c
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 771c4f0..fb23d05 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
diff --git a/drivers/power/reset/gpio-poweroff.c b/drivers/power/reset/gpio-poweroff.c
index e290d48..492da85 100644
--- a/drivers/power/reset/gpio-poweroff.c
+++ b/drivers/power/reset/gpio-poweroff.c
@@ -12,7 +12,6 @@
  *
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
index 5758033..ff005fb 100644
--- a/drivers/power/reset/restart-poweroff.c
+++ b/drivers/power/reset/restart-poweroff.c
@@ -11,7 +11,6 @@
  * published by the Free Software Foundation.
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/of_platform.h>
 #include <linux/module.h>
diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index 5948ce0..1039c12 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -19,7 +19,6 @@
 #include <linux/jiffies.h>
 #include <linux/s3c_adc_battery.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/module.h>
 
 #include <plat/adc.h>
diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index b5f2a76..d6e4708 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -18,7 +18,6 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index acf84e8..4c48401 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -15,7 +15,6 @@
 #include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index 8fc9d6d..d03e740 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -17,7 +17,6 @@
  */
 #include <linux/delay.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 58f7348..15ab484 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -13,7 +13,6 @@
  *
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-- 
1.8.4.1

