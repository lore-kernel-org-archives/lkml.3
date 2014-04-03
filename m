Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162498AbaDCHM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:12:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47541 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162368AbaDCHM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:12:56 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 3/9] driver: staging: wlan-ng: switched to pr_warn
Date: Thu,  3 Apr 2014 09:12:52 +0200
Message-Id: <1396509172-2932-1-git-send-email-shehabaldin.sherif@gmail.com>
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
index 2a44c79..a389cef 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -715,10 +715,9 @@ static int usbctlx_rrid_completor_fn(struct usbctlx_completor *head)
 
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

