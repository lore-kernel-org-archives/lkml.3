Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbbAYLK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 06:10:29 -0500
Received: from www.osadl.org ([62.245.132.105]:39821 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbbAYLKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 06:10:25 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, devel@linuxdriverproject.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 2/3] hyperv: hyperv_fb.c: fixup-of-wait_for_completion_timeout-return-type
Date: Sun, 25 Jan 2015 12:02:28 +0100
Message-Id: <1422183748-7585-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

The return type of wait_for_completion_timeout is unsigned long not
int. This patch fixes up the declarations only.

Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
CONFIG_HYPERV=m, CONFIG_FB_HYPERV=m

Patch is against 3.19.0-rc5 -next-20150123

 drivers/video/fbdev/hyperv_fb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 4254336..807ee22 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -415,7 +415,8 @@ static int synthvid_negotiate_ver(struct hv_device *hdev, u32 ver)
 	struct fb_info *info = hv_get_drvdata(hdev);
 	struct hvfb_par *par = info->par;
 	struct synthvid_msg *msg = (struct synthvid_msg *)par->init_buf;
-	int t, ret = 0;
+	int ret = 0;
+	unsigned long t;
 
 	memset(msg, 0, sizeof(struct synthvid_msg));
 	msg->vid_hdr.type = SYNTHVID_VERSION_REQUEST;
@@ -488,7 +489,8 @@ static int synthvid_send_config(struct hv_device *hdev)
 	struct fb_info *info = hv_get_drvdata(hdev);
 	struct hvfb_par *par = info->par;
 	struct synthvid_msg *msg = (struct synthvid_msg *)par->init_buf;
-	int t, ret = 0;
+	int ret = 0;
+	unsigned long t;
 
 	/* Send VRAM location */
 	memset(msg, 0, sizeof(struct synthvid_msg));
-- 
1.7.10.4

