Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208Ab3B1PMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:12:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab3B1Or6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 053/139] USB: usb-storage: unusual_devs update for Super TOP SATA bridge
Date: Thu, 28 Feb 2013 14:43:23 +0000
Message-Id: <1362062689-2567-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 18e03310b5caa6d11c1a8c61b982c37047693fba upstream.

The current entry in unusual_cypress.h for the Super TOP SATA bridge devices
seems to be causing corruption on newer revisions of this device.  This has
been reported in Arch Linux and Fedora.  The original patch was tested on
devices with bcdDevice of 1.60, whereas the newer devices report bcdDevice
as 2.20.  Limit the UNUSUAL_DEV entry to devices less than 2.20.

This fixes https://bugzilla.redhat.com/show_bug.cgi?id=909591

The Arch Forum post on this is here:
	https://bbs.archlinux.org/viewtopic.php?id=152011

Reported-by: Carsten S. <carsteniq@yahoo.com>
Tested-by: Carsten S. <carsteniq@yahoo.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/unusual_cypress.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_cypress.h b/drivers/usb/storage/unusual_cypress.h
index 2c85530..65a6a75 100644
--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -31,7 +31,7 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x9999,
 		"Cypress ISD-300LP",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
 
-UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x0219,
 		"Super Top",
 		"USB 2.0  SATA BRIDGE",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
-- 
1.8.1.2

