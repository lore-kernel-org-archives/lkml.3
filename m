Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3AORT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:19:58 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51525 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab3AORT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:19:57 -0500
Date: Tue, 15 Jan 2013 18:19:49 +0100
From: Cong Ding <dinggnu@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] gpu: drm/nouveau/nouveau_fence.c: remove unnecessary null
 pointer check
Message-ID: <20130115171948.GA7211@gmail.com>
References: <20130115111451.GB27222@gmail.com>
 <1358210328-16726-1-git-send-email-dinggnu@gmail.com>
 <9706.1358246363@warthog.procyon.org.uk>
 <13598.1358269247@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13598.1358269247@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable chan is dereferenced in line 190, so it is no reason to check
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

