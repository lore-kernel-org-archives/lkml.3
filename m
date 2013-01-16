Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3APQGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab3APQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@linux.intel.com>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 144/222] ne2000: add the right platform device
Date: Wed, 16 Jan 2013 13:55:44 -0200
Message-Id: <1358351822-7675-145-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit da9da01d9199b5bb15289d0859053c9aa3a34ac0 upstream.

Without this udev doesn't have a way to key the ne device to the platform
device.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/8390/ne.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index d04911d..47618e5 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -813,6 +813,7 @@ static int __init ne_drv_probe(struct platform_device *pdev)
 		dev->irq = irq[this_dev];
 		dev->mem_end = bad[this_dev];
 	}
+	SET_NETDEV_DEV(dev, &pdev->dev);
 	err = do_ne_probe(dev);
 	if (err) {
 		free_netdev(dev);
-- 
1.7.9.5

