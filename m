Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbbAMSer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:34:47 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39421 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbbAMSep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:34:45 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau/nvif/notify: Remove unused function
Date: Tue, 13 Jan 2015 19:37:51 +0100
Message-Id: <1421174271-4789-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function nvif_notify_ref() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/nouveau/nvif/notify.c |    9 ---------
 drivers/gpu/drm/nouveau/nvif/notify.h |    1 -
 2 files changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvif/notify.c b/drivers/gpu/drm/nouveau/nvif/notify.c
index 0898c31..d1c26db 100644
--- a/drivers/gpu/drm/nouveau/nvif/notify.c
+++ b/drivers/gpu/drm/nouveau/nvif/notify.c
@@ -219,15 +219,6 @@ nvif_notify_del(struct nvif_notify *notify)
 	kfree(notify);
 }
 
-void
-nvif_notify_ref(struct nvif_notify *notify, struct nvif_notify **pnotify)
-{
-	BUG_ON(notify != NULL);
-	if (*pnotify)
-		(*pnotify)->dtor(*pnotify);
-	*pnotify = notify;
-}
-
 int
 nvif_notify_new(struct nvif_object *object, int (*func)(struct nvif_notify *),
 		bool work, u8 type, void *data, u32 size, u32 reply,
diff --git a/drivers/gpu/drm/nouveau/nvif/notify.h b/drivers/gpu/drm/nouveau/nvif/notify.h
index 9ebfa3b..ea8593e 100644
--- a/drivers/gpu/drm/nouveau/nvif/notify.h
+++ b/drivers/gpu/drm/nouveau/nvif/notify.h
@@ -34,6 +34,5 @@ int  nvif_notify(const void *, u32, const void *, u32);
 int  nvif_notify_new(struct nvif_object *, int (*func)(struct nvif_notify *),
 		     bool work, u8 type, void *data, u32 size, u32 reply,
 		     struct nvif_notify **);
-void nvif_notify_ref(struct nvif_notify *, struct nvif_notify **);
 
 #endif
-- 
1.7.10.4

