Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaCaAWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36305 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.812735749@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 078/200] usb-storage: restrict bcdDevice range for
 Super Top in Cypress ATACB
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a9c143c82608bee2a36410caa56d82cd86bdc7fa upstream.

The Cypress ATACB unusual-devs entry for the Super Top SATA bridge
causes problems.  Although it was originally reported only for
bcdDevice = 0x160, its range was much larger.  This resulted in a bug
report for bcdDevice 0x220, so the range was capped at 0x219.  Now
Milan reports errors with bcdDevice 0x150.

Therefore this patch restricts the range to just 0x160.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Milan Svoboda <milan.svoboda@centrum.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_cypress.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -31,7 +31,7 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x
 		"Cypress ISD-300LP",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
 
-UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x0219,
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0160, 0x0160,
 		"Super Top",
 		"USB 2.0  SATA BRIDGE",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),

