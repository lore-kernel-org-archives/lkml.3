Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3ITDKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 23:10:33 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:55950 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753987Ab3ITDKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 23:10:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:857:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:4321:4384:5007:7652:10004:10400:10848:11026:11658:11914:12438:12517:12519:12555:12731:12737:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: voice73_593d8347d550a
X-Filterd-Recvd-Size: 2277
Message-ID: <1379646611.2021.7.camel@joe-AO722>
Subject: [PATCH 2/2] framebuffer: Fix int cast to pointer warnings
From: Joe Perches <joe@perches.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Sep 2013 20:10:11 -0700
In-Reply-To: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casts of int to pointer need additional casts to (unsigned long)
when compiled for x86-64 to silence the compiler.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/arkfb.c    | 2 +-
 drivers/video/vt8623fb.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
index b13f3f2..26fd4e4 100644
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -1016,7 +1016,7 @@ static int ark_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *)(unsigned long)vga_res.start;
 
 	/* FIXME get memsize */
 	regval = vga_rseq(par->state.vgabase, 0x10);
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index 7e97c53..281d41b 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -731,7 +731,7 @@ static int vt8623_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *)(unsigned long)vga_res.start;
 
 	/* Find how many physical memory there is on card */
 	memsize1 = (vga_rseq(par->state.vgabase, 0x34) + 1) >> 1;


