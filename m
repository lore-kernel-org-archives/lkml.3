Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaCEFJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 00:09:54 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46268 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275AbaCEFJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 00:09:52 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] [SCSI] NCR5380: remove deprecated IRQF_DISABLED
Date: Wed,  5 Mar 2014 06:09:41 +0100
Message-Id: <1393996181-3425-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386582290-4755-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386582290-4755-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the use of the IRQF_DISABLED flag
from drivers/scsi/NCR5380.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 1e9d6ad9302b..bcd223868227 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -584,7 +584,7 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 	NCR5380_setup(instance);
 
 	for (trying_irqs = i = 0, mask = 1; i < 16; ++i, mask <<= 1)
-		if ((mask & possible) && (request_irq(i, &probe_intr, IRQF_DISABLED, "NCR-probe", NULL) == 0))
+		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
 			trying_irqs |= mask;
 
 	timeout = jiffies + (250 * HZ / 1000);
-- 
1.8.3.2

