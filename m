Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaAUV3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:29:18 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50835 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbaAUVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Mark Brown <broonie@kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: [PATCH 67/73] drivers/base: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:10 -0500
Message-ID: <1390339396-3479-68-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/base/attribute_container.c   | 1 -
 drivers/base/power/clock_ops.c       | 1 -
 drivers/base/power/common.c          | 1 -
 drivers/base/power/domain.c          | 1 -
 drivers/base/power/domain_governor.c | 1 -
 drivers/base/power/opp.c             | 1 -
 drivers/base/regmap/regmap-i2c.c     | 1 -
 drivers/base/regmap/regmap-mmio.c    | 1 -
 drivers/base/regmap/regmap-spi.c     | 1 -
 drivers/base/topology.c              | 1 -
 10 files changed, 10 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index ecc1929..b84ca8f 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/attribute_container.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index e870bbe..b99e6c0 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -6,7 +6,6 @@
  * This file is released under the GPLv2.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/io.h>
diff --git a/drivers/base/power/common.c b/drivers/base/power/common.c
index 5da9140..df2e5ee 100644
--- a/drivers/base/power/common.c
+++ b/drivers/base/power/common.c
@@ -6,7 +6,6 @@
  * This file is released under the GPLv2.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/export.h>
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index bfb8955..921b192 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -6,7 +6,6 @@
  * This file is released under the GPLv2.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/base/power/domain_governor.c b/drivers/base/power/domain_governor.c
index 28dee30..a089e3b 100644
--- a/drivers/base/power/domain_governor.c
+++ b/drivers/base/power/domain_governor.c
@@ -6,7 +6,6 @@
  * This file is released under the GPLv2.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_qos.h>
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index fa41874..2553867 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/cpufreq.h>
 #include <linux/device.h>
diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index fa6bf52..ebd1895 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -13,7 +13,6 @@
 #include <linux/regmap.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
-#include <linux/init.h>
 
 static int regmap_i2c_write(void *context, const void *data, size_t count)
 {
diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index 81f9775..4410cb2 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -18,7 +18,6 @@
 
 #include <linux/clk.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index 37f12ae..0eb3097 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -12,7 +12,6 @@
 
 #include <linux/regmap.h>
 #include <linux/spi/spi.h>
-#include <linux/init.h>
 #include <linux/module.h>
 
 #include "internal.h"
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 94ffee3..ad9d177 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -23,7 +23,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */
-#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
-- 
1.8.4.1

