Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaFXSaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:30:23 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:38828 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754550AbaFXSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:30:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3871:4321:4605:5007:7652:7875:10004:10400:10848:11026:11658:11914:12517:12519:12555:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sky39_757d4d6bd12a
X-Filterd-Recvd-Size: 2285
Message-ID: <1403634048.29061.23.camel@joe-AO725>
Subject: [trivial PATCH net-next] mac_pton: Use bool not int return
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jun 2014 11:20:48 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bool instead of int as the return type.

All uses are tested with !.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |  2 +-
 lib/net_utils.c        | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 44649e0..112a6f5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -501,7 +501,7 @@ static inline char * __deprecated pack_hex_byte(char *buf, u8 byte)
 extern int hex_to_bin(char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 
-int mac_pton(const char *s, u8 *mac);
+bool mac_pton(const char *s, u8 *mac);
 
 /*
  * General tracing related utility functions - trace_printk(),
diff --git a/lib/net_utils.c b/lib/net_utils.c
index 2e3c52c..148fc6e 100644
--- a/lib/net_utils.c
+++ b/lib/net_utils.c
@@ -3,24 +3,24 @@
 #include <linux/ctype.h>
 #include <linux/kernel.h>
 
-int mac_pton(const char *s, u8 *mac)
+bool mac_pton(const char *s, u8 *mac)
 {
 	int i;
 
 	/* XX:XX:XX:XX:XX:XX */
 	if (strlen(s) < 3 * ETH_ALEN - 1)
-		return 0;
+		return false;
 
 	/* Don't dirty result unless string is valid MAC. */
 	for (i = 0; i < ETH_ALEN; i++) {
 		if (!isxdigit(s[i * 3]) || !isxdigit(s[i * 3 + 1]))
-			return 0;
+			return false;
 		if (i != ETH_ALEN - 1 && s[i * 3 + 2] != ':')
-			return 0;
+			return false;
 	}
 	for (i = 0; i < ETH_ALEN; i++) {
 		mac[i] = (hex_to_bin(s[i * 3]) << 4) | hex_to_bin(s[i * 3 + 1]);
 	}
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL(mac_pton);



