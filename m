Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaGULtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:49:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbaGULqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:46:54 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amos Kong <akong@redhat.com>, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 2/4] virtio: rng: re-arrange struct elements for better packing
Date: Mon, 21 Jul 2014 17:15:50 +0530
Message-Id: <9ffa7e1b77b9d6fd5b5e736bc02a2e2db62aede1.1405942162.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405942162.git.amit.shah@redhat.com>
References: <cover.1405942162.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405942162.git.amit.shah@redhat.com>
References: <cover.1405942162.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-arrange the elements of the virtrng_info struct to pack it better.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index d8ffebd..a156284 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -30,11 +30,11 @@ static DEFINE_IDA(rng_index_ida);
 struct virtrng_info {
 	struct hwrng hwrng;
 	struct virtqueue *vq;
-	unsigned int data_avail;
 	struct completion have_data;
-	bool busy;
 	char name[25];
+	unsigned int data_avail;
 	int index;
+	bool busy;
 };
 
 static bool probe_done;
-- 
1.9.3

