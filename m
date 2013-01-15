Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab3APAYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:24:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:41948 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201Ab3AOWaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:30:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 084/221] drm/i915: fix flags in dma buf exporting
Date: Tue, 15 Jan 2013 10:50:11 -0800
Message-Id: <20130115185004.109117835@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 5b42427fc38ecb9056c4e64deaff36d6d6ba1b67 upstream.

As pointed out by Seung-Woo Kim this should have been
passing flags like nouveau/radeon have.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_dmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -226,7 +226,7 @@ struct dma_buf *i915_gem_prime_export(st
 {
 	struct drm_i915_gem_object *obj = to_intel_bo(gem_obj);
 
-	return dma_buf_export(obj, &i915_dmabuf_ops, obj->base.size, 0600);
+	return dma_buf_export(obj, &i915_dmabuf_ops, obj->base.size, flags);
 }
 
 static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)


