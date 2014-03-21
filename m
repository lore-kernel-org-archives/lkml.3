Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966849AbaCUAm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:42:26 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39351 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965836AbaCUAmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:42:24 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Conrad Meyer <cse.cem@gmail.com>
Subject: [PATCH] Staging: vt6655: Fix sparse-indicated type mismatch to kmalloc
Date: Thu, 20 Mar 2014 17:42:09 -0700
Message-Id: <1395362529-17182-1-git-send-email-cse.cem@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
Patch is against next-20140320. Fixes a minor sparse warning in the staging
driver vt6655. p->length is u16; implicit cast to size_t is fine. No reason to
cast GFP_KERNEL...
---
 drivers/staging/vt6655/wpactl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index d17224f..c27ed5d 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -855,11 +855,11 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 
 	if (p->length < sizeof(struct viawget_wpa_param) ||
 	    p->length > VIAWGET_WPA_MAX_BUF_SIZE || !p->pointer)
 		return -EINVAL;
 
-	param = kmalloc((int)p->length, (int)GFP_KERNEL);
+	param = kmalloc(p->length, GFP_KERNEL);
 	if (param == NULL)
 		return -ENOMEM;
 
 	if (copy_from_user(param, p->pointer, p->length)) {
 		ret = -EFAULT;
-- 
1.8.5.3

