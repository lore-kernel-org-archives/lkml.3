Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaEONWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:22:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40420 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEONWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:22:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: rusty@rustcorp.com.au
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        akong@redhat.com, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 1/2] virtio-rng: fix boot with virtio-rng device
Date: Thu, 15 May 2014 09:21:43 -0400
Message-Id: <1400160104-1888-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "virtio-rng: support multiple virtio-rng devices" has broken
boot with a virtio-rng device because the 'init' callback of the
virtio-rng device was left unitialized to garbage, and got called
by the hwrng infrastructure, killing the guest on boot.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---

Also, do we really need multiple virtio-rng devices? I know it's
nice to have, but if there isn't a solid use-case behind it we're
just adding bugs to working code without any benefit.


 drivers/char/hw_random/virtio-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 12e242b..5b25daa 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -95,7 +95,7 @@ static int probe_common(struct virtio_device *vdev)
 	int err, i;
 	struct virtrng_info *vi = NULL;
 
-	vi = kmalloc(sizeof(struct virtrng_info), GFP_KERNEL);
+	vi = kzalloc(sizeof(struct virtrng_info), GFP_KERNEL);
 	vi->hwrng.name = kmalloc(40, GFP_KERNEL);
 	init_completion(&vi->have_data);
 
-- 
1.7.10.4

