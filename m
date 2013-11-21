Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3KUPba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:31:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46802 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab3KUPb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:31:29 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH] clk: keystone: gate: don't use reserved bits
Date: Thu, 21 Nov 2013 17:30:51 +0200
Message-ID: <1385047851-14407-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to TRM http://www.ti.com/lit/ug/sprugv4b/sprugv4b.pdf
the Power Domain Status Register (PDSTAT) has 0-1 bits for power
domain status, but PDSTAT_STATE_MASK is defined with 0x1F. In that
case we operate with reserved bits. So correct PDSTAT_STATE_MASK
to be 0x03.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/clk/keystone/gate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
index 1f333bc..995ae80 100644
--- a/drivers/clk/keystone/gate.c
+++ b/drivers/clk/keystone/gate.c
@@ -35,7 +35,7 @@
 
 #define MDSTAT_STATE_MASK	0x3f
 #define MDSTAT_MCKOUT		BIT(12)
-#define PDSTAT_STATE_MASK	0x1f
+#define PDSTAT_STATE_MASK	0x03
 #define MDCTL_FORCE		BIT(31)
 #define MDCTL_LRESET		BIT(8)
 #define PDCTL_NEXT		BIT(0)
-- 
1.7.9.5

