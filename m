Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbaKTTns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:43:48 -0500
Received: from mout.web.de ([212.227.17.11]:63018 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbaKTTnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:43:47 -0500
Message-ID: <546E441B.7040004@users.sourceforge.net>
Date: Thu, 20 Nov 2014 20:42:19 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "James E. J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] SCSI-eata_pio: Deletion of an unnecessary check before
 the function call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ButwcOmAY+h8/fV6rqKOMR2gSYbwVe9DYYg+2BAo+yhmYqZccg5
 x46eN+UE4ogX5b8LU30WV8OE6FHcKW0ZOUOpoFBoqFWTEdPMChV7E0C+4+vqkM2Kub1Gela
 GGa1l5fygYNQIYjU1DigkB3cFdS8fe8vyk4KwDD9pUvgBvbZkeq3DHFfY55y5UAIrWOFWhb
 dM97/zliWlzpyLMYbRBsA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 20:37:30 +0100

The pci_dev_put() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/eata_pio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 8319d2b..707f64d 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -122,8 +122,7 @@ static int eata_pio_release(struct Scsi_Host *sh)
 			release_region(sh->io_port, sh->n_io_port);
 	}
 	/* At this point the PCI reference can go */
-	if (hd->pdev)
-		pci_dev_put(hd->pdev);
+	pci_dev_put(hd->pdev);
 	return 1;
 }
 
-- 
2.1.3

