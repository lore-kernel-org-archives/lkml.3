Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab3BUSOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:14:14 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:35250 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab3BUSOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:14:10 -0500
Date: Thu, 21 Feb 2013 19:13:37 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Juan David Gonzalez Cobas <dcobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/8] FMC: create drivers/fmc and toplevel Kconfig question
Message-ID: <f9f4e8049d14a6d4e14d2c5458b9dbc68c448390.1361469465.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1361469465.git.rubini@gnudd.com>
In-Reply-To: <cover.1361469465.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit creates the drivers/fmc directory and puts the necessary
hooks for kbuild and kconfig.  The code is currently a placeholder
that only registers an empty bus.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Emilio G. Cota <cota@braap.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 MAINTAINERS            |    9 +++++++++
 drivers/Kconfig        |    2 ++
 drivers/Makefile       |    1 +
 drivers/fmc/Kconfig    |   17 +++++++++++++++++
 drivers/fmc/Makefile   |    4 ++++
 drivers/fmc/fmc-core.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 drivers/fmc/Kconfig
 create mode 100644 drivers/fmc/Makefile
 create mode 100644 drivers/fmc/fmc-core.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1279240..dca2907 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3253,6 +3253,15 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git
 S:	Odd fixes
 F:	drivers/block/floppy.c
 
+FMC SUBSYSTEM
+M:	Alessandro Rubini <rubini@gnudd.com>
+W:	http://www.ohwr.org/projects/fmc-bus
+S:	Supported
+F:	drivers/fmc/
+F:	include/linux/fmc*.h
+F:	include/linux/ipmi-fru.h
+K:	fmc_d.*register
+
 FPU EMULATOR
 M:	Bill Metzenthen <billm@melbpc.org.au>
 W:	http://floatingpoint.sourceforge.net/emulator/index.html
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 202fa6d..e0182e0 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -162,4 +162,6 @@ source "drivers/irqchip/Kconfig"
 
 source "drivers/ipack/Kconfig"
 
+source "drivers/fmc/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index a93fbfc..57363a6 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -150,3 +150,4 @@ obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_IPACK_BUS)		+= ipack/
 obj-$(CONFIG_NTB)		+= ntb/
+obj-$(CONFIG_FMC)		+= fmc/
diff --git a/drivers/fmc/Kconfig b/drivers/fmc/Kconfig
new file mode 100644
index 0000000..e287902
--- /dev/null
+++ b/drivers/fmc/Kconfig
@@ -0,0 +1,17 @@
+#
+# FMC (ANSI-VITA 57.1) bus support
+#
+
+menuconfig FMC
+	tristate "FMC support"
+	help
+
+	  FMC (FPGA Mezzanine Carrier) is a mechanical and electrical
+	  standard for mezzanine cards that plug into a carrier board.
+	  This kernel subsystem supports the matching between carrier
+	  and mezzanine based on identifiers stored in the internal I2C
+	  EEPROM, as well as having carrier-independent drivers.
+
+	  The framework was born outside of the kernel and at this time
+	  the off-tree code base is more complete.  Code and documentation
+	  is at git://ohwr.org/fmc-projects/fmc-bus.git .
diff --git a/drivers/fmc/Makefile b/drivers/fmc/Makefile
new file mode 100644
index 0000000..a2784d8
--- /dev/null
+++ b/drivers/fmc/Makefile
@@ -0,0 +1,4 @@
+
+obj-$(CONFIG_FMC) += fmc.o
+
+fmc-y = fmc-core.o
diff --git a/drivers/fmc/fmc-core.c b/drivers/fmc/fmc-core.c
new file mode 100644
index 0000000..8695291
--- /dev/null
+++ b/drivers/fmc/fmc-core.c
@@ -0,0 +1,42 @@
+/* Temporary placeholder so the empty code can build */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+
+static struct bus_type fmc_bus_type = {
+	.name = "fmc",
+};
+
+/* Every device must have a release method: provide a default */
+static void __fmc_release(struct device *dev) { }
+
+/* This is needed as parent for our devices and dir in sysfs */
+struct device fmc_bus = {
+	.release = __fmc_release,
+	.init_name = "fmc",
+};
+
+static int fmc_init(void)
+{
+	int err;
+
+	err = device_register(&fmc_bus);
+	if (err)
+		return err;
+	err = bus_register(&fmc_bus_type);
+	if (err)
+		device_unregister(&fmc_bus);
+	return err;
+}
+
+static void fmc_exit(void)
+{
+	bus_unregister(&fmc_bus_type);
+	device_unregister(&fmc_bus);
+}
+
+module_init(fmc_init);
+module_exit(fmc_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.7.2
