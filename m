Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3AOAjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:39:05 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:60587 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3AOAjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:39:02 -0500
From: Cong Ding <dinggnu@gmail.com>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] gpu: drm/nouveau/nouveau_fence.c: remove unnecessary null pointer check
Date: Tue, 15 Jan 2013 01:38:45 +0100
Message-Id: <1358210328-16726-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable sender is dereferenced in line 190, so it is no reason to check
null again in line 198.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index 1d049be..b6b8e49 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -195,11 +195,9 @@ nouveau_fence_new(struct nouveau_channel *chan, struct nouveau_fence **pfence)
 		return -ENOMEM;
 	kref_init(&fence->kref);
 
-	if (chan) {
-		ret = nouveau_fence_emit(fence, chan);
-		if (ret)
-			nouveau_fence_unref(&fence);
-	}
+	ret = nouveau_fence_emit(fence, chan);
+	if (ret)
+		nouveau_fence_unref(&fence);
 
 	*pfence = fence;
 	return ret;
-- 
1.7.10.4

