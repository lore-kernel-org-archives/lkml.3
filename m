Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaBVCAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:00:18 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:43268 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754648AbaBVCAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:00:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3867:3868:4321:5007:6119:7652:7903:8603:8660:10004:10400:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:12694:12737:13069:13148:13230:13311:13357:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trick85_3c4eef5cd8038
X-Filterd-Recvd-Size: 2692
Message-ID: <1393034412.3627.11.camel@joe-AO722>
Subject: sisusb: Use static const, fix typo
From: Joe Perches <joe@perches.com>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 18:00:12 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce text a bit by using static const.

Fix a symmetric typo and neaten a dev_info call
to 80 columns.

$ size drivers/usb/misc/sisusbvga/sisusb.o*
   text	   data	    bss	    dec	    hex	filename
  30016	   4841	   9180	  44037	   ac05	drivers/usb/misc/sisusbvga/sisusb.o.new
  30087	   4841	   9180	  44108	   ac4c	drivers/usb/misc/sisusbvga/sisusb.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index de98906..1f89633 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2123,8 +2123,9 @@ sisusb_get_ramconfig(struct sisusb_usb_data *sisusb)
 	u8 tmp8, tmp82, ramtype;
 	int bw = 0;
 	char *ramtypetext1 = NULL;
-	const char *ramtypetext2[] = {	"SDR SDRAM", "SDR SGRAM",
-					"DDR SDRAM", "DDR SGRAM" };
+	static const char *ramtypetext2[] = {
+		"SDR SDRAM", "SDR SGRAM", "DDR SDRAM", "DDR SGRAM"
+	};
 	static const int busSDR[4]  = {64, 64, 128, 128};
 	static const int busDDR[4]  = {32, 32,  64,  64};
 	static const int busDDRA[4] = {64+32, 64+32 , (64+32)*2, (64+32)*2};
@@ -2146,7 +2147,7 @@ sisusb_get_ramconfig(struct sisusb_usb_data *sisusb)
 		sisusb->vramsize <<= 1;
 		bw = busSDR[(tmp8 & 0x03)];
 		break;
-	case 2: ramtypetext1 = "asymmeric";
+	case 2: ramtypetext1 = "asymmetric";
 		sisusb->vramsize += sisusb->vramsize/2;
 		bw = busDDRA[(tmp8 & 0x03)];
 		break;
@@ -2156,8 +2157,9 @@ sisusb_get_ramconfig(struct sisusb_usb_data *sisusb)
 		break;
 	}
 
-	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %s, bus width %d\n", (sisusb->vramsize >> 20), ramtypetext1,
-			ramtypetext2[ramtype], bw);
+	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %s, bus width %d\n",
+		 sisusb->vramsize >> 20, ramtypetext1, ramtypetext2[ramtype],
+		 bw);
 }
 
 static int


