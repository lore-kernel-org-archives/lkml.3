Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbbA1UbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:31:23 -0500
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:48164 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757552AbbA1UbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:31:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:1981:2194:2199:2393:2538:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:4321:4401:5007:6119:6261:7903:7904:9592:10004:10848:11026:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wine49_34d52b9c3a01e
X-Filterd-Recvd-Size: 2162
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/3] dvb_net: Convert local hex dump to print_hex_dump_debug
Date: Wed, 28 Jan 2015 10:05:52 -0800
Message-Id: <96bfe405e460471c8d11ccf14b7dd69e1933520e.1422468185.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1422468185.git.joe@perches.com>
References: <cover.1422468185.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic facility instead of a home-grown one.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb-core/dvb_net.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 0b0f97a..686d327 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -83,33 +83,9 @@ static inline __u32 iov_crc32( __u32 c, struct kvec *iov, unsigned int cnt )
 
 #ifdef ULE_DEBUG
 
-#define isprint(c)	((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
-
-static void hexdump( const unsigned char *buf, unsigned short len )
+static void hexdump(const unsigned char *buf, unsigned short len)
 {
-	char str[80], octet[10];
-	int ofs, i, l;
-
-	for (ofs = 0; ofs < len; ofs += 16) {
-		sprintf( str, "%03d: ", ofs );
-
-		for (i = 0; i < 16; i++) {
-			if ((i + ofs) < len)
-				sprintf( octet, "%02x ", buf[ofs + i] );
-			else
-				strcpy( octet, "   " );
-
-			strcat( str, octet );
-		}
-		strcat( str, "  " );
-		l = strlen( str );
-
-		for (i = 0; (i < 16) && ((i + ofs) < len); i++)
-			str[l++] = isprint( buf[ofs + i] ) ? buf[ofs + i] : '.';
-
-		str[l] = '\0';
-		printk( KERN_WARNING "%s\n", str );
-	}
+	print_hex_dump_debug("", DUMP_PREFIX_OFFSET, 16, 1, buf, len, true);
 }
 
 #endif
-- 
2.1.2

