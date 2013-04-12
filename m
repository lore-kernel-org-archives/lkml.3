Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab3DNV2E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 17:28:04 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:48301 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3DNV2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 17:28:03 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: usb: gadget: Use ERR_CAST function
Date: Fri, 12 Apr 2013 04:15:37 +0300
Message-Id: <1365729337-24316-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ERR_CAST function instead of ERR_PTR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/usb/gadget/composite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 7c821de..5b73a74 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1138,7 +1138,7 @@ struct usb_string *usb_gstrings_attach(struct usb_composite_dev *cdev,
 
 	uc = copy_gadget_strings(sp, n_gstrings, n_strings);
 	if (IS_ERR(uc))
-		return ERR_PTR(PTR_ERR(uc));
+		return ERR_CAST(uc);
 
 	n_gs = get_containers_gs(uc);
 	ret = usb_string_ids_tab(cdev, n_gs[0]->strings);
-- 
1.7.9.5

