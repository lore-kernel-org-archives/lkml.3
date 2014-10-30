Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbaJ3L73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:59:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32785 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbaJ3L72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:59:28 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] drm: Fix warning caused by missing description in drm_modeset_lock.h
Date: Thu, 30 Oct 2014 20:59:13 +0900
Message-Id: <1414670353-8198-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.555.gfbecd99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix following warning while "make xmldocs".

Warning(.//include/drm/drm_modeset_lock.h:61): No description
found for parameter 'trylock_only'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 include/drm/drm_modeset_lock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/drm_modeset_lock.h b/include/drm/drm_modeset_lock.h
index 75a5c45..60b2da6 100644
--- a/include/drm/drm_modeset_lock.h
+++ b/include/drm/drm_modeset_lock.h
@@ -33,6 +33,7 @@ struct drm_modeset_lock;
  * @ww_ctx: base acquire ctx
  * @contended: used internally for -EDEADLK handling
  * @locked: list of held locks
+ * @trylock_only: Trylock mode, use only for panic handlers
  *
  * Each thread competing for a set of locks must use one acquire
  * ctx.  And if any lock fxn returns -EDEADLK, it must backoff and
-- 
2.1.2.555.gfbecd99

