Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbaDQAMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:12:45 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:38559 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbaDQAMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:12:43 -0400
Message-ID: <534F1C6E.7010606@gmail.com>
Date: Wed, 16 Apr 2014 17:12:30 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [DRIVER CORE] drivers/base/dd.c incorrect pr_debug() parameters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_debug() parameters are reverse order of format string

Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---

 drivers/base/dd.c |    4 	2 +	2 -	0 !
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/base/dd.c
===================================================================
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -187,8 +187,8 @@ static void driver_bound(struct device *
 		return;
 	}
 
-	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev_name(dev),
-		 __func__, dev->driver->name);
+	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev->driver->name,
+		 __func__, dev_name(dev));
 
 	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
 
