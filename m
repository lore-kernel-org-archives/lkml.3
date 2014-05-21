Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaEUTfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:35:41 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50237 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283AbaEUTfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:35:39 -0400
Message-ID: <1400700937.30334.2.camel@x220>
Subject: [PATCH] sata_fsl: remove check for CONFIG_MPC8315_DS
From: Paul Bolle <pebolle@tiscali.nl>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 21:35:37 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2014 19:35:38.0246 (UTC) FILETIME=[D7D9EA60:01CF752B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_MPC8315_DS was added in v2.6.24. But the related
Kconfig symbol was never added to the tree. So the code behind this
check has effectively been dead for over six years. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/ata/sata_fsl.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index fb0b40a191c2..3f316d61a9d8 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -774,20 +774,6 @@ static int sata_fsl_port_start(struct ata_port *ap)
 	VPRINTK("HControl = 0x%x\n", ioread32(hcr_base + HCONTROL));
 	VPRINTK("CHBA  = 0x%x\n", ioread32(hcr_base + CHBA));
 
-#ifdef CONFIG_MPC8315_DS
-	/*
-	 * Workaround for 8315DS board 3gbps link-up issue,
-	 * currently limit SATA port to GEN1 speed
-	 */
-	sata_fsl_scr_read(&ap->link, SCR_CONTROL, &temp);
-	temp &= ~(0xF << 4);
-	temp |= (0x1 << 4);
-	sata_fsl_scr_write(&ap->link, SCR_CONTROL, temp);
-
-	sata_fsl_scr_read(&ap->link, SCR_CONTROL, &temp);
-	dev_warn(dev, "scr_control, speed limited to %x\n", temp);
-#endif
-
 	return 0;
 }
 
-- 
1.9.0

