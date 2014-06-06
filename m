Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaFFRgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:36:51 -0400
Received: from mout.web.de ([212.227.17.12]:52078 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbaFFRey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:54 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 08/13] mac80211: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:27 +0200
Message-Id: <1402076072-4044-8-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:Y5obEjDZG7BLgjO0Bv1sU/SmfqrgXGC0dSUArL+rLuoeHaLBdef
 KMwZ0f4xhyaMZw9Qy8ASqY5FTfHSyhdwvDEAA3PUPFiIK1RXRxBWx4DFR9MUqYmaAQq2nYJ
 C9vMXvaLYsS+/gtY6h8dotERkvIO2d28zPLMA4U+LMXr4g2cdhn/eYoNKeX1ieGbQyVVO+2
 JsBq+tCQ5yboSvyazYHyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d7513a5..110c42b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2822,7 +2822,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 				if (new_dur > 0) {
 					/* add right after tmp */
-					list_add(&roc->list, &tmp->list);
+					list_add_after(&roc->list, &tmp->list);
 				} else {
 					list_add_tail(&roc->list,
 						      &tmp->dependents);
-- 
2.0.0

