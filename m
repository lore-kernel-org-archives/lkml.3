Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbbAYOzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:55:44 -0500
Received: from www.osadl.org ([62.245.132.105]:41024 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbbAYOzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:55:42 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, Jiri Kosina <jkosina@suse.cz>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 3/3 v2] hyperv: hid-hyperv.c: match wait_for_completion_timeout return type
Date: Sun, 25 Jan 2015 15:47:47 +0100
Message-Id: <1422197267-8001-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

v2: fixed subject line

The return type of wait_for_completion_timeout is unsigned long not
int. This patch fixes up the declarations only.

Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
CONFIG_HYPERV=m, CONFIG_HID_HYPERV_MOUSE=m

Patch is against 3.19.0-rc5 -next-20150123

 drivers/hid/hid-hyperv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 31fad64..6039f07 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -381,7 +381,7 @@ static void mousevsc_on_channel_callback(void *context)
 static int mousevsc_connect_to_vsp(struct hv_device *device)
 {
 	int ret = 0;
-	int t;
+	unsigned long t;
 	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
 	struct mousevsc_prt_msg *request;
 	struct mousevsc_prt_msg *response;
-- 
1.7.10.4

