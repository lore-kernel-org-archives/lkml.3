Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaEAAhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:37:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51402 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaEAAhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:37:18 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 RFC 13/15] hwspinlock/omap: use OF helper to get reserved locks
Date: Wed, 30 Apr 2014 19:34:34 -0500
Message-ID: <1398904476-26200-14-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retrieve the number of reserved locks for OMAP by using the
of_hwspin_lock_get_num_reserved_locks() OF helper function
provided by the hwspinlock core. The range sanity check will
be performed by the hwspinlock core during the registration.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/hwspinlock/omap_hwspinlock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 1d0c78e..0dad783 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -143,6 +143,12 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
 		hwlock->priv = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
 
+	reserved_locks = of_hwspin_lock_get_num_reserved_locks(node);
+	if (reserved_locks < 0) {
+		ret = -EINVAL;
+		goto iounmap_base;
+	}
+
 	ret = hwspin_lock_register(bank, &pdev->dev, &omap_hwspinlock_ops,
 					base_id, num_locks, reserved_locks);
 	if (ret)
-- 
1.9.2

