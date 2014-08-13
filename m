Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaHMUbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:31:48 -0400
Received: from ozlabs.org ([103.22.144.67]:55980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaHMUbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:31:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: hpa@linux.intel.com, Amos Kong <akong@redhat.com>,
        ricardo.neri-calderon@linux.intel.com, tytso@mit.edu,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH] virtio: rng: add derating factor for use by hwrng core
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 14 Aug 2014 04:39:07 +0930
Message-ID: <87zjf88awc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The khwrngd thread is started when a hwrng device of sufficient
quality is registered.  The virtio-rng device is backed by the
hypervisor, and we trust the hypervisor to provide real entropy.

A malicious hypervisor is a scenario that's irrelevant -- such a setup
is bound to cause all sorts of badness, and a compromised hwrng is not
the biggest threat.

Given this, we are certain the quality of randomness we receive is
perfectly trustworthy.  Hence, we use 100% for the factor, indicating
maximum confidence in the source.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
Pretty small and contained patch; would be great if it is picked up for
3.17.

v2: re-word commit msg

[Agreed, re-sending to Linus with SOB before jumping on plane]
---
 drivers/char/hw_random/virtio-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/virtio-rng.c
b/drivers/char/hw_random/virtio-rng.c
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

