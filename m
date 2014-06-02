Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaFBI4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:56:33 -0400
Received: from outm2.farsite.co.uk ([82.108.209.243]:26587 "EHLO m.farsite.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752041AbaFBI4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:56:32 -0400
From: Kevin Curtis <Kevin.Curtis@farsite.com>
To: =?utf-8?B?TWFudWVsIFNjaMO2bGxpbmc=?= <manuel.schoelling@gmx.de>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "joe@perches.com" <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 2 Jun 2014 09:56:26 +0100
Subject: RE: [PATCH] wan: Use usleep_range()
Thread-Topic: [PATCH] wan: Use usleep_range()
Thread-Index: Ac984h6Kli+n7gYdR9qTvVh+EUyJkgBXldjQ
Message-ID: <E603DC592C92B54A89CEF6B0919A0B1CAFDE223D13@SOLO.hq.farsitecommunications.com>
References: <E603DC592C92B54A89CEF6B0919A0B1CAFDE223C6D@SOLO.hq.farsitecommunications.com>
 <1401548871-12352-1-git-send-email-manuel.schoelling@gmx.de>
In-Reply-To: <1401548871-12352-1-git-send-email-manuel.schoelling@gmx.de>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s528uiAm027832

Hi Manuel,
   This look fine to me.

Regards

Kevin

-----Original Message-----
From: Manuel SchÃ¶lling [mailto:manuel.schoelling@gmx.de] 
Sent: 31 May 2014 16:08
To: Kevin Curtis
Cc: davem@davemloft.net; joe@perches.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Manuel SchÃ¶lling
Subject: [PATCH] wan: Use usleep_range()

Instead of using a jiffies hack we can use the standard api for delays.

Signed-off-by: Manuel SchÃ¶lling <manuel.schoelling@gmx.de>
---
 drivers/net/wan/farsync.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c index bcfff0d..02f6d1c 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -26,6 +26,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 #include <linux/if.h>
 #include <linux/hdlc.h>
 #include <asm/io.h>
@@ -678,7 +679,6 @@ static inline void
 fst_cpureset(struct fst_card_info *card)  {
 	unsigned char interrupt_line_register;
-	unsigned long j = jiffies + 1;
 	unsigned int regval;
 
 	if (card->family == FST_FAMILY_TXU) {
@@ -696,16 +696,12 @@ fst_cpureset(struct fst_card_info *card)
 		/*
 		 * We are delaying here to allow the 9054 to reset itself
 		 */
-		j = jiffies + 1;
-		while (jiffies < j)
-			/* Do nothing */ ;
+		usleep_range(10, 20);
 		outw(0x240f, card->pci_conf + CNTRL_9054 + 2);
 		/*
 		 * We are delaying here to allow the 9054 to reload its eeprom
 		 */
-		j = jiffies + 1;
-		while (jiffies < j)
-			/* Do nothing */ ;
+		usleep_range(10, 20);
 		outw(0x040f, card->pci_conf + CNTRL_9054 + 2);
 
 		if (pci_write_config_byte
--
1.7.10.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
