Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbaE2FCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:02:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaE2EiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3.10 08/86] firewire: ohci: beautify some macro definitions
Date: Wed, 28 May 2014 21:36:43 -0700
Message-Id: <20140529043514.617802953@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/ohci.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -271,6 +271,7 @@ static inline struct fw_ohci *fw_ohci(st
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
 #define PCI_DEVICE_ID_CREATIVE_SB1394	0x4001
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
@@ -278,17 +279,16 @@ static char ohci_driver_name[] = KBUILD_
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


