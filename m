Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaKPULr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:11:47 -0500
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:44673 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751356AbaKPUJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:4321:5007:6114:6261:6642:10004:10848:11026:11658:11914:12043:12517:12519:12555:13161:13229:13255:13311:13357:13868:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act27_55b0ef32a9b18
X-Filterd-Recvd-Size: 1588
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 10/16] signal: Remove unnecessary parentheses from function pointer call
Date: Sun, 16 Nov 2014 12:09:17 -0800
Message-Id: <ddbdb64be33df9792096342bbf76f9d0c9b0a688.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These don't add clarity so remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 74bd4dd..d782fa0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -592,7 +592,7 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
 	if (sig) {
 		if (current->notifier) {
 			if (sigismember(current->notifier_mask, sig)) {
-				if (!(current->notifier)(current->notifier_data)) {
+				if (!current->notifier(current->notifier_data)) {
 					clear_thread_flag(TIF_SIGPENDING);
 					return 0;
 				}
-- 
2.1.2

