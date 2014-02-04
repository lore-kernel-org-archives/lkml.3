Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934921AbaBDVNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:13:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933733AbaBDVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Dong Aisheng <b29396@freescale.com>, Chris Ball <chris@printf.net>
Subject: [PATCH 3.13 119/140] mmc: sdhci: add quirk for broken HS200 support
Date: Tue,  4 Feb 2014 13:11:46 -0800
Message-Id: <20140204211040.370317618@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@linux.intel.com>

commit 13868bf20f2f2c305f96e23620b024e167d6f9cb upstream.

This patch defines a quirk for platforms unable to enable HS200 support.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Reviewed-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Acked-by: Dong Aisheng <b29396@freescale.com>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c  |    3 ++-
 include/linux/mmc/sdhci.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3004,7 +3004,8 @@ int sdhci_add_host(struct sdhci_host *ho
 		/* SD3.0: SDR104 is supported so (for eMMC) the caps2
 		 * field can be promoted to support HS200.
 		 */
-		mmc->caps2 |= MMC_CAP2_HS200;
+		if (!(host->quirks2 & SDHCI_QUIRK2_BROKEN_HS200))
+			mmc->caps2 |= MMC_CAP2_HS200;
 	} else if (caps[1] & SDHCI_SUPPORT_SDR50)
 		mmc->caps |= MMC_CAP_UHS_SDR50;
 
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -98,6 +98,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON		(1<<4)
 /* Controller has a non-standard host control register */
 #define SDHCI_QUIRK2_BROKEN_HOST_CONTROL		(1<<5)
+/* Controller does not support HS200 */
+#define SDHCI_QUIRK2_BROKEN_HS200			(1<<6)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */


