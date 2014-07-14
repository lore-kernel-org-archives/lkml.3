Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaGNEg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:36:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaGNEgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:36:17 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amit Shah <amit.shah@redhat.com>
Subject: [RFC PATCH 2/3] virtio: rng: only accept delayed early randomness requests
Date: Mon, 14 Jul 2014 10:05:20 +0530
Message-Id: <d2e8c74866e002fe8c9ec62c00dc70a75328ecf9.1405277045.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405277045.git.amit.shah@redhat.com>
References: <cover.1405277045.git.amit.shah@redhat.com>
In-Reply-To: <cover.1405277045.git.amit.shah@redhat.com>
References: <cover.1405277045.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hw_random core can ask for initial randomness after a slight delay after
probe() finishes, and we can contribute to system randomness at that
point.  Tell the hw_random core by setting the HWRNG_DELAY_READ_AT_INIT
flag.

CC: Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index d8ffebd..f53f1e8 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -123,6 +123,7 @@ static int probe_common(struct virtio_device *vdev)
 		.cleanup = virtio_cleanup,
 		.priv = (unsigned long)vi,
 		.name = vi->name,
+		.flags = HWRNG_DELAY_READ_AT_INIT,
 	};
 	vdev->priv = vi;
 
-- 
1.9.3

