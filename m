Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3JKHBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:01:12 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:59938 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab3JKHBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:01:09 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] usb: phy: don't return with NULL from devm_usb_get_phy()
Date: Fri, 11 Oct 2013 09:01:03 +0200
Message-Id: <1381474863-7471-1-git-send-email-juhosg@openwrt.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callers are expecting an ERR_PTR value in case
of an error. Change he code to return with an encoded
-ENOMEM value in the case of a failed devres_alloc call.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/usb/phy/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index a9984c7..1b74523 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -98,7 +98,7 @@ struct usb_phy *devm_usb_get_phy(struct device *dev, enum usb_phy_type type)
 
 	ptr = devres_alloc(devm_usb_phy_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	phy = usb_get_phy(type);
 	if (!IS_ERR(phy)) {
-- 
1.7.10
