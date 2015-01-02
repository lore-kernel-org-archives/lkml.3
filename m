Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbbABVB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:01:26 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61989 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbbABVBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:01:24 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: armada: armada_drv:  Remove unused function
Date: Fri,  2 Jan 2015 22:04:25 +0100
Message-Id: <1420232665-3837-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function armada_drm_vbl_event_remove_unlocked() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/armada/armada_drm.h |    2 --
 drivers/gpu/drm/armada/armada_drv.c |   10 ----------
 2 files changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/armada/armada_drm.h b/drivers/gpu/drm/armada/armada_drm.h
index ea63c6c..5f6aef0 100644
--- a/drivers/gpu/drm/armada/armada_drm.h
+++ b/drivers/gpu/drm/armada/armada_drm.h
@@ -46,8 +46,6 @@ void armada_drm_vbl_event_add(struct armada_crtc *,
 	struct armada_vbl_event *);
 void armada_drm_vbl_event_remove(struct armada_crtc *,
 	struct armada_vbl_event *);
-void armada_drm_vbl_event_remove_unlocked(struct armada_crtc *,
-	struct armada_vbl_event *);
 #define armada_drm_vbl_event_init(_e, _f, _d) do {	\
 	struct armada_vbl_event *__e = _e;		\
 	INIT_LIST_HEAD(&__e->node);			\
diff --git a/drivers/gpu/drm/armada/armada_drv.c b/drivers/gpu/drm/armada/armada_drv.c
index 908e531..f862bae 100644
--- a/drivers/gpu/drm/armada/armada_drv.c
+++ b/drivers/gpu/drm/armada/armada_drv.c
@@ -253,16 +253,6 @@ void armada_drm_vbl_event_remove(struct armada_crtc *dcrtc,
 	}
 }
 
-void armada_drm_vbl_event_remove_unlocked(struct armada_crtc *dcrtc,
-	struct armada_vbl_event *evt)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dcrtc->irq_lock, flags);
-	armada_drm_vbl_event_remove(dcrtc, evt);
-	spin_unlock_irqrestore(&dcrtc->irq_lock, flags);
-}
-
 /* These are called under the vbl_lock. */
 static int armada_drm_enable_vblank(struct drm_device *dev, int crtc)
 {
-- 
1.7.10.4

