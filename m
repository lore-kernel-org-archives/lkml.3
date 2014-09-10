Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaIJDJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:09:42 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56787 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaIJDJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:09:41 -0400
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nitin Kuppelur <nitinkuppelur@gmail.com>
Subject: [PATCH V2] Staging: octeon-hcd: removed dummy label
Date: Wed, 10 Sep 2014 03:36:24 +0200
Message-Id: <1410312984-7798-1-git-send-email-nitinkuppelur@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <540FA96D.7040903@gmail.com>
References: <540FA96D.7040903@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the octeon-hcd.c file that fixes
removes dummy label i.e. label followed by return of
void function

Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 8a80982..5f9db4c 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -2253,7 +2253,7 @@ static void __cvmx_usb_perform_complete(
 			/* Increment to the next location in our packet array */
 			transaction->iso_packets++;
 			transaction->stage = CVMX_USB_STAGE_NON_CONTROL;
-			goto done;
+			return;
 		}
 	}
 
@@ -2266,8 +2266,6 @@ static void __cvmx_usb_perform_complete(
 					 transaction->actual_bytes,
 					 transaction->urb);
 	kfree(transaction);
-done:
-	return;
 }
 
 
-- 
1.9.1

