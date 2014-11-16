Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaKPUJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:44 -0500
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:44660 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071AbaKPUJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:3868:4321:5007:6261:8531:10004:10848:11026:11658:11914:12517:12519:12555:13255:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: van37_5408d56549602
X-Filterd-Recvd-Size: 2261
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 05/16] signal: Move case statements to separate lines and for loop neatening
Date: Sun, 16 Nov 2014 12:09:12 -0800
Message-Id: <a4446f21ba9198bff546fee0c90f80159d2e82a3.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal style for case statements and for loops

Make the initialization and for loop test more expected style too.
Add a break to the last case.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 0efde2d..49562b2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -110,21 +110,26 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 
 	switch (_NSIG_WORDS) {
 	default:
-		for (i = _NSIG_WORDS, ready = 0; --i >= 0 ;)
+		ready = 0;
+		for (i = _NSIG_WORDS; i >= 0; i--)
 			ready |= signal->sig[i] & ~blocked->sig[i];
 		break;
 
-	case 4: ready  = signal->sig[3] & ~blocked->sig[3];
+	case 4:
+		ready  = signal->sig[3] & ~blocked->sig[3];
 		ready |= signal->sig[2] & ~blocked->sig[2];
 		ready |= signal->sig[1] & ~blocked->sig[1];
 		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 2: ready  = signal->sig[1] & ~blocked->sig[1];
+	case 2:
+		ready  = signal->sig[1] & ~blocked->sig[1];
 		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 1: ready  = signal->sig[0] & ~blocked->sig[0];
+	case 1:
+		ready  = signal->sig[0] & ~blocked->sig[0];
+		break;
 	}
 	return ready !=	0;
 }
-- 
2.1.2

