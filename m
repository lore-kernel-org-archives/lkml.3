Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3AKWIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:08:42 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:40292 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab3AKWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:08:38 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 3/6] staging: line6: use pr_err() instead of printk(KERN_ERR, ...)
Date: Fri, 11 Jan 2013 23:08:11 +0100
Message-Id: <1357942094-11495-4-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
References: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl warning:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
  #1861: FILE: staging/line6/driver.h:56:
  +       printk(KERN_ERR "line6usb driver bug: missing case in %s:%d\n", \

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 1dd768c2..2e0f134 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -53,7 +53,7 @@
 #define LINE6_CHANNEL_MASK 0x0f
 
 #define MISSING_CASE	\
-	printk(KERN_ERR "line6usb driver bug: missing case in %s:%d\n", \
+	pr_err("line6usb driver bug: missing case in %s:%d\n", \
 		__FILE__, __LINE__)
 
 #define CHECK_RETURN(x)		\
-- 
1.8.0.2

