Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbbARTDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:03:01 -0500
Received: from mout.web.de ([212.227.17.12]:57003 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbbARTC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:02:59 -0500
Message-ID: <54BC0359.3090508@users.sourceforge.net>
Date: Sun, 18 Jan 2015 20:02:49 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/2] PCMCIA: Deletion of checks before the function call "iounmap"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BC02D2.8010008@users.sourceforge.net>
In-Reply-To: <54BC02D2.8010008@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:RH0sFYHfaoRqtNfgA3iPtBy3W+oF9xsQTar3EihivZFa7Zaykwc
 n6Po/eDlyYiS7+1387PdcxzDSv9lc8H2rdlsEeC/ZeD1RrwTngXiNgbr5ppqlyc1OI+dgzE
 LxNDPZS9xCw7ZfyrovO/g2sQG+bWLzNAUCxKBkn2kIaNBjA8anY6I0Y31fOLyeCcFsVXnSl
 CLjJodFA1G/Gu7AP+G03w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 18:48:09 +0100

The iounmap() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/pcmcia/bcm63xx_pcmcia.c | 6 ++----
 drivers/pcmcia/cistpl.c         | 3 +--
 drivers/pcmcia/electra_cf.c     | 6 ++----
 drivers/pcmcia/yenta_socket.c   | 3 +--
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/pcmcia/bcm63xx_pcmcia.c b/drivers/pcmcia/bcm63xx_pcmcia.c
index 0802e0b..9e7ad1b 100644
--- a/drivers/pcmcia/bcm63xx_pcmcia.c
+++ b/drivers/pcmcia/bcm63xx_pcmcia.c
@@ -426,10 +426,8 @@ static int bcm63xx_drv_pcmcia_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	if (skt->io_base)
-		iounmap(skt->io_base);
-	if (skt->base)
-		iounmap(skt->base);
+	iounmap(skt->io_base);
+	iounmap(skt->base);
 	if (skt->reg_res)
 		release_mem_region(skt->reg_res->start, regmem_size);
 	kfree(skt);
diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 884a984..662462e 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -115,8 +115,7 @@ static void __iomem *set_cis_map(struct pcmcia_socket *s,
 	}
 
 	if (s->features & SS_CAP_STATIC_MAP) {
-		if (s->cis_virt)
-			iounmap(s->cis_virt);
+		iounmap(s->cis_virt);
 		s->cis_virt = ioremap(mem->static_start, s->map_size);
 	}
 
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 7f9950d..3fb78d6 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -316,10 +316,8 @@ fail1:
 
 	if (cf->io_virt)
 		__iounmap_at(cf->io_virt, cf->io_size);
-	if (cf->mem_base)
-		iounmap(cf->mem_base);
-	if (cf->gpio_base)
-		iounmap(cf->gpio_base);
+	iounmap(cf->mem_base);
+	iounmap(cf->gpio_base);
 	device_init_wakeup(&ofdev->dev, 0);
 	kfree(cf);
 	return status;
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 8a23ccb..5ea1d49 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -802,8 +802,7 @@ static void yenta_close(struct pci_dev *dev)
 	else
 		del_timer_sync(&sock->poll_timer);
 
-	if (sock->base)
-		iounmap(sock->base);
+	iounmap(sock->base);
 	yenta_free_resources(sock);
 
 	pci_release_regions(dev);
-- 
2.2.2

