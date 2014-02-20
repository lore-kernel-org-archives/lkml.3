Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaBUAyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:54:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaBTXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.10 45/66] usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
Date: Thu, 20 Feb 2014 15:51:44 -0800
Message-Id: <20140220234910.780882880@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/storage/unusual_cypress.h |    2 +-
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


