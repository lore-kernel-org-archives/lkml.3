Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaKYKk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaKYKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 046/254] i2c: core: Dispose OF IRQ mapping at client removal time
Date: Tue, 25 Nov 2014 10:36:36 +0000
Message-Id: <1416912004-5928-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit e4df3a0b62285130ac0a35cf07678c154ffb649d upstream.

Clients instantiated from OF get an IRQ mapping created at device
registration time. Dispose the mapping when the client is removed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/i2c-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 7c7f4b856bad..4716eb0bddcd 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -297,6 +297,9 @@ static int i2c_device_remove(struct device *dev)
 		status = driver->remove(client);
 	}
 
+	if (dev->of_node)
+		irq_dispose_mapping(client->irq);
+
 	acpi_dev_pm_detach(&client->dev, true);
 	return status;
 }
-- 
2.1.0

