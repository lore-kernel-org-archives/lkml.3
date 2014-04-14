Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaDNA6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 20:58:42 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60318 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaDNA6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 20:58:39 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: fix double unlock bug
Date: Mon, 14 Apr 2014 09:58:35 +0900
Message-ID: <5462835.Vnc4dWZRns@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mutex_unlock() and put_pwq_unlocked() do not need to be called
when alloc_unbound_pwq() is failed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..e6e9f6a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4100,7 +4100,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	if (!pwq) {
 		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
 			   wq->name);
-		goto out_unlock;
+		return;
 	}
 
 	/*
-- 
1.7.4.4


