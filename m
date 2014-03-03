Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbaCCTLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:11:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaCCS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 32/67] usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
Date: Mon,  3 Mar 2014 10:55:20 -0800
Message-Id: <1393872955-28810-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/storage/unusual_cypress.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_cypress.h b/drivers/usb/storage/unusual_cypress.h
index 65a6a75..82e8ed0 100644
--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -31,7 +31,7 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x9999,
 		"Cypress ISD-300LP",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
 
-UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x0219,
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0160, 0x0160,
 		"Super Top",
 		"USB 2.0  SATA BRIDGE",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
-- 
1.8.3.2

