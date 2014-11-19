Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaKSPHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:07:13 -0500
Received: from mout.web.de ([212.227.15.14]:57766 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbaKSPHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:07:11 -0500
Message-ID: <546CB20D.4070808@users.sourceforge.net>
Date: Wed, 19 Nov 2014 16:06:53 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tim Small <tim@buttersideup.com>, linux-edac@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] EDAC: Deletion of unnecessary checks before the function
 call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:4XM5H7YrU7gIVdE964AkFvxxCVmZhBgYmMXfMr11wxUDa1KxRxs
 OIzNEjwd5BliM6lQWS3gdrlMx8uPF4BPfHeB2/1QP5OA9QA+BuRsPnHeEuwRJO/3hi+OnrC
 FdpVoAh2R2Gp8HSEuqQKr+Yti4zhVK3FyVE/j0SdWKhaTHSXtDf4r29Xhw/WY6VKAeiBLaf
 7CvLswQYrE8dW/TDzlo4g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 16:00:13 +0100

The pci_dev_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/edac/i3000_edac.c      | 3 +--
 drivers/edac/i3200_edac.c      | 3 +--
 drivers/edac/i82443bxgx_edac.c | 3 +--
 drivers/edac/x38_edac.c        | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index cd28b96..5cb36a6 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -542,8 +542,7 @@ fail1:
 	pci_unregister_driver(&i3000_driver);
 
 fail0:
-	if (mci_pdev)
-		pci_dev_put(mci_pdev);
+	pci_dev_put(mci_pdev);
 
 	return pci_rc;
 }
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index aa98b13..4ad062b 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -523,8 +523,7 @@ fail1:
 	pci_unregister_driver(&i3200_driver);
 
 fail0:
-	if (mci_pdev)
-		pci_dev_put(mci_pdev);
+	pci_dev_put(mci_pdev);
 
 	return pci_rc;
 }
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index d730e276..b4705d9 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -458,8 +458,7 @@ static void __exit i82443bxgx_edacmc_exit(void)
 	if (!i82443bxgx_registered)
 		i82443bxgx_edacmc_remove_one(mci_pdev);
 
-	if (mci_pdev)
-		pci_dev_put(mci_pdev);
+	pci_dev_put(mci_pdev);
 }
 
 module_init(i82443bxgx_edacmc_init);
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index e644b52..7c5cdc6 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -500,8 +500,7 @@ fail1:
 	pci_unregister_driver(&x38_driver);
 
 fail0:
-	if (mci_pdev)
-		pci_dev_put(mci_pdev);
+	pci_dev_put(mci_pdev);
 
 	return pci_rc;
 }
-- 
2.1.3

