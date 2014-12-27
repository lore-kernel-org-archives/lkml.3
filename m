Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaL0Phf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:37:35 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:48155 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaL0Phb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:37:31 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjAVAK7RnlRbsnvc/2dsb2JhbABcgwaBKrQbBQEBAQEBAQUBd5cwBAKBCBcBAQEBAX2EOi8jgRo3iDABuTuPIyyGA4kQZB2EEwWXCJFQIoFFgio9MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1 linux-next] drm/gma500: replace 0 by NULL for pointer
Date: Sat, 27 Dec 2014 16:37:24 +0100
Message-Id: <1419694644-2241-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning: 
drivers/gpu/drm/gma500/psb_drv.c:
328:56: warning: Using plain integer as NULL pointer

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/gma500/psb_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index 92e7e57..9b49c155 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -325,7 +325,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long flags)
 	if (ret)
 		goto out_err;
 
-	dev_priv->mmu = psb_mmu_driver_init(dev, 1, 0, 0);
+	dev_priv->mmu = psb_mmu_driver_init(dev, 1, 0, NULL);
 	if (!dev_priv->mmu)
 		goto out_err;
 
-- 
2.1.0

