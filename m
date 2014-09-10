Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaIJERn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:17:43 -0400
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:38367 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751118AbaIJERk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:17:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:4321:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mass18_5fe323954f001
X-Filterd-Recvd-Size: 2126
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] atm: Convert pr_warning to pr_warn
Date: Tue,  9 Sep 2014 21:17:28 -0700
Message-Id: <43f9ed4e89db6bdc47354a595d416e773de7628c.1410322181.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1410322181.git.joe@perches.com>
References: <cover.1410322181.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/atm/clip.c   | 4 ++--
 net/atm/common.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/atm/clip.c b/net/atm/clip.c
index 4633904..1d9eaa4 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -384,7 +384,7 @@ static netdev_tx_t clip_start_xmit(struct sk_buff *skb,
 	pr_debug("atm_skb(%p)->vcc(%p)->dev(%p)\n", skb, vcc, vcc->dev);
 	old = xchg(&entry->vccs->xoff, 1);	/* assume XOFF ... */
 	if (old) {
-		pr_warning("XOFF->XOFF transition\n");
+		pr_warn("XOFF->XOFF transition\n");
 		goto out_release_neigh;
 	}
 	dev->stats.tx_packets++;
@@ -447,7 +447,7 @@ static int clip_setentry(struct atm_vcc *vcc, __be32 ip)
 	struct rtable *rt;
 
 	if (vcc->push != clip_push) {
-		pr_warning("non-CLIP VCC\n");
+		pr_warn("non-CLIP VCC\n");
 		return -EBADF;
 	}
 	clip_vcc = CLIP_VCC(vcc);
diff --git a/net/atm/common.c b/net/atm/common.c
index 7b49100..6a76515 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -300,7 +300,7 @@ static int adjust_tp(struct atm_trafprm *tp, unsigned char aal)
 		max_sdu = ATM_MAX_AAL34_PDU;
 		break;
 	default:
-		pr_warning("AAL problems ... (%d)\n", aal);
+		pr_warn("AAL problems ... (%d)\n", aal);
 		/* fall through */
 	case ATM_AAL5:
 		max_sdu = ATM_MAX_AAL5_PDU;
-- 
1.8.1.2.459.gbcd45b4.dirty

