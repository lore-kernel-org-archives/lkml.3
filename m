Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3APQvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:51:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36089 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab3APQDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 092/222] bcma: mips: fix clearing device IRQ
Date: Wed, 16 Jan 2013 13:54:52 -0200
Message-Id: <1358351822-7675-93-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

commit cbbc0138efe1dcd5426b8fc5d87741f5057aee72 upstream.

We were using wrong IRQ number so clearing wasn't working at all.
Depending on a platform this could result in a one device having two
interrupts assigned. On BCM4706 this resulted in all IRQs being broken.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/bcma/driver_mips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index c3e9dff..041fddf 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -115,7 +115,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) &
 			    ~(1 << irqflag));
 	else
-		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq), 0);
+		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(oldirq), 0);
 
 	/* assign the new one */
 	if (irq == 0) {
-- 
1.7.9.5

