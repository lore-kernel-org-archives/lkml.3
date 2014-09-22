Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaIVRuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:50:40 -0400
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:58241 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754137AbaIVRuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:50:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3867:3871:3872:4321:4605:5007:6119:7652:9592:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12555:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beds88_2275ddf12e608
X-Filterd-Recvd-Size: 3006
Message-ID: <1411408235.2952.52.camel@joe-AO725>
Subject: [PATCH] [media] tda18271-common: Convert _tda_printk to return void
From: Joe Perches <joe@perches.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Sep 2014 10:50:35 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No caller or macro uses the return value so make it void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 drivers/media/tuners/tda18271-common.c | 19 ++++++++-----------
 drivers/media/tuners/tda18271-priv.h   |  4 ++--
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
index 18c77af..86e5e31 100644
--- a/drivers/media/tuners/tda18271-common.c
+++ b/drivers/media/tuners/tda18271-common.c
@@ -714,12 +714,11 @@ fail:
 	return ret;
 }
 
-int _tda_printk(struct tda18271_priv *state, const char *level,
-		const char *func, const char *fmt, ...)
+void _tda_printk(struct tda18271_priv *state, const char *level,
+		 const char *func, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int rtn;
 
 	va_start(args, fmt);
 
@@ -727,15 +726,13 @@ int _tda_printk(struct tda18271_priv *state, const char *level,
 	vaf.va = &args;
 
 	if (state)
-		rtn = printk("%s%s: [%d-%04x|%c] %pV",
-			     level, func, i2c_adapter_id(state->i2c_props.adap),
-			     state->i2c_props.addr,
-			     (state->role == TDA18271_MASTER) ? 'M' : 'S',
-			     &vaf);
+		printk("%s%s: [%d-%04x|%c] %pV",
+		       level, func, i2c_adapter_id(state->i2c_props.adap),
+		       state->i2c_props.addr,
+		       (state->role == TDA18271_MASTER) ? 'M' : 'S',
+		       &vaf);
 	else
-		rtn = printk("%s%s: %pV", level, func, &vaf);
+		printk("%s%s: %pV", level, func, &vaf);
 
 	va_end(args);
-
-	return rtn;
 }
diff --git a/drivers/media/tuners/tda18271-priv.h b/drivers/media/tuners/tda18271-priv.h
index 454c152..b36a7b7 100644
--- a/drivers/media/tuners/tda18271-priv.h
+++ b/drivers/media/tuners/tda18271-priv.h
@@ -139,8 +139,8 @@ extern int tda18271_debug;
 #define DBG_CAL  16
 
 __attribute__((format(printf, 4, 5)))
-int _tda_printk(struct tda18271_priv *state, const char *level,
-		const char *func, const char *fmt, ...);
+void _tda_printk(struct tda18271_priv *state, const char *level,
+		 const char *func, const char *fmt, ...);
 
 #define tda_printk(st, lvl, fmt, arg...)			\
 	_tda_printk(st, lvl, __func__, fmt, ##arg)


