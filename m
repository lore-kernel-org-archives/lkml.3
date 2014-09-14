Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaINQlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:41:35 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:63053 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbaINQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:41:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIOANrEFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfAGBBBd4hAQBBScvIxBROR4ZiEIBqQ2PAxiFfIhtZAcWhDUFnQiMMIkPghuBRTsvgQaBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Fabian Frederick <fabf@skynet.be>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 8/9 linux-next] drm/ast: use container_of to resolve ast_fbdev from drm_fb_helper
Date: Sun, 14 Sep 2014 18:40:21 +0200
Message-Id: <1410712823-29137-9-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410712823-29137-1-git-send-email-fabf@skynet.be>
References: <1410712823-29137-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
Compiled but untested.

 drivers/gpu/drm/ast/ast_fb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index cba45c7..5c60ae5 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -186,7 +186,8 @@ static int astfb_create_object(struct ast_fbdev *afbdev,
 static int astfb_create(struct drm_fb_helper *helper,
 			struct drm_fb_helper_surface_size *sizes)
 {
-	struct ast_fbdev *afbdev = (struct ast_fbdev *)helper;
+	struct ast_fbdev *afbdev =
+		container_of(helper, struct ast_fbdev, helper);
 	struct drm_device *dev = afbdev->helper.dev;
 	struct drm_mode_fb_cmd2 mode_cmd;
 	struct drm_framebuffer *fb;
-- 
1.9.1

