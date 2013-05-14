Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3ENNmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:42:36 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:54687 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182Ab3ENNmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:42:35 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>
Subject: [PATCH] mfd: db8500-prcmu: Update stored DSI PLL divider value
Date: Tue, 14 May 2013 15:14:55 +0200
Message-ID: <1368537295-23459-1-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

Previously the DSI PLL divider rate was initialised statically and
assumed to be 1. Before the common clock framework were enabled for
ux500, a call to clk_set_rate() would always update the HW registers
no matter what the current setting was.

This patch makes sure the actual hw settings and the sw assumed
settings are matched.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 5389368..66f8097 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1613,6 +1613,8 @@ static unsigned long dsiclk_rate(u8 n)
 
 	if (divsel == PRCM_DSI_PLLOUT_SEL_OFF)
 		divsel = dsiclk[n].divsel;
+	else
+		dsiclk[n].divsel = divsel;
 
 	switch (divsel) {
 	case PRCM_DSI_PLLOUT_SEL_PHI_4:
-- 
1.7.10

