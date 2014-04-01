Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaDAMDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:03:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaDALRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/144] firewire: ohci: beautify some macro definitions
Date: Tue,  1 Apr 2014 12:14:15 +0100
Message-Id: <1396350948-29910-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 0dbe15f88be5b2cdf4ca4145797861dfb0d583a5 upstream.

a) Sort device IDs by vendor -- device -- revision.

b) Write quirk flags in hexadecimal.  This affects the user-visible
output of "modinfo firewire-ohci".  Since more flags have been added
recently, it is now easier to cope with them in hexadecimal represen-
tation.  Besides, the device-specific combination of quirk flags is
shown in hexadecimal in the kernel log too.  (And firewire-sbp2
presents its own quirk flags in modinfo as hexadecimals as well.)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
[ luis: 3.11.y prereq for:
  0ca4934 "firewire: ohci: fix probe failure with Agere/LSI controllers" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firewire/ohci.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index afb701e..66a63b4 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -271,6 +271,7 @@ static inline struct fw_ohci *fw_ohci(struct fw_card *card)
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
 #define PCI_DEVICE_ID_CREATIVE_SB1394	0x4001
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
@@ -278,17 +279,16 @@ static char ohci_driver_name[] = KBUILD_MODNAME;
 #define PCI_DEVICE_ID_TI_TSB12LV26	0x8020
 #define PCI_DEVICE_ID_TI_TSB82AA2	0x8025
 #define PCI_DEVICE_ID_VIA_VT630X	0x3044
-#define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
 #define PCI_REV_ID_VIA_VT6306		0x46
 
-#define QUIRK_CYCLE_TIMER		1
-#define QUIRK_RESET_PACKET		2
-#define QUIRK_BE_HEADERS		4
-#define QUIRK_NO_1394A			8
-#define QUIRK_NO_MSI			16
-#define QUIRK_TI_SLLZ059		32
-#define QUIRK_IR_WAKE			64
-#define QUIRK_PHY_LCTRL_TIMEOUT		128
+#define QUIRK_CYCLE_TIMER		0x1
+#define QUIRK_RESET_PACKET		0x2
+#define QUIRK_BE_HEADERS		0x4
+#define QUIRK_NO_1394A			0x8
+#define QUIRK_NO_MSI			0x10
+#define QUIRK_TI_SLLZ059		0x20
+#define QUIRK_IR_WAKE			0x40
+#define QUIRK_PHY_LCTRL_TIMEOUT		0x80
 
 /* In case of multiple matches in ohci_quirks[], only the first one is used. */
 static const struct {
-- 
1.9.1

