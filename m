Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3ELSDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 14:03:19 -0400
Received: from smtp-out-237.synserver.de ([212.40.185.237]:1052 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754706Ab3ELSDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 14:03:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 25360
From: Lars-Peter Clausen <lars@metafoo.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] mfd: jz4740-adc: Use clk_prepare_enable/clk_disable_unprepare
Date: Sun, 12 May 2013 20:05:48 +0200
Message-Id: <1368381948-4050-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to switching the jz4740 clk driver to the common clk framework
update the clk enable/disable calls to clk_prepare_enable/clk_disable_unprepare.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/jz4740-adc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index e80587f..a16f698 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -86,13 +86,13 @@ static void jz4740_adc_irq_demux(unsigned int irq, struct irq_desc *desc)
 static inline void jz4740_adc_clk_enable(struct jz4740_adc *adc)
 {
 	if (atomic_inc_return(&adc->clk_ref) == 1)
-		clk_enable(adc->clk);
+		clk_prepare_enable(adc->clk);
 }
 
 static inline void jz4740_adc_clk_disable(struct jz4740_adc *adc)
 {
 	if (atomic_dec_return(&adc->clk_ref) == 0)
-		clk_disable(adc->clk);
+		clk_disable_unprepare(adc->clk);
 }
 
 static inline void jz4740_adc_set_enabled(struct jz4740_adc *adc, int engine,
-- 
1.8.2.1

