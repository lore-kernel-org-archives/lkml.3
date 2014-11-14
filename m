Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaKNFQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:16:49 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:16729 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbaKNFQr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:16:47 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'chunkeey@googlemail.com'" <chunkeey@googlemail.com>,
        "'linville@tuxdriver.com'" <linville@tuxdriver.com>,
        "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'joe@perches.com'" <joe@perches.com>
Date: Fri, 14 Nov 2014 13:16:44 +0800
Subject: [PATCH] carl9170: Convert byte_rev_table uses to bitrev8
Thread-Topic: [PATCH] carl9170: Convert byte_rev_table uses to bitrev8
Thread-Index: Ac//yi5OswK5mi6ZQd+KtioFzyjodw==
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1829D@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the inline function instead of directly indexing the array.

This allows some architectures with hardware instructions for bit
reversals to eliminate the array.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 drivers/net/wireless/ath/carl9170/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index b80b213..dca6df1 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -994,7 +994,7 @@ static int carl9170_init_rf_bank4_pwr(struct ar9170 *ar, bool band5ghz,
 			refsel0 = 0;
 			refsel1 = 1;
 		}
-		chansel = byte_rev_table[chansel];
+		chansel = bitrev8(chansel);
 	} else {
 		if (freq == 2484) {
 			chansel = 10 + (freq - 2274) / 5;
@@ -1002,7 +1002,7 @@ static int carl9170_init_rf_bank4_pwr(struct ar9170 *ar, bool band5ghz,
 		} else
 			chansel = 16 + (freq - 2272) / 5;
 		chansel *= 4;
-		chansel = byte_rev_table[chansel];
+		chansel = bitrev8(chansel);
 	}
 
 	d1 =	chansel;
-- 
2.1.1

