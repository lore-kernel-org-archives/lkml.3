Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbaKTWXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:23:44 -0500
Received: from mout.web.de ([212.227.17.11]:57386 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbaKTWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:23:43 -0500
Message-ID: <546E69D8.4040002@users.sourceforge.net>
Date: Thu, 20 Nov 2014 23:23:20 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "James E. J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] SCSI-aic94xx: Deletion of an unnecessary check before
 the function call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:QEfGw/vnIeZZGgdZ4WmQIGQK6FQFH5Xu62WH0JDNYlZ1VE0CW+l
 8LbiZYtp5iZ/Kw/Li6MntiwsnH7hX6AnIUlIP/bp4EWgE+s/1Dys/EcneU/0jTiS4JUvXcx
 vFSmPxTLAwsie0xPiMKf4/eAKD6Sk60Yi3Vkxz732onO1/QhNClibBGbZYJj6cJ1r8L6YWn
 NIT2oPoNrFl004zdLISSg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 23:18:56 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index c56741f..0bfdcba 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -597,8 +597,7 @@ static void asd_destroy_ha_caches(struct asd_ha_struct *asd_ha)
 	if (asd_ha->hw_prof.scb_ext)
 		asd_free_coherent(asd_ha, asd_ha->hw_prof.scb_ext);
 
-	if (asd_ha->hw_prof.ddb_bitmap)
-		kfree(asd_ha->hw_prof.ddb_bitmap);
+	kfree(asd_ha->hw_prof.ddb_bitmap);
 	asd_ha->hw_prof.ddb_bitmap = NULL;
 
 	for (i = 0; i < ASD_MAX_PHYS; i++) {
-- 
2.1.3

