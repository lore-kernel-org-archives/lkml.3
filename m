Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab3CDDoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33031 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756895Ab3CDDoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:23 -0500
Message-Id: <20130304033713.728709636@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Josh Boyer <jwboyer@redhat.com>,
        "Carsten S." <carsteniq@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 062/153] USB: usb-storage: unusual_devs update for Super TOP SATA bridge
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


