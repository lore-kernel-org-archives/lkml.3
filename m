Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaAUV0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:26:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:56654 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaAUV0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:26:06 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 66/73] drivers/macintosh: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:09 -0500
Message-ID: <1390339396-3479-67-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/macintosh/adb-iop.c                 | 1 -
 drivers/macintosh/ams/ams-input.c           | 1 -
 drivers/macintosh/macio-adb.c               | 1 -
 drivers/macintosh/via-macii.c               | 1 -
 drivers/macintosh/via-pmu68k.c              | 1 -
 drivers/macintosh/windfarm_ad7417_sensor.c  | 1 -
 drivers/macintosh/windfarm_fcu_controls.c   | 1 -
 drivers/macintosh/windfarm_lm75_sensor.c    | 1 -
 drivers/macintosh/windfarm_max6690_sensor.c | 1 -
 drivers/macintosh/windfarm_smu_sat.c        | 1 -
 10 files changed, 10 deletions(-)

diff --git a/drivers/macintosh/adb-iop.c b/drivers/macintosh/adb-iop.c
index f5f4da3..2c242f7 100644
--- a/drivers/macintosh/adb-iop.c
+++ b/drivers/macintosh/adb-iop.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/proc_fs.h>
 
 #include <asm/macintosh.h> 
diff --git a/drivers/macintosh/ams/ams-input.c b/drivers/macintosh/ams/ams-input.c
index 2edae7d..b1bdd48 100644
--- a/drivers/macintosh/ams/ams-input.c
+++ b/drivers/macintosh/ams/ams-input.c
@@ -14,7 +14,6 @@
 
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 
 #include "ams.h"
diff --git a/drivers/macintosh/macio-adb.c b/drivers/macintosh/macio-adb.c
index 87de8d9..c8fcac0 100644
--- a/drivers/macintosh/macio-adb.c
+++ b/drivers/macintosh/macio-adb.c
@@ -14,7 +14,6 @@
 #include <asm/pgtable.h>
 #include <asm/hydra.h>
 #include <asm/irq.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 
 struct preg {
diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index 3725f08..fd27da3 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -30,7 +30,6 @@
 #include <linux/delay.h>
 #include <linux/adb.h>
 #include <linux/interrupt.h>
-#include <linux/init.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_via.h>
diff --git a/drivers/macintosh/via-pmu68k.c b/drivers/macintosh/via-pmu68k.c
index a00ee41..d2e252e 100644
--- a/drivers/macintosh/via-pmu68k.c
+++ b/drivers/macintosh/via-pmu68k.c
@@ -25,7 +25,6 @@
 #include <linux/miscdevice.h>
 #include <linux/blkdev.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 
 #include <linux/adb.h>
diff --git a/drivers/macintosh/windfarm_ad7417_sensor.c b/drivers/macintosh/windfarm_ad7417_sensor.c
index 7c28b71..76715a7 100644
--- a/drivers/macintosh/windfarm_ad7417_sensor.c
+++ b/drivers/macintosh/windfarm_ad7417_sensor.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
 #include <asm/prom.h>
diff --git a/drivers/macintosh/windfarm_fcu_controls.c b/drivers/macintosh/windfarm_fcu_controls.c
index 0226b79..50ba619 100644
--- a/drivers/macintosh/windfarm_fcu_controls.c
+++ b/drivers/macintosh/windfarm_fcu_controls.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
 #include <asm/prom.h>
diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index 590214b..704dd2e 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
 #include <asm/prom.h>
diff --git a/drivers/macintosh/windfarm_max6690_sensor.c b/drivers/macintosh/windfarm_max6690_sensor.c
index 87e439b..a3504d3 100644
--- a/drivers/macintosh/windfarm_max6690_sensor.c
+++ b/drivers/macintosh/windfarm_max6690_sensor.c
@@ -8,7 +8,6 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <asm/prom.h>
diff --git a/drivers/macintosh/windfarm_smu_sat.c b/drivers/macintosh/windfarm_smu_sat.c
index ad6223e..b6d70d2 100644
--- a/drivers/macintosh/windfarm_smu_sat.c
+++ b/drivers/macintosh/windfarm_smu_sat.c
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
-- 
1.8.4.1

