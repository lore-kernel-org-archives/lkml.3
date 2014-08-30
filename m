Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaH3Gwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 02:52:41 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:43748 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaH3Gwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 02:52:40 -0400
From: matwey@sai.msu.ru
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCH] Export handle_fasteoi_irq
Date: Sat, 30 Aug 2014 10:52:20 +0400
Message-Id: <1409381540-4186-1-git-send-email-matwey@sai.msu.ru>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>

handle_fasteoi_irq is required by drivers/gpio/gpio-zynq.c and drivers/gpio/gpio-sodaville.c
We need to export it properly to avoid built issues like:

[30003s] ERROR: "handle_fasteoi_irq" [drivers/gpio/gpio-zynq.ko] undefined!

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 kernel/irq/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a2b28a2..9ce0c5d 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -517,6 +517,7 @@ out:
 		chip->irq_eoi(&desc->irq_data);
 	raw_spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL(handle_fasteoi_irq);
 
 /**
  *	handle_edge_irq - edge type IRQ handler
-- 
1.8.1.4

