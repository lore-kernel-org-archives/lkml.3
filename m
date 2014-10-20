Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaJTUUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 16:20:34 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41189 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaJTUUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 16:20:32 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] staging: clocking-wizard: Contain macro argument in parenthesis
Date: Mon, 20 Oct 2014 13:20:08 -0700
Message-Id: <1413836408-29723-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.2.1.g5e69ed6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A macro doing some arithmetic to calculate a register offset, did not
contain an argument to the macro in parentheses, potentially leading to
unexpected results when using that macro with arithmetic expressions as
argument.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
index b8d89525bffd..7202d8e889aa 100644
--- a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
+++ b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
@@ -29,7 +29,7 @@
 #define WZRD_NUM_OUTPUTS	7
 #define WZRD_ACLK_MAX_FREQ	250000000UL
 
-#define WZRD_CLK_CFG_REG(n)	(0x200 + 4 * n)
+#define WZRD_CLK_CFG_REG(n)	(0x200 + 4 * (n))
 
 #define WZRD_CLkOUT0_FRAC_EN	BIT(18)
 #define WZRD_CLkFBOUT_FRAC_EN	BIT(26)
-- 
2.1.2.1.g5e69ed6

