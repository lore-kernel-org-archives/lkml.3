Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3C1TqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:46:18 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:51870 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab3C1TqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:46:17 -0400
Date: Thu, 28 Mar 2013 19:46:16 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] epoll: cleanup: use RCU_INIT_POINTER when nulling
Message-ID: <20130328194616.GA19478@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is always safe to use RCU_INIT_POINTER to NULL a pointer.
This results in slightly smaller/faster code.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Andrew: Sorry for the noise and requiring these cleanups.  Would you
 want a squashed commit with all my RCU+ws-related epoll changes to keep
 history cleaner?  I will try to be more careful and require less
 followup patches in the future :x

 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index dcf7906..1295d3a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1207,7 +1207,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 {
 	struct wakeup_source *ws = ep_wakeup_source(epi);
 
-	rcu_assign_pointer(epi->ws, NULL);
+	RCU_INIT_POINTER(epi->ws, NULL);
 
 	/*
 	 * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
-- 
Eric Wong
