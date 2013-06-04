Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3FDOoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:44:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33792 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754414Ab3FDOoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:44:20 -0400
From: Joe Perches <joe@perches.com>
To: Laurent Vivier <laurent@lvivier.info>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] swim: Release memory region after incorrect return/goto
Date: Tue,  4 Jun 2013 07:44:17 -0700
Message-Id: <60123fd3175b7cceadf6c335b12e58b797e18f65.1370356776.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code uses

	return foo;
	goto err_type;

when instead the form should have been

	ret = foo;
	goto err_type;

Here this causes a useful release_mem_region to be skipped.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/swim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 2f445b7..8ed6ccb 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -893,7 +893,7 @@ static int swim_probe(struct platform_device *dev)
 
 	swim_base = ioremap(res->start, resource_size(res));
 	if (!swim_base) {
-		return -ENOMEM;
+		ret = -ENOMEM;
 		goto out_release_io;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

