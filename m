Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3JSGOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:14:10 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:11113 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750944Ab3JSGOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:14:09 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 24/29] tg3: Make use of pcim_enable_msix() interface
Date: Fri, 18 Oct 2013 19:12:24 +0200
Message-Id: <f9d5501750bbe2c1e70418210f375698484b4979.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/broadcom/tg3.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 12d961c..026c371 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -11262,12 +11262,10 @@ static bool tg3_enable_msix(struct tg3 *tp)
 		msix_ent[i].vector = 0;
 	}
 
-	rc = pci_enable_msix(tp->pdev, msix_ent, tp->irq_cnt);
+	rc = pcim_enable_msix(tp->pdev, msix_ent, tp->irq_cnt);
 	if (rc < 0) {
 		return false;
-	} else if (rc != 0) {
-		if (pci_enable_msix(tp->pdev, msix_ent, rc))
-			return false;
+	} else if (rc < tp->irq_cnt) {
 		netdev_notice(tp->dev, "Requested %d MSI-X vectors, received %d\n",
 			      tp->irq_cnt, rc);
 		tp->irq_cnt = rc;
-- 
1.7.7.6

