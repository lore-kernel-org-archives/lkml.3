Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3FLHOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:14:19 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:48465 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356Ab3FLHOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:14:17 -0400
Date: Wed, 12 Jun 2013 09:13:25 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        gregkh@linuxfoundation.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/8] FMC: create drivers/fmc and toplevel Kconfig question
Message-ID: <8dd3427d60e01c3e7a6eceb7dfd72d5a896b5008.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1371018406.git.rubini@gnudd.com>
In-Reply-To: <cover.1371018406.git.rubini@gnudd.com>
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
 drivers/fmc/fmc-core.c |   24 ++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 drivers/fmc/Kconfig
 create mode 100644 drivers/fmc/Makefile
 create mode 100644 drivers/fmc/fmc-core.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d97b3e..10ebdfc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3322,6 +3322,15 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/floppy.git
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
index b8ec9cf..aa43b91 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -164,4 +164,6 @@ source "drivers/ipack/Kconfig"
 
 source "drivers/reset/Kconfig"
 
+source "drivers/fmc/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index bbf3810..ab93de8 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -151,3 +151,4 @@ obj-$(CONFIG_IIO)		+= iio/
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
index 0000000..fc3547f
--- /dev/null
+++ b/drivers/fmc/fmc-core.c
@@ -0,0 +1,24 @@
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
+static int fmc_init(void)
+{
+	return bus_register(&fmc_bus_type);
+}
+
+static void fmc_exit(void)
+{
+	bus_unregister(&fmc_bus_type);
+}
+
+module_init(fmc_init);
+module_exit(fmc_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.7.2
