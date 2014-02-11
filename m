Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaBKUcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:32:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaBKTGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.13 091/120] drm/nouveau: fix lock unbalance in nouveau_crtc_page_flip
Date: Tue, 11 Feb 2014 11:05:32 -0800
Message-Id: <20140211184826.205569422@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 09c3de135063f93d7137ad112f551f293b1204cf upstream.

Fixes a regression introduced by d5c1e84b3a130f0
"drm/nouveau: hold mutex while syncing to kernel channel".

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -618,7 +618,7 @@ nouveau_crtc_page_flip(struct drm_crtc *
 	ret = nouveau_fence_sync(fence, chan);
 	nouveau_fence_unref(&fence);
 	if (ret)
-		goto fail_free;
+		goto fail_unpin;
 
 	ret = ttm_bo_reserve(&old_bo->bo, true, false, false, NULL);
 	if (ret)


