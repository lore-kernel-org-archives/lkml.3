Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaFZHOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:14:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48767 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbaFZHOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:14:02 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V4 11/16] irqchip: crossbar: Set cb pointer to null in case of error
Date: Thu, 26 Jun 2014 12:40:29 +0530
Message-ID: <1403766634-18543-12-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If crossbar_of_init returns with a error, then set the cb pointer
to null.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/irqchip/irq-crossbar.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index afc35fd..a8c6156 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -250,6 +250,8 @@ err_base:
 	iounmap(cb->crossbar_base);
 err_cb:
 	kfree(cb);
+
+	cb = NULL;
 	return ret;
 }
 
-- 
1.7.9.5

