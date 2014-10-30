Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbaJ3OAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:00:10 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50722 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760179AbaJ3N7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:59:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 2/3] i2c: core: Dispose OF IRQ mapping at client removal time
Date: Thu, 30 Oct 2014 15:59:37 +0200
Message-Id: <1414677578-27412-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clients instantiated from OF get an IRQ mapping created at device
registration time. Dispose the mapping when the client is removed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/i2c/i2c-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 2f90ac6a7f79..258765b29684 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -670,6 +670,9 @@ static int i2c_device_remove(struct device *dev)
 		status = driver->remove(client);
 	}
 
+	if (dev->of_node)
+		irq_dispose_mapping(client->irq);
+
 	dev_pm_domain_detach(&client->dev, true);
 	return status;
 }
-- 
2.0.4

