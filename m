Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3LNOIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 09:08:19 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41221 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab3LNOIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 09:08:17 -0500
Date: Sat, 14 Dec 2013 19:38:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 1/2] drivers: ata: Mark the function ahci_init_interrupts()
 as static in ahci.c
Message-ID: <81391ee13d565f1db31247dfda803cd7123bb8a9.1387029964.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function ahci_init_interrupts() as static in ahci.c
because it is not used outside this file.

Thus, it also eliminates the following warning in ahci.c:
drivers/ata/ahci.c:1099:5: warning: no previous prototype for ‘ahci_init_interrupts’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/ata/ahci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 14f1e95..4ab1d41 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1097,7 +1097,7 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
-int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv)
+static int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv)
 {
 	int rc;
 	unsigned int maxvec;
-- 
1.7.9.5

