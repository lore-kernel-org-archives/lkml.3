Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968031Ab3HJARZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 20:17:25 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41001 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3HJARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 20:17:24 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH] usb: Move definition of USB_EHCI_BIG_ENDIAN_MMIO out side of the ifs.
Date: Fri,  9 Aug 2013 17:17:17 -0700
Message-Id: <1376093837-24561-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

When CONFIG_USB_SUPPORT is not selected we get things like:

scripts/kconfig/mconf Kconfig
warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB)

It is much cleaner to make the various system Kconfigs select
USB_EHCI_BIG_ENDIAN_MMIO rather than move the system config
information into USB's Kconfig, but the warnings are annoying.

Eliminate the warning by moving the definition of
USB_EHCI_BIG_ENDIAN_MMIO outside of all the Kconfig if statements.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/usb/Kconfig      | 3 +++
 drivers/usb/host/Kconfig | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 73f62ca..38f97c5 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -9,6 +9,9 @@ config USB_ARCH_HAS_OHCI
 config USB_ARCH_HAS_EHCI
 	bool
 
+config USB_EHCI_BIG_ENDIAN_MMIO
+	bool
+
 config USB_ARCH_HAS_XHCI
 	bool
 
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 8e8e694..75e9f30 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -113,9 +113,6 @@ config USB_EHCI_HCD_PMC_MSP
 		Enables support for the onchip USB controller on the PMC_MSP7100 Family SoC's.
 		If unsure, say N.
 
-config USB_EHCI_BIG_ENDIAN_MMIO
-	bool
-
 config USB_EHCI_BIG_ENDIAN_DESC
 	bool
 
-- 
1.7.11.7

