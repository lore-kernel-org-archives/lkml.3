Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaIVSRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:17:47 -0400
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:60948 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754033AbaIVSRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:17:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3867:3871:4321:4605:5007:6119:7652:9592:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:13069:13161:13229:13311:13357:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bean94_7d8ba53bbd343
X-Filterd-Recvd-Size: 2687
Message-ID: <1411409861.2952.57.camel@joe-AO725>
Subject: [PATCH net-next] bluetooth: Convert bt_<level> logging functions to
 return void
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Sep 2014 11:17:41 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No caller or macro uses the return value so make all
the functions return void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 include/net/bluetooth/bluetooth.h |  4 ++--
 net/bluetooth/lib.c               | 14 ++++----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 7e666d0..58695ff 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -120,9 +120,9 @@ struct bt_voice {
 #define BT_RCVMTU		13
 
 __printf(1, 2)
-int bt_info(const char *fmt, ...);
+void bt_info(const char *fmt, ...);
 __printf(1, 2)
-int bt_err(const char *fmt, ...);
+void bt_err(const char *fmt, ...);
 
 #define BT_INFO(fmt, ...)	bt_info(fmt "\n", ##__VA_ARGS__)
 #define BT_ERR(fmt, ...)	bt_err(fmt "\n", ##__VA_ARGS__)
diff --git a/net/bluetooth/lib.c b/net/bluetooth/lib.c
index 941ad75..b36bc04 100644
--- a/net/bluetooth/lib.c
+++ b/net/bluetooth/lib.c
@@ -135,40 +135,34 @@ int bt_to_errno(__u16 code)
 }
 EXPORT_SYMBOL(bt_to_errno);
 
-int bt_info(const char *format, ...)
+void bt_info(const char *format, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int r;
 
 	va_start(args, format);
 
 	vaf.fmt = format;
 	vaf.va = &args;
 
-	r = pr_info("%pV", &vaf);
+	pr_info("%pV", &vaf);
 
 	va_end(args);
-
-	return r;
 }
 EXPORT_SYMBOL(bt_info);
 
-int bt_err(const char *format, ...)
+void bt_err(const char *format, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int r;
 
 	va_start(args, format);
 
 	vaf.fmt = format;
 	vaf.va = &args;
 
-	r = pr_err("%pV", &vaf);
+	pr_err("%pV", &vaf);
 
 	va_end(args);
-
-	return r;
 }
 EXPORT_SYMBOL(bt_err);


