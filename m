Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3CDRGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:06:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25938 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3CDRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:06:53 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: pebolle@tiscali.nl, thomas.schlichter@web.de, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] hlist: fix up unintentional hunks
Date: Mon,  4 Mar 2013 12:07:11 -0500
Message-Id: <1362416831-16918-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've probably fucked up when I created the big patch out of all the small
chunks and pulled two hunks that I shouldn't have.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Reported-by: Thomas Schlichter <thomas.schlichter@web.de>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
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
1.8.1.4

