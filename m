Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3F0Opz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:45:55 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63653 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3F0Opx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:45:53 -0400
From: Naresh Bhat <naresh.bhat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        nico@fluxnic.net, dnevil@snmc.com, pc@denkart.be, erik@vt.edu,
        nicolas.pitre@linaro.org, naresh.bhat@linaro.org
Subject: [PATCH 3/3] smc91x: Fix cast from pointer to integer
Date: Thu, 27 Jun 2013 20:14:42 +0530
Message-Id: <1372344282-6608-1-git-send-email-naresh.bhat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fix the following warning which is occured
while compiling the kernel for aarch64 bit architecture

  CC      drivers/net/ethernet/smsc/smc91x.o
drivers/net/ethernet/smsc/smc91x.c: In function ‘smc_probe’:
drivers/net/ethernet/smsc/smc91x.c:1901:7: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
---
 drivers/net/ethernet/smsc/smc91x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 591650a..1011ecc 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -1898,7 +1898,7 @@ static int smc_probe(struct net_device *dev, void __iomem *ioaddr,
 	SMC_SELECT_BANK(lp, 1);
 	val = SMC_GET_BASE(lp);
 	val = ((val & 0x1F00) >> 3) << SMC_IO_SHIFT;
-	if (((unsigned int)ioaddr & (0x3e0 << SMC_IO_SHIFT)) != val) {
+	if (((unsigned long)ioaddr & (0x3e0 << SMC_IO_SHIFT)) != val) {
 		printk("%s: IOADDR %p doesn't match configuration (%x).\n",
 			CARDNAME, ioaddr, val);
 	}
-- 
1.7.9.5

