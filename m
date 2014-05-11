Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaEKIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 04:09:29 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45204 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601AbaEKIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 04:08:41 -0400
From: Paul Davies C <pauldaviesc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org, Paul Davies C <pauldaviesc@gmail.com>
Subject: [PATCH 2/3] Enclose complex macro with parantheses in staging/octeon-usb/octeon-hcd.c
Date: Sun, 11 May 2014 13:38:22 +0530
Message-Id: <1399795703-6681-3-git-send-email-pauldaviesc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com>
References: <1399795703-6681-1-git-send-email-pauldaviesc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complex macro is enlosed with parantheses.

Signed-off-by: Paul Davies C <pauldaviesc@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index a65d6f8..d03095a 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -246,7 +246,7 @@ enum cvmx_usb_pipe_flags {
 };
 
 /* Normal prefetch that use the pref instruction. */
-#define CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0))
+#define CVMX_PREFETCH(address, offset) (asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0)))
 
 /* Maximum number of times to retry failed transactions */
 #define MAX_RETRIES		3
-- 
1.7.9.5

