Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3I3Uay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:30:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:8648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab3I3U3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="412029774"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, viro@zeniv.linux.org.uk
Subject: [PATCH 09/11] epoll: Remove unnecessary error path
Date: Mon, 30 Sep 2013 13:29:10 -0700
Message-Id: <1380572952-30729-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

A static checker was pointing out that nothing can possible set
nwait < 0 in this path. The comment and the check appears to be
outdated. Remove it.

Cc: viro@zeniv.linux.org.uk
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/eventpoll.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 473e09d..f72bf55 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1276,15 +1276,6 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	 */
 	revents = ep_item_poll(epi, &epq.pt);
 
-	/*
-	 * We have to check if something went wrong during the poll wait queue
-	 * install process. Namely an allocation for a wait queue failed due
-	 * high memory pressure.
-	 */
-	error = -ENOMEM;
-	if (epi->nwait < 0)
-		goto error_unregister;
-
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_lock);
 	list_add_tail(&epi->fllink, &tfile->f_ep_links);
@@ -1334,7 +1325,6 @@ error_remove_epi:
 
 	rb_erase(&epi->rbn, &ep->rbr);
 
-error_unregister:
 	ep_unregister_pollwait(ep, epi);
 
 	/*
-- 
1.8.3.1

