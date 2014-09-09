Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbaIIQzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:55:42 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45895 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaIIQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:55:40 -0400
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nitin Kuppelur <nitinkuppelur@gmail.com>
Subject: [PATCH] Staging: octeon-hcd: removed dummy label
Date: Tue,  9 Sep 2014 17:22:19 +0200
Message-Id: <1410276139-7212-1-git-send-email-nitinkuppelur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the octeon-hcd.c file that
removes dummy label i.e. label followed by return of
void function

Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 8a80982..5fffef2 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -2253,9 +2253,8 @@ static void __cvmx_usb_perform_complete(
 			/* Increment to the next location in our packet array */
 			transaction->iso_packets++;
 			transaction->stage = CVMX_USB_STAGE_NON_CONTROL;
-			goto done;
+			return;
 		}
-	}
 
 	/* Remove the transaction from the pipe list */
 	list_del(&transaction->node);
@@ -2266,8 +2265,6 @@ static void __cvmx_usb_perform_complete(
 					 transaction->actual_bytes,
 					 transaction->urb);
 	kfree(transaction);
-done:
-	return;
 }
 
 
-- 
1.9.1

