Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3AOAe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:34:59 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:60755 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab3AOAe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:34:57 -0500
From: Cong Ding <dinggnu@gmail.com>
To: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Alan Cox <alan@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] gpu: drm/gma500/mdfld_dsi_pkg_sender.c: remove unnecessary null pointer check
Date: Tue, 15 Jan 2013 01:34:21 +0100
Message-Id: <1358210067-16644-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable sender is dereferenced in line 536, so it is no reason to
check null again in line 541.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c b/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
index 489ffd2..823854a 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
@@ -538,7 +538,7 @@ static int __read_panel_data(struct mdfld_dsi_pkg_sender *sender, u8 data_type,
 	u32 gen_data_reg;
 	int retry = MDFLD_DSI_READ_MAX_COUNT;
 
-	if (!sender || !data_out || !len_out) {
+	if (!data_out || !len_out) {
 		DRM_ERROR("Invalid parameters\n");
 		return -EINVAL;
 	}
-- 
1.7.10.4

