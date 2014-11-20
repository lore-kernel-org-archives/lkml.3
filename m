Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbaKTM4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:56:09 -0500
Received: from mout.web.de ([212.227.17.12]:62170 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKTM4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:56:06 -0500
Message-ID: <546DE4BB.3000900@users.sourceforge.net>
Date: Thu, 20 Nov 2014 13:55:23 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] MTD: Deletion of unnecessary checks before two function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:HQVUDDxaE4lnDgEy8M8xOqSWPbaAjOgERLO5WHpA6wZcxnvoHzK
 TuoY5UVh+qsvBdj5s3B7hGaZp66dnU5SrzGwzK4qPZpHJYhJK29LJV4S+8nIlkkNgDIIV12
 E6gWxkaxU7OGuT5CPXEhZ5K9P3S4p6r+pb617xedjtBiLYMZQ0WrXgpXfqCXoVVlIGhIGhC
 VSIPnjEMsEqd7DquewP/Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 13:50:43 +0100

The functions kfree() and pci_dev_put() test whether their argument is NULL
and then return immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/mtd/chips/cfi_cmdset_0001.c | 3 +--
 drivers/mtd/devices/pmc551.c        | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 3096f3d..286b97a 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -2654,8 +2654,7 @@ static void cfi_intelext_destroy(struct mtd_info *mtd)
 	kfree(cfi);
 	for (i = 0; i < mtd->numeraseregions; i++) {
 		region = &mtd->eraseregions[i];
-		if (region->lockmap)
-			kfree(region->lockmap);
+		kfree(region->lockmap);
 	}
 	kfree(mtd->eraseregions);
 }
diff --git a/drivers/mtd/devices/pmc551.c b/drivers/mtd/devices/pmc551.c
index f02603e..708b7e8 100644
--- a/drivers/mtd/devices/pmc551.c
+++ b/drivers/mtd/devices/pmc551.c
@@ -812,8 +812,7 @@ static int __init init_pmc551(void)
 	}
 
 	/* Exited early, reference left over */
-	if (PCI_Device)
-		pci_dev_put(PCI_Device);
+	pci_dev_put(PCI_Device);
 
 	if (!pmc551list) {
 		printk(KERN_NOTICE "pmc551: not detected\n");
-- 
2.1.3

