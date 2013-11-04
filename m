Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3KDRJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:09:37 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:45852 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3KDRIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:08:24 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 5/9] GenWQE: Move comments
Date: Mon,  4 Nov 2013 18:08:05 +0100
Message-Id: <1383584889-21594-6-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-0542-0000-0000-000006F32A5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move documentation from driver sources to appropriate place in the
sysfs documentation file for this driver

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/sysfs-driver-genwqe |    9 +++++++++
 drivers/misc/genwqe/card_base.c               |   20 --------------------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-genwqe b/Documentation/ABI/testing/sysfs-driver-genwqe
index d85c076..0976901 100644
--- a/Documentation/ABI/testing/sysfs-driver-genwqe
+++ b/Documentation/ABI/testing/sysfs-driver-genwqe
@@ -44,3 +44,12 @@ What:           /sys/class/genwqe/genwqe<n>_card/base_clock
 Date:           Oct 2013
 Contact:        haver@linux.vnet.ibm.com
 Description:    Base clock frequency of the card.
+
+What:           /sys/class/genwqe/genwqe<n>_card/device/sriov_numvfs
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Enable VFs (1..15):
+                  sudo sh -c 'echo 15 > \
+                    /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
+                Disable VFs:
+                  Write a 0 into the same sysfs entry.
diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
index 271d957..c649ef7 100644
--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -22,16 +22,6 @@
  * Module initialization and PCIe setup. Card health monitoring and
  * recovery functionality. Character device creation and deletion are
  * controlled from here.
- *
- * Please use the new sysfs interfaces to enable the VFs after PF
- * driver loading.
- *
- * Enable VFs:
- *   sudo sh -c 'echo 15 > /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
- * or
- *   sudo sh -c 'echo 15 > /sys/class/genwqe/genwqe0_card/device/sriov_numvfs'
- * Disable VFs:
- *   Write a 0 into the same sysfs entries.
  */
 
 #include <linux/module.h>
@@ -798,22 +788,12 @@ static u64 genwqe_fir_checking(struct genwqe_dev *cd)
  *
  * This thread must only exit if kthread_should_stop() becomes true.
  *
- * Testing bind/unbind with:
- *   sudo sh -c "echo -n 0000:20:00.0 > /sys/bus/pci/drivers/genwqe/unbind"
- *   sudo sh -c "echo -n 0000:20:00.0 > /sys/bus/pci/drivers/genwqe/bind"
- *
  * Condition for the health-thread to trigger:
  *   a) when a kthread_stop() request comes in or
  *   b) a critical GFIR occured
  *
  * Informational GFIRs are checked and potentially printed in
  * health_check_interval seconds.
- *
- * Testcase to trigger this code:
- *   Fatal GFIR:
- *     sudo ./tools/genwqe_poke -C0 0x00000008 0x001
- *   Info GFIR by writing to VF:
- *     sudo ./tools/genwqe_poke -C2 0x00020020 0x800
  */
 static int genwqe_health_thread(void *data)
 {
-- 
1.7.1

