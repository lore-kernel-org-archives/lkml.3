Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3JFFIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 01:08:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51056 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751182Ab3JFFIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 01:08:50 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: rafael.j.wysocki@intel.com, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] PNP: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 07:08:36 +0200
Message-Id: <1381036116-10167-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/pnp/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index d95e101..7a7f383 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -385,7 +385,7 @@ int pnp_check_irq(struct pnp_dev *dev, struct resource *res)
 	 * device is active because it itself may be in use */
 	if (!dev->active) {
 		if (request_irq(*irq, pnp_test_handler,
-				IRQF_DISABLED | IRQF_PROBE_SHARED, "pnp", NULL))
+				IRQF_PROBE_SHARED, "pnp", NULL))
 			return 0;
 		free_irq(*irq, NULL);
 	}
-- 
1.8.1.2

