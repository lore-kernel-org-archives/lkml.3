Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaGVLOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:14:30 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61423 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaGVLLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/19] mfd: ezx-pcap: Repair coding style errors picked up with checkpatch
Date: Tue, 22 Jul 2014 12:11:15 +0100
Message-Id: <1406027485-15657-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: Missing a blank line after declarations
+       u32 flags;
+       void (*callback)(void *, u16[]);

WARNING: sizeof t should be sizeof(t)
+       memset(&t, 0, sizeof t);

WARNING: void function return statements are not generally useful
+       return;
+}

total: 0 errors, 3 warnings, 542 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ezx-pcap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 2ed774e..5a9a35e 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -25,8 +25,9 @@ struct pcap_adc_request {
 	u8 bank;
 	u8 ch[2];
 	u32 flags;
-	void (*callback)(void *, u16[]);
 	void *data;
+
+	void (*callback)(void *, u16[]);
 };
 
 struct pcap_adc_sync_request {
@@ -62,7 +63,7 @@ static int ezx_pcap_putget(struct pcap_chip *pcap, u32 *data)
 	struct spi_message m;
 	int status;
 
-	memset(&t, 0, sizeof t);
+	memset(&t, 0, sizeof(t));
 	spi_message_init(&m);
 	t.len = sizeof(u32);
 	spi_message_add_tail(&t, &m);
@@ -211,7 +212,6 @@ static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 	queue_work(pcap->workqueue, &pcap->isr_work);
-	return;
 }
 
 /* ADC */
-- 
1.8.3.2

