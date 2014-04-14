Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaDNK5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:57:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbaDNK5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:57:45 -0400
Date: Mon, 14 Apr 2014 12:57:43 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] driver core: dev_get_drvdata: Don't check for NULL dev
Message-ID: <20140414125743.2ed17988@endymion.delvare>
In-Reply-To: <20140414124802.2859439e@endymion.delvare>
References: <20140414124802.2859439e@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in calling dev_get_drvdata without a valid device.
So checking for dev == NULL is pointless. If such a check is ever
needed - which I doubt - the driver should do it before calling
dev_get_drvdata.

We were returning NULL if dev was NULL, which the caller certainly did
not expect anyway, so that was only delaying the crash if the caller
is not paying attention.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-3.15-rc0.orig/drivers/base/dd.c	2014-04-09 16:16:01.631698736 +0200
+++ linux-3.15-rc0/drivers/base/dd.c	2014-04-09 16:55:09.293001255 +0200
@@ -577,9 +577,7 @@ void driver_detach(struct device_driver
  */
 void *dev_get_drvdata(const struct device *dev)
 {
-	if (dev)
-		return dev->driver_data;
-	return NULL;
+	return dev->driver_data;
 }
 EXPORT_SYMBOL(dev_get_drvdata);
 

-- 
Jean Delvare
SUSE L3 Support
