Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaK2SAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:00:30 -0500
Received: from mout.web.de ([212.227.17.11]:55736 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaK2SA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:00:29 -0500
Message-ID: <547A09B1.9090102@users.sourceforge.net>
Date: Sat, 29 Nov 2014 19:00:17 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] net-PA Semi: Deletion of unnecessary checks before the
 function call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:aRR98IbgiXk8XdU7pGoQr+T9x5jBCLBEmvYyl6ETuzuXJ9HgsqW
 dSldPJp3kG8rJEzqt4IjBMnIxHJKdUSHX5yXwxVKvwKlkyU1vXVsBBT9tWG0/KC82jq01iS
 YjR0qhwySWpzud9Cz9BFwyBaflbUlauwSJqTN9tXlehGjrbDQE+BuPVNCag1I6I+HwKfNnk
 4W9MTAehM6BqO84jfniOA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 29 Nov 2014 18:55:40 +0100

The pci_dev_put() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/ethernet/pasemi/pasemi_mac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index 30d934d..44e8d7d 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1837,10 +1837,8 @@ pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return err;
 
 out:
-	if (mac->iob_pdev)
-		pci_dev_put(mac->iob_pdev);
-	if (mac->dma_pdev)
-		pci_dev_put(mac->dma_pdev);
+	pci_dev_put(mac->iob_pdev);
+	pci_dev_put(mac->dma_pdev);
 
 	free_netdev(dev);
 out_disable_device:
-- 
2.1.3

