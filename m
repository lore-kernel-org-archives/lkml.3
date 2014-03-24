Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaCXUQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:16:07 -0400
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:49819 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671AbaCXUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:16:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:4225:5007:6261:10004:10026:10848:11026:11657:11658:11914:12043:12438:12517:12519:12555:12690:12737:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: linen37_17aab7a0c2824
X-Filterd-Recvd-Size: 1769
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] carl9170: Remove casts of pointer to same type
Date: Mon, 24 Mar 2014 13:15:38 -0700
Message-Id: <e378d1df6fe2f8113407fcd496bd5612a878f809.1395692043.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395692043.git.joe@perches.com>
References: <cover.1395692043.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting a pointer to a pointer of the same type is pointless,
so remove these unnecessary casts.

Done via coccinelle script:

$ cat typecast_2.cocci
@@
type T;
T *foo;
@@

-	(T *)foo
+	foo

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/carl9170/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 536bc46a..924135b 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -572,7 +572,7 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 
 static void carl9170_ba_check(struct ar9170 *ar, void *data, unsigned int len)
 {
-	struct ieee80211_bar *bar = (void *) data;
+	struct ieee80211_bar *bar = data;
 	struct carl9170_bar_list_entry *entry;
 	unsigned int queue;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

