Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaDDWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:16:28 -0400
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:41478 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753442AbaDDWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:16:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3867:3872:4321:5007:6261:7904:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: head76_71ad84d2a4d4c
X-Filterd-Recvd-Size: 2096
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] usb: ftdi-elan: Coalesce string fragment
Date: Fri,  4 Apr 2014 15:16:06 -0700
Message-Id: <f6900efe7f5b4233bcf36db1dd206452e51d125a.1396649386.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1396649386.git.joe@perches.com>
References: <cover.1396649386.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easier to grep for this.

Neaten a trailing statement.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/misc/ftdi-elan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 8cda881..10c54b3 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -55,8 +55,8 @@ MODULE_LICENSE("GPL");
 #define INT_MODULE_PARM(n, v) static int n = v;module_param(n, int, 0444)
 static bool distrust_firmware = 1;
 module_param(distrust_firmware, bool, 0);
-MODULE_PARM_DESC(distrust_firmware, "true to distrust firmware power/overcurren"
-		 "t setup");
+MODULE_PARM_DESC(distrust_firmware,
+		 "true to distrust firmware power/overcurrent setup");
 extern struct platform_driver u132_platform_driver;
 static struct workqueue_struct *status_queue;
 static struct workqueue_struct *command_queue;
@@ -590,8 +590,7 @@ static void ftdi_elan_status_work(struct work_struct *work)
 				ftdi_elan_flush_targets(ftdi);
 			work_delay_in_msec = 250;
 		} else {
-			dev_err(&ftdi->udev->dev, "PCI device has disappeared\n"
-				);
+			dev_err(&ftdi->udev->dev, "PCI device has disappeared\n");
 			ftdi_elan_cancel_targets(ftdi);
 			work_delay_in_msec = 500;
 			ftdi->enumerated = 0;
-- 
1.8.1.2.459.gbcd45b4.dirty

