Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaCZQe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:34:56 -0400
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:53720 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755346AbaCZQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:34:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3866:4321:4605:5007:6114:6642:7652:7875:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: money37_64a6162c6d95a
X-Filterd-Recvd-Size: 4028
Message-ID: <1395851689.3726.23.camel@joe-AO722>
Subject: [PATCH] ata: remove superfluous casts
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 26 Mar 2014 09:34:49 -0700
In-Reply-To: <20140326154230.GG7171@htj.dyndns.org>
References: <11638294.fp3ZK6zVlg@amdc1032>
	 <20140326154230.GG7171@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unreferenced casts of void * types are unnecessary so remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---

Done with coccinelle

 drivers/ata/libahci.c        | 2 +-
 drivers/ata/pata_arasan_cf.c | 2 +-
 drivers/ata/sata_dwc_460ex.c | 3 +--
 drivers/ata/sata_sx4.c       | 9 +++------
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 7985ae7..6bd4f66 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1636,7 +1636,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	}
 
 	if (irq_stat & PORT_IRQ_UNK_FIS) {
-		u32 *unk = (u32 *)(pp->rx_fis + RX_FIS_UNK);
+		u32 *unk = pp->rx_fis + RX_FIS_UNK;
 
 		active_ehi->err_mask |= AC_ERR_HSM;
 		active_ehi->action |= ATA_EH_RESET;
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 73492dd..6fac524 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -356,7 +356,7 @@ static void cf_exit(struct arasan_cf_dev *acdev)
 
 static void dma_callback(void *dev)
 {
-	struct arasan_cf_dev *acdev = (struct arasan_cf_dev *) dev;
+	struct arasan_cf_dev *acdev = dev;
 
 	complete(&acdev->dma_completion);
 }
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 73510d0..0bb2cab 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -461,8 +461,7 @@ static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
 	int chan;
 	u32 tfr_reg, err_reg;
 	unsigned long flags;
-	struct sata_dwc_device *hsdev =
-		(struct sata_dwc_device *)hsdev_instance;
+	struct sata_dwc_device *hsdev = hsdev_instance;
 	struct ata_host *host = (struct ata_host *)hsdev->host;
 	struct ata_port *ap;
 	struct sata_dwc_device_port *hsdevp;
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 6cd0312..39b5de6 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -1020,8 +1020,7 @@ static void pdc20621_get_from_dimm(struct ata_host *host, void *psource,
 	idx++;
 	dist = ((long) (window_size - (offset + size))) >= 0 ? size :
 		(long) (window_size - offset);
-	memcpy_fromio((char *) psource, (char *) (dimm_mmio + offset / 4),
-		      dist);
+	memcpy_fromio(psource, dimm_mmio + offset / 4, dist);
 
 	psource += dist;
 	size -= dist;
@@ -1030,8 +1029,7 @@ static void pdc20621_get_from_dimm(struct ata_host *host, void *psource,
 		readl(mmio + PDC_GENERAL_CTLR);
 		writel(((idx) << page_mask), mmio + PDC_DIMM_WINDOW_CTLR);
 		readl(mmio + PDC_DIMM_WINDOW_CTLR);
-		memcpy_fromio((char *) psource, (char *) (dimm_mmio),
-			      window_size / 4);
+		memcpy_fromio(psource, dimm_mmio, window_size / 4);
 		psource += window_size;
 		size -= window_size;
 		idx++;
@@ -1042,8 +1040,7 @@ static void pdc20621_get_from_dimm(struct ata_host *host, void *psource,
 		readl(mmio + PDC_GENERAL_CTLR);
 		writel(((idx) << page_mask), mmio + PDC_DIMM_WINDOW_CTLR);
 		readl(mmio + PDC_DIMM_WINDOW_CTLR);
-		memcpy_fromio((char *) psource, (char *) (dimm_mmio),
-			      size / 4);
+		memcpy_fromio(psource, dimm_mmio, size / 4);
 	}
 }
 #endif


