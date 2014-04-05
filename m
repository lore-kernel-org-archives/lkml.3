Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaDEVeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:34:12 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58052 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaDEVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:33:58 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 03/10] driver: staging: wlan-ng: switched to pr_warn
Date: Sat,  5 Apr 2014 23:33:53 +0200
Message-Id: <1396733633-15836-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changed printk(KERN_WARNING .. to pr_warn

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 943de9c..01284ea 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -714,10 +714,9 @@ static int usbctlx_rrid_completor_fn(struct usbctlx_completor *head)
 
 	/* Validate the length, note body len calculation in bytes */
 	if (rridresult.riddata_len != complete->riddatalen) {
-		printk(KERN_WARNING
-		       "RID len mismatch, rid=0x%04x hlen=%d fwlen=%d\n",
-		       rridresult.rid,
-		       complete->riddatalen, rridresult.riddata_len);
+		pr_warn("RID len mismatch, rid=0x%04x hlen=%d fwlen=%d\n",
+			rridresult.rid,
+			complete->riddatalen, rridresult.riddata_len);
 		return -ENODATA;
 	}
 
-- 
1.7.9.5

