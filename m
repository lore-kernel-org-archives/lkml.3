Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3CEWRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:17:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61829 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3CEWRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:17:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/9] Revert parts of "hlist: drop the node parameter from iterators"
Date: Tue,  5 Mar 2013 23:16:42 +0100
Message-Id: <1362521809-22989-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362521809-22989-1-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:lPeZKYaMpe7IXYkmOdPt8tFf3tZRiV7//Mc+TqnK5+O
 0NYcQ8WIDg6uKnZC6kiFk/0vGAQhXZYJFQqQx1+kwzQ1DmyueI
 4G/wgQRPoHW+32Fst1P1A66E+scgQ4D/0ktmph4F9gG/vzWHdl
 4oCjO5lJT2WIU41nSmZs0/rfJ5NEfbeMeo8Eeb/ctyOjZ2doxk
 xWc4yTe99wNDO+K07mM5Gltn2mQaIqsF8rqkDT6pR6Hm2EM8p5
 DtHEdPV/POmfs8gTxJZ6ZSyMq3VkR9VxxG40neVK+HyRwtCLzN
 iGwjUImLzptF+b6k/c/PQWP7lvn0lW/qUJRoPdUewR5LnTGiu+
 jWQ62p1xZJEs9pBj24cjcywSznrGVPJjzO4N1j2xW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b67bfe0d42 "hlist: drop the node parameter from iterators"
did a lot of nice changes but also contains two small hunks that
seem to have slipped in accidentally and have no apparent
connection to the intent of the patch.

This reverts the two extraneous changes.

Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/smpboot.c      | 2 +-
 net/9p/trans_virtio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index b9bde57..d4abac2 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -131,7 +131,7 @@ static int smpboot_thread_fn(void *data)
 			continue;
 		}
 
-		//BUG_ON(td->cpu != smp_processor_id());
+		BUG_ON(td->cpu != smp_processor_id());
 
 		/* Check for state change setup */
 		switch (td->status) {
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 74dea37..de2e950 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -655,7 +655,7 @@ static struct p9_trans_module p9_virtio_trans = {
 	.create = p9_virtio_create,
 	.close = p9_virtio_close,
 	.request = p9_virtio_request,
-	//.zc_request = p9_virtio_zc_request,
+	.zc_request = p9_virtio_zc_request,
 	.cancel = p9_virtio_cancel,
 	/*
 	 * We leave one entry for input and one entry for response
-- 
1.8.1.2

