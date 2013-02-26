Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab3B0AA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:00:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab3BZX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Carsten S." <carsteniq@yahoo.com>, Josh Boyer <jwboyer@redhat.com>
Subject: [ 53/53] USB: usb-storage: unusual_devs update for Super TOP SATA bridge
Date: Tue, 26 Feb 2013 15:58:22 -0800
Message-Id: <20130226235625.358125397@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/storage/unusual_cypress.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -31,7 +31,7 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x
 		"Cypress ISD-300LP",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
 
-UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x0219,
 		"Super Top",
 		"USB 2.0  SATA BRIDGE",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),


