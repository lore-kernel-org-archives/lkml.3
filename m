Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaLAFMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 00:12:30 -0500
Received: from mout.web.de ([212.227.17.12]:64736 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaLAFM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 00:12:29 -0500
Message-ID: <547BF8B5.309@users.sourceforge.net>
Date: Mon, 01 Dec 2014 06:12:21 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] DMA: Delete a check before free_percpu()
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:jsrl7snAqSR+f0q0wROjCtMH4cLeFJPOyymOPvsUY7iKbYF+e+r
 32ahMDqQMoRC2elHmw3KrVfwFxL7cTNw7R/a6PtrUJQ4SpPd1DoSLB6bhyh8/GfndwV6vOZ
 YXz+n/PcV3wuCaQvAwYfh9uk0XNvwVn+OP+vSTbKk8PKo1hmVAelJtCxPFxlih4xzKz8jg2
 6Fxn7iAqoXqxHcfyVLXKg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Dec 2014 06:06:57 +0100

The free_percpu() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/dma/dmaengine.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 24bfaf0..e057935 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -330,8 +330,7 @@ static int __init dma_channel_table_init(void)
 	if (err) {
 		pr_err("initialization failure\n");
 		for_each_dma_cap_mask(cap, dma_cap_mask_all)
-			if (channel_table[cap])
-				free_percpu(channel_table[cap]);
+			free_percpu(channel_table[cap]);
 	}
 
 	return err;
-- 
2.1.3

