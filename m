Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaAUVZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:56509 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbaAUVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:30 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 58/73] drivers/mfd: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:01 -0500
Message-ID: <1390339396-3479-59-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mfd/adp5520.c             | 1 -
 drivers/mfd/cs5535-mfd.c          | 1 -
 drivers/mfd/janz-cmodio.c         | 1 -
 drivers/mfd/lpc_ich.c             | 1 -
 drivers/mfd/lpc_sch.c             | 1 -
 drivers/mfd/mcp-sa11x0.c          | 1 -
 drivers/mfd/pcf50633-adc.c        | 1 -
 drivers/mfd/rc5t583-irq.c         | 1 -
 drivers/mfd/rdc321x-southbridge.c | 1 -
 drivers/mfd/retu-mfd.c            | 1 -
 drivers/mfd/smsc-ece1099.c        | 1 -
 drivers/mfd/ti-ssp.c              | 1 -
 drivers/mfd/ti_am335x_tscadc.c    | 1 -
 drivers/mfd/tps65912-core.c       | 1 -
 drivers/mfd/tps65912-irq.c        | 1 -
 drivers/mfd/twl4030-irq.c         | 1 -
 drivers/mfd/twl4030-madc.c        | 1 -
 drivers/mfd/twl6030-irq.c         | 1 -
 drivers/mfd/vexpress-config.c     | 1 -
 drivers/mfd/wm8350-core.c         | 1 -
 drivers/mfd/wm8350-irq.c          | 1 -
 21 files changed, 21 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 6250155..f495b8b 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
index 17c1301..be91cb5 100644
--- a/drivers/mfd/cs5535-mfd.c
+++ b/drivers/mfd/cs5535-mfd.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/mfd/core.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 81b7d88..433f823 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index be93fa2..010c1b4 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -58,7 +58,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index 3bb05c0..4ee7550 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -23,7 +23,6 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/mfd/mcp-sa11x0.c b/drivers/mfd/mcp-sa11x0.c
index 41c31b3..29d7698 100644
--- a/drivers/mfd/mcp-sa11x0.c
+++ b/drivers/mfd/mcp-sa11x0.c
@@ -12,7 +12,6 @@
  *  MCP read/write timeouts from Jordi Colomer, rehacked by rmk.
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index b8941a5..c1984b0 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/completion.h>
diff --git a/drivers/mfd/rc5t583-irq.c b/drivers/mfd/rc5t583-irq.c
index b41db59..bb85020 100644
--- a/drivers/mfd/rc5t583-irq.c
+++ b/drivers/mfd/rc5t583-irq.c
@@ -22,7 +22,6 @@
  */
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/mfd/rc5t583.h>
 
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index d346146..c795697 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -19,7 +19,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
diff --git a/drivers/mfd/retu-mfd.c b/drivers/mfd/retu-mfd.c
index c8f345f..663f8a3 100644
--- a/drivers/mfd/retu-mfd.c
+++ b/drivers/mfd/retu-mfd.c
@@ -19,7 +19,6 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/irq.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
diff --git a/drivers/mfd/smsc-ece1099.c b/drivers/mfd/smsc-ece1099.c
index 24ae3d8..90112d4 100644
--- a/drivers/mfd/smsc-ece1099.c
+++ b/drivers/mfd/smsc-ece1099.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
diff --git a/drivers/mfd/ti-ssp.c b/drivers/mfd/ti-ssp.c
index a542457..0769ecd 100644
--- a/drivers/mfd/ti-ssp.c
+++ b/drivers/mfd/ti-ssp.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index d4e8604..6000c49 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/io.h>
diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index 27a518e..1f82d60 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -15,7 +15,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/mfd/core.h>
diff --git a/drivers/mfd/tps65912-irq.c b/drivers/mfd/tps65912-irq.c
index d360a83..fbecec7 100644
--- a/drivers/mfd/tps65912-irq.c
+++ b/drivers/mfd/tps65912-irq.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/bug.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 9aa6d1e..596b1f6 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -27,7 +27,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include <linux/init.h>
 #include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 4c583e4..d700cd2 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -29,7 +29,6 @@
  *
  */
 
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index 18a607e..a6bb17d 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -31,7 +31,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include <linux/init.h>
 #include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
index 84ce6b9..0c9c350 100644
--- a/drivers/mfd/vexpress-config.c
+++ b/drivers/mfd/vexpress-config.c
@@ -16,7 +16,6 @@
 #include <linux/bitops.h>
 #include <linux/completion.h>
 #include <linux/export.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 7c1ae24..4ab527f 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -14,7 +14,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/bug.h>
 #include <linux/device.h>
diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index 624ff90..cd01f79 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -14,7 +14,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/bug.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
-- 
1.8.4.1

