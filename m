Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbaF3UjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:39:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34272 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbaF3UjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:39:17 -0400
Date: Mon, 30 Jun 2014 13:39:11 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RESEND][PATCH] bsr: avoid format string leaking into device name
Message-ID: <20140630203911.GA4803@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure a format string cannot accidentally leak into a device name.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/char/bsr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index 8fedbc250414..a6cef548e01e 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -259,7 +259,7 @@ static int bsr_add_node(struct device_node *bn)
 		}
 
 		cur->bsr_device = device_create(bsr_class, NULL, cur->bsr_dev,
-						cur, cur->bsr_name);
+						cur, "%s", cur->bsr_name);
 		if (IS_ERR(cur->bsr_device)) {
 			printk(KERN_ERR "device_create failed for %s\n",
 			       cur->bsr_name);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
