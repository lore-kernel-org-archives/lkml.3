Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaDOTVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:21:42 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:35849 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaDOTVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:21:39 -0400
X-ME-Helo: PCombes.localdomain
X-ME-Auth: cGFzY29tQHdhbmFkb28uZnI=
X-ME-Date: Tue, 15 Apr 2014 21:21:38 +0200
X-ME-IP: 82.124.119.218
Message-ID: <534D86C1.80606@orange.fr>
Date: Tue, 15 Apr 2014 21:21:37 +0200
From: Pascal COMBES <pascom@orange.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <dev@robertfoss.se>
Subject: [PATCH v3 3/3] Staging: crystalhd: Improve kzalloc calls in crystalhd_lnx.c
References: <534AAED2.7050205@orange.fr> <20140413154859.GA18189@kroah.com>
In-Reply-To: <20140413154859.GA18189@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof(type) by sizeof(variable) in crystalhd_lnx.c.

Signed-off-by: Pascal COMBES <pascom@orange.fr>
---
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 0e432bc..e6fb331 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -399,8 +399,7 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 
 	/* Allocate general purpose ioctl pool. */
 	for (i = 0; i < CHD_IODATA_POOL_SZ; i++) {
-		temp = kzalloc(sizeof(struct crystalhd_ioctl_data),
-			       GFP_KERNEL);
+		temp = kzalloc(sizeof(*temp), GFP_KERNEL);
 		if (!temp) {
 			BCMLOG_ERR("ioctl data pool kzalloc failed\n");
 			rc = -ENOMEM;
@@ -555,7 +554,7 @@ static int chd_dec_pci_probe(struct pci_dev *pdev,
 	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
 	       pdev->subsystem_device);
 
-	pinfo = kzalloc(sizeof(struct crystalhd_adp), GFP_KERNEL);
+	pinfo = kzalloc(sizeof(*pinfo), GFP_KERNEL);
 	if (!pinfo) {
 		BCMLOG_ERR("Failed to allocate memory\n");
 		return -ENOMEM;

