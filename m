Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaINKSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:18:47 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:47197 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaINKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:18:32 -0400
X-Yandex-Uniq: a5c6cc75-51fb-4f2f-ac6d-f8bc014a3c30
Authentication-Results: smtp16.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH 1/3] kbuild: Make targets names tree-wide unique on x86
From: Kirill Tkhai <tkhai@yandex.ru>
To: mmarek@suse.cz, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Date: Sun, 14 Sep 2014 14:18:24 +0400
Message-ID: <20140914101821.3745.21235.stgit@localhost>
In-Reply-To: <20140914100545.3745.23394.stgit@localhost>
References: <20140914100545.3745.23394.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the duplicate targets names found on x86 allyesconfig.

Change "acpi" on "acpica" in drivers/acpi/acpica/Makefile.

Change "pnp" on "pnpacpi" in drivers/pnp/pnpacpi/Makefile.

Also remove "mounts" target from init/Makefile. It's artificial
driver name, let's do not litter namespace.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 drivers/acpi/acpica/Makefile |   28 ++++++++++++++--------------
 drivers/pnp/pnpacpi/Makefile |    4 ++--
 init/Makefile                |   19 ++++++++++++-------
 3 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index c1a9635..c425735 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -5,10 +5,10 @@
 ccflags-y			:= -Os -DBUILDING_ACPICA
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 
-# use acpi.o to put all files here into acpi.o modparam namespace
-obj-y	+= acpi.o
+# use acpica.o to put all files here into acpica.o modparam namespace
+obj-y	+= acpica.o
 
-acpi-y :=		\
+acpica-y :=		\
 	dsargs.o	\
 	dscontrol.o	\
 	dsfield.o	\
@@ -24,7 +24,7 @@ acpi-y :=		\
 	dswscope.o	\
 	dswstate.o
 
-acpi-y +=		\
+acpica-y +=		\
 	evevent.o	\
 	evgpe.o		\
 	evgpeblk.o	\
@@ -41,7 +41,7 @@ acpi-y +=		\
 	evxfgpe.o	\
 	evxfregn.o
 
-acpi-y +=		\
+acpica-y +=		\
 	exconfig.o	\
 	exconvrt.o	\
 	excreate.o	\
@@ -67,7 +67,7 @@ acpi-y +=		\
 	exsystem.o	\
 	exutils.o
 
-acpi-y +=		\
+acpica-y +=		\
 	hwacpi.o	\
 	hwesleep.o	\
 	hwgpe.o		\
@@ -78,9 +78,9 @@ acpi-y +=		\
 	hwxface.o	\
 	hwxfsleep.o
 
-acpi-$(ACPI_FUTURE_USAGE) += hwtimer.o
+acpica-$(ACPI_FUTURE_USAGE) += hwtimer.o
 
-acpi-y +=		\
+acpica-y +=		\
 	nsaccess.o	\
 	nsalloc.o	\
 	nsarguments.o	\
@@ -103,9 +103,9 @@ acpi-y +=		\
 	nsxfname.o	\
 	nsxfobj.o
 
-acpi-$(ACPI_FUTURE_USAGE) += nsdumpdv.o
+acpica-$(ACPI_FUTURE_USAGE) += nsdumpdv.o
 
-acpi-y +=		\
+acpica-y +=		\
 	psargs.o	\
 	psloop.o	\
 	psobject.o	\
@@ -118,7 +118,7 @@ acpi-y +=		\
 	pswalk.o	\
 	psxface.o
 
-acpi-y +=		\
+acpica-y +=		\
 	rsaddr.o	\
 	rscalc.o	\
 	rscreate.o	\
@@ -134,7 +134,7 @@ acpi-y +=		\
 	rsutils.o	\
 	rsxface.o
 
-acpi-y +=		\
+acpica-y +=		\
 	tbdata.o	\
 	tbfadt.o	\
 	tbfind.o	\
@@ -145,7 +145,7 @@ acpi-y +=		\
 	tbxfload.o	\
 	tbxfroot.o
 
-acpi-y +=		\
+acpica-y +=		\
 	utaddress.o	\
 	utalloc.o	\
 	utbuffer.o	\
@@ -176,7 +176,7 @@ acpi-y +=		\
 	utxferror.o	\
 	utxfmutex.o
 
-acpi-$(ACPI_FUTURE_USAGE) +=	\
+acpica-$(ACPI_FUTURE_USAGE) +=	\
 	utcache.o		\
 	utfileio.o		\
 	utprint.o		\
diff --git a/drivers/pnp/pnpacpi/Makefile b/drivers/pnp/pnpacpi/Makefile
index 40c93da..2a7ae46 100644
--- a/drivers/pnp/pnpacpi/Makefile
+++ b/drivers/pnp/pnpacpi/Makefile
@@ -1,6 +1,6 @@
 #
 # Makefile for the kernel PNPACPI driver.
 #
-obj-y += pnp.o
+obj-y += pnpacpi.o
 
-pnp-y := core.o rsparser.o
+pnpacpi-y := core.o rsparser.o
diff --git a/init/Makefile b/init/Makefile
index 7bc47ee..566a9ff 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -2,23 +2,28 @@
 # Makefile for the linux kernel.
 #
 
-obj-y                          := main.o version.o mounts.o
+obj-y                          := main.o version.o do_mounts.o
+
 ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
 else
-obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
+obj-y                          += initramfs.o do_mounts_initrd.o
+endif
+
+ifeq ($(CONFIG_BLK_DEV_RAM),y)
+obj-y                          += do_mounts_rd.o
 endif
+
+ifeq ($(CONFIG_BLK_DEV_MD),y)
+obj-y                          += do_mounts_md.o
+endif
+
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
 
 ifneq ($(CONFIG_ARCH_INIT_TASK),y)
 obj-y                          += init_task.o
 endif
 
-mounts-y			:= do_mounts.o
-mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o
-mounts-$(CONFIG_BLK_DEV_INITRD)	+= do_mounts_initrd.o
-mounts-$(CONFIG_BLK_DEV_MD)	+= do_mounts_md.o
-
 # dependencies on generated files need to be listed explicitly
 $(obj)/version.o: include/generated/compile.h
 

