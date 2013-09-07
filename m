Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855Ab3IGFCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 01:02:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49569 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802Ab3IGFCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 01:02:13 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org, libo.chen@huawei.com,
        gregkh@linuxfoundation.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] gdrom: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 07:02:06 +0200
Message-Id: <1378530126-2995-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from
drivers/cdrom/gdrom.c.

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/cdrom/gdrom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 5980cb9..51e75ad 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -561,11 +561,11 @@ static int gdrom_set_interrupt_handlers(void)
 	int err;
 
 	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt,
-		IRQF_DISABLED, "gdrom_command", &gd);
+		0, "gdrom_command", &gd);
 	if (err)
 		return err;
 	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt,
-		IRQF_DISABLED, "gdrom_dma", &gd);
+		0, "gdrom_dma", &gd);
 	if (err)
 		free_irq(HW_EVENT_GDROM_CMD, &gd);
 	return err;
-- 
1.8.1.2

