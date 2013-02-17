Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3BQSBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:01:52 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:60730 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3BQR7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:59:54 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 3/9] video: sysfb: always provide vbefb device
Date: Sun, 17 Feb 2013 18:59:05 +0100
Message-Id: <1361123951-587-4-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Herrmann <dh.herrmann@googlemail.com>

HACK: This should be provided by architecture setup code. But to show how it is
supposed to work, we now simply add a "vbefb" device during initialization.

The better way to do this is by moving this into arch-code. So for instance the
x86 boot initialization should create this platform-device after VBE/VESA screen
detection. Other architectures can do the same or introduce other framebuffer
types than SYSFB_VBE.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/video/sysfb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/video/sysfb.c b/drivers/video/sysfb.c
index 5b47a9a..0c0a4e7 100644
--- a/drivers/video/sysfb.c
+++ b/drivers/video/sysfb.c
@@ -271,6 +271,8 @@ static struct platform_driver sysfb_vbe_driver = {
 	.remove = sysfb_vbe_remove,
 };
 
+static struct platform_device *sysfb_vbe_device;
+
 static int __init sysfb_init(void)
 {
 	int ret;
@@ -287,6 +289,12 @@ static int __init sysfb_init(void)
 		goto err_bus;
 	}
 
+	sysfb_vbe_device = platform_device_register_data(NULL, "vbefb", -1,
+							 &screen_info,
+							 sizeof(screen_info));
+	if (!sysfb_vbe_device)
+		pr_warn("cannot create vbefb device\n");
+
 	return 0;
 
 err_bus:
-- 
1.8.1.3

