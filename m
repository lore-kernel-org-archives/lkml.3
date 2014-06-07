Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaFGQkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:40:17 -0400
Received: from mout.web.de ([212.227.17.11]:55357 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbaFGQkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:40:15 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>
Subject: [PATCHv3 1/3] list: Use argument hlist_add_after names from rcu variant
Date: Sat,  7 Jun 2014 18:40:09 +0200
Message-Id: <1402159211-12629-1-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
X-Provags-ID: V03:K0:PMCkHENREXxxS2zRddlxZE44jyNnoXLhMILjR7B9Pyqmu9W4U6I
 mJiCSX+OoLkgWU27YmpmzKK+fqfO1YsBaT6+LPLpc1Vj4kf52Ok2apuyQpcOuiQKFicAMdu
 3MyFJhsDQ/7wAxcB7iy6k3o2Jw++uq3UXTCvRdeHP86M54hn57NOA3jXUJ0Sashiiu9wxkG
 HeSgpPbOoDoIhUWYUvFIw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

The argument names of the hlist_add_after are poorly chosen because they look
the same as the ones from hlist_add_before but have to be used completely
different. This easily confuses the reader. The creator of the
hlist_add_after_rcu function has made a lot better choice.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
---
v2:
Splitted into two patches

The patches to add list_add_before/behind were removed because it seems that
there is a consensus that list_add is understood by everyone automatically
as list_add_behind and list_add_tail is understood by everyone as
list_add_before.... even when the names suggest otherwise.

 include/linux/list.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index ef95941..624ec7f 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -654,15 +654,15 @@ static inline void hlist_add_before(struct hlist_node *n,
 	*(n->pprev) = n;
 }
 
-static inline void hlist_add_after(struct hlist_node *n,
-					struct hlist_node *next)
+static inline void hlist_add_after(struct hlist_node *prev,
+				   struct hlist_node *n)
 {
-	next->next = n->next;
-	n->next = next;
-	next->pprev = &n->next;
+	n->next = prev->next;
+	prev->next = n;
+	n->pprev = &prev->next;
 
-	if(next->next)
-		next->next->pprev  = &next->next;
+	if (n->next)
+		n->next->pprev  = &n->next;
 }
 
 /* after that we'll appear to be on some hlist and hlist_del will work */
-- 
2.0.0

