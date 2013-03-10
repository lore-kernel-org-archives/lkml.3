Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3CJMXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:23:16 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58251 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3CJMXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:23:15 -0400
From: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, linux-kernel@vger.kernel.org,
        Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Subject: [PATCH] gpu: don't cast kzalloc() return value
Date: Sun, 10 Mar 2013 14:22:48 +0200
Message-Id: <1362918168-20271-1-git-send-email-mihneadb@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index df08e81..5300526 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -451,7 +451,7 @@ static bool intel_sdvo_write_cmd(struct intel_sdvo *intel_sdvo, u8 cmd,
 	int i, ret = true;
 
         /* Would be simpler to allocate both in one go ? */        
-	buf = (u8 *)kzalloc(args_len * 2 + 2, GFP_KERNEL);
+	buf = kzalloc(args_len * 2 + 2, GFP_KERNEL);
 	if (!buf)
 		return false;
 
-- 
1.7.10.4

