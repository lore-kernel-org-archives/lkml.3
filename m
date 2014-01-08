Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaAHB4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:56:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:51363 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaAHB4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:56:38 -0500
From: Ying Xue <ying.xue@windriver.com>
To: <daniel.vetter@ffwll.ch>
CC: <linux-kernel@vger.kernel.org>, <ying.xue@windriver.com>
Subject: [PATCH] drm/i915: silence compiler warning
Date: Wed, 8 Jan 2014 09:56:31 +0800
Message-ID: <1389146191-2096-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/i915/i915_debugfs.c: In function ‘display_crc_ctl_write’:
drivers/gpu/drm/i915/i915_debugfs.c:2393:2: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]
drivers/gpu/drm/i915/i915_debugfs.c:2350:6: note: ‘val’ was declared here

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 6ed45a9..7963ba5 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -2347,7 +2347,7 @@ static int pipe_crc_set_source(struct drm_device *dev, enum pipe pipe,
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_pipe_crc *pipe_crc = &dev_priv->pipe_crc[pipe];
-	u32 val;
+	u32 val = 0;
 	int ret;
 
 	if (pipe_crc->source == source)
-- 
1.7.9.5

