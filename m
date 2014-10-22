Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaJVSAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:00:30 -0400
Received: from mout.web.de ([212.227.15.14]:57451 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbaJVSA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:00:29 -0400
Message-ID: <5447F0B1.9010707@users.sourceforge.net>
Date: Wed, 22 Oct 2014 20:00:17 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?J=F6rg_R=F6del?= <joro@8bytes.org>,
        iommu@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] IOMMU-MSM: Deletion of unnecessary checks before
 the function call "clk_disable"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:eWoq36gLgBqf8kCOhKY1Q8pFWbxuHO8itOSjbh6+D4DNPOkD8cP
 Tmm8Ysnehp8rweznq3WfY0flhBoRiB6mZNeENHTUdD+5BjiGF0RsfobmoVF363fwuEoDCd6
 nLdtQIChBhqn1hrVXic/tivqwO6Y7lR1eZYo2wPEM4HXL9Fe3mPytREL74a2bBQzLXQ9eL1
 UIbwqKH6S3+wfveFjEBRg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you are convinced that dropping the null tests is a good idea, then you 
>> can submit the patch that makes the change to the relevant maintainers and 
>> mailing lists.

>From af73fb59d5d4b2c2890000fb236d0752522b6b38 Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 22 Oct 2014 19:39:21 +0200
Subject: [PATCH] IOMMU-MSM: Deletion of unnecessary checks before the function
 call "clk_disable"

A semantic patch approach was proposed with the subject "[PATCH with
Coccinelle?] Deletion of unnecessary checks before specific function calls"
on 2014-03-05.
https://lkml.org/lkml/2014/3/5/344
http://article.gmane.org/gmane.comp.version-control.coccinelle/3513/

This patch pattern application was repeated with the help of the software
"Coccinelle 1.0.0-rc22" on the source files for Linux 3.17.1. An extract
of the automatically generated update suggestions is shown here.

It was determined that the affected source code places call functions
which perform input parameter validation already. It is therefore not
needed that a similar safety check is repeated at the call site.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/iommu/msm_iommu.c     | 3 +--
 drivers/iommu/msm_iommu_dev.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 6e3dcc28..3e4d888 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -73,8 +73,7 @@ fail:

 static void __disable_clocks(struct msm_iommu_drvdata *drvdata)
 {
-	if (drvdata->clk)
-		clk_disable(drvdata->clk);
+	clk_disable(drvdata->clk);
 	clk_disable(drvdata->pclk);
 }

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 61def7cb..9574d21 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -224,8 +224,7 @@ static int msm_iommu_probe(struct platform_device *pdev)

 	platform_set_drvdata(pdev, drvdata);

-	if (iommu_clk)
-		clk_disable(iommu_clk);
+	clk_disable(iommu_clk);

 	clk_disable(iommu_pclk);

@@ -323,8 +322,7 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 		SET_NSCFG(drvdata->base, mid, 3);
 	}

-	if (drvdata->clk)
-		clk_disable(drvdata->clk);
+	clk_disable(drvdata->clk);
 	clk_disable(drvdata->pclk);

 	dev_info(&pdev->dev, "context %s using bank %d\n", c->name, c->num);
-- 
2.1.2


