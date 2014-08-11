Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaHKSvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:51:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbaHKSvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:51:01 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@linux.intel.com, Rusty Russell <rusty@rustcorp.com.au>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>, jgarzik@bitpay.com, duwe@lst.de,
        Amos Kong <akong@redhat.com>, ricardo.neri-calderon@linux.intel.com,
        tytso@mit.edu, herbert@gondor.apana.org.au,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 1/1] virtio: rng: add derating factor for use by hwrng core
Date: Tue, 12 Aug 2014 00:19:42 +0530
Message-Id: <6f2df652355d6e78da846d06e32489b7d9cdfcc2.1407782982.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The khwrngd thread is started when a hwrng device of sufficient
quality is registered.  The virtio-rng device is backed by the
hypervisor, and we trust the hypervisor to provide real entropy.  A
malicious hypervisor is a scenario that's ruled out, so we are certain
the quality of randomness we receive is perfectly trustworthy.  Hence,
we use 100% for the factor, indicating maximum confidence in the source.

Signed-off-by: Amit Shah <amit.shah@redhat.com>

---
Pretty small and contained patch; would be great if it is picked up for
3.17.
---
 drivers/char/hw_random/virtio-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 0027137..2e3139e 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -116,6 +116,7 @@ static int probe_common(struct virtio_device *vdev)
 		.cleanup = virtio_cleanup,
 		.priv = (unsigned long)vi,
 		.name = vi->name,
+		.quality = 1000,
 	};
 	vdev->priv = vi;
 
-- 
1.9.3

