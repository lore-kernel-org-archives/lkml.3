Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaHUMX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:23:58 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:50443 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaHUMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:56 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rob Clark <robdclark@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] fbdev: Remove __init from chips_hw_init() to fix build failure
Date: Thu, 21 Aug 2014 08:23:57 -0400
Message-Id: <1408623838-8275-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build failure caused as follows:

The function chipsfb_pci_init() references
the function __init chips_hw_init().
This is often because chipsfb_pci_init lacks a __init 
annotation or the annotation of chips_hw_init is wrong.

make: *** [drivers] Error 2

by removing the __init annotation from chips_hw_init(). The other thing that
could have been done was annotating chipsfb_pci_init(). But that cannot be done
since chipsfb_pci_init() is called from non __init functions.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/video/fbdev/chipsfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index 206a66b..59abdc6 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -273,7 +273,7 @@ static struct chips_init_reg chips_init_xr[] = {
 	{ 0xa8, 0x00 }
 };
 
-static void __init chips_hw_init(void)
+static void chips_hw_init(void)
 {
 	int i;
 
-- 
1.9.1

