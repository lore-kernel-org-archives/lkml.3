Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3CNKRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:17:09 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:57990 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999Ab3CNKRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:17:07 -0400
Message-ID: <1363256224.1335.46.camel@x61.thuisdomein>
Subject: [PATCH] staging: ccg: remove two outdated dependencies
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 11:17:04 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 10:17:04.0897 (UTC) FILETIME=[1378EF10:01CE209D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbols USB_FILE_STORAGE and USB_FILE_STORAGE_TEST got
removed in commit fa06920a3ece1ed43333992d35c0044e7a6c048a ("usb:
gadget: Remove File-backed Storage Gadget (g_file_storage)."). That
commit failed to remove the negative dependencies on those two symbols
in the USB_G_CCG entry. Since these dependencies will always evaluate to
true, they can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) This patch is rather hard to review. That is because the "depends on"
line is rather hard to read. Perhaps the easiest way to review is to do
    git grep -n "\bUSB_FILE_STORAGE\(_TEST\)\?\b"

before and after applying this patch. But that doesn't catch possible
other, unwanted, changes. Maybe we need to split up the "depends on"
line before removing these two negative entries.

 drivers/staging/ccg/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccg/Kconfig b/drivers/staging/ccg/Kconfig
index 7ed5bc6..5c5a415 100644
--- a/drivers/staging/ccg/Kconfig
+++ b/drivers/staging/ccg/Kconfig
@@ -2,7 +2,7 @@ if USB_GADGET
 
 config USB_G_CCG
 	tristate "Configurable Composite Gadget (STAGING)"
-	depends on STAGING && BLOCK && NET && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM && TTY
+	depends on STAGING && BLOCK && NET && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM && TTY
 	help
 	  The Configurable Composite Gadget supports multiple USB
 	  functions: acm, mass storage, rndis and FunctionFS.
-- 
1.7.11.7

