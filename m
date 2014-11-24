Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaKXVE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:04:29 -0500
Received: from mout.web.de ([212.227.17.12]:61397 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaKXVE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:04:27 -0500
Message-ID: <54739D50.5060104@users.sourceforge.net>
Date: Mon, 24 Nov 2014 22:04:16 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>, Mattia Dongili <malattia@linux.it>,
        platform-driver-x86@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] Sony-laptop: Deletion of an unnecessary check before
 the function call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:P1lcVK7uapk/ftH9BCEfScX6MGp3DlZ4dVkMtXAG8iKJCf3N9KG
 A7yJ/Z40EGaoxzQS6mrV/gr5koDELYXIYkfdUZyuMW9YZHEStDELCo0g+wFfOoCaAzQ1Iie
 T6aMLBLWntKteLWZ36NMBYqxveemxJK1UTKW9aJdAPRNlalG1L19CU3gZB3Leu41vWreAT5
 kcRzrHmJDUaC0FqPjUe0A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 22:00:21 +0100

The pci_dev_put() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/platform/x86/sony-laptop.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 26ad9ff..22b173d 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -3717,8 +3717,7 @@ static void sony_pic_detect_device_type(struct sony_pic_dev *dev)
 	dev->event_types = type2_events;
 
 out:
-	if (pcidev)
-		pci_dev_put(pcidev);
+	pci_dev_put(pcidev);
 
 	pr_info("detected Type%d model\n",
 		dev->model == SONYPI_DEVICE_TYPE1 ? 1 :
-- 
2.1.3

