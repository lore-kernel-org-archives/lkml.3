Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaDOTVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:21:15 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:60344 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaDOTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:21:13 -0400
X-ME-Helo: PCombes.localdomain
X-ME-Auth: cGFzY29tQHdhbmFkb28uZnI=
X-ME-Date: Tue, 15 Apr 2014 21:21:11 +0200
X-ME-IP: 82.124.119.218
Message-ID: <534D86A3.3020709@orange.fr>
Date: Tue, 15 Apr 2014 21:21:07 +0200
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
Subject: [PATCH v3 1/3] Staging: crystalhd: Fix alignement in crystalhd_lnx.c
References: <534AAED2.7050205@orange.fr> <20140413154859.GA18189@kroah.com>
In-Reply-To: <20140413154859.GA18189@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pascal COMBES <pascom@orange.fr>
---
Description in subject.

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 20be957..fd7f08a 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -112,7 +112,7 @@ static void chd_dec_free_iodata(struct crystalhd_adp *adp,
 }
 
 static inline int crystalhd_user_data(void __user *ud, void *dr,
-			 int size, int set)
+				      int size, int set)
 {
 	int rc;
 
@@ -135,7 +135,8 @@ static inline int crystalhd_user_data(void __user *ud, void *dr,
 }
 
 static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
-	 struct crystalhd_ioctl_data *io, uint32_t m_sz, unsigned long ua)
+			       struct crystalhd_ioctl_data *io, uint32_t m_sz,
+			       unsigned long ua)
 {
 	unsigned long ua_off;
 	int rc = 0;
@@ -154,7 +155,7 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 	io->add_cdata_sz = m_sz;
 	ua_off = ua + sizeof(io->udata);
 	rc = crystalhd_user_data((void __user *)ua_off, io->add_cdata,
-			io->add_cdata_sz, 0);
+				 io->add_cdata_sz, 0);
 	if (rc) {
 		BCMLOG_ERR("failed to pull add_cdata sz:%x ua_off:%x\n",
 			   io->add_cdata_sz, (unsigned int)ua_off);
@@ -167,7 +168,8 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 }
 
 static int chd_dec_release_cdata(struct crystalhd_adp *adp,
-			 struct crystalhd_ioctl_data *io, unsigned long ua)
+				 struct crystalhd_ioctl_data *io,
+				 unsigned long ua)
 {
 	unsigned long ua_off;
 	int rc;
@@ -180,7 +182,7 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 	if (io->cmd != BCM_IOC_FW_DOWNLOAD) {
 		ua_off = ua + sizeof(io->udata);
 		rc = crystalhd_user_data((void __user *)ua_off, io->add_cdata,
-					io->add_cdata_sz, 1);
+					 io->add_cdata_sz, 1);
 		if (rc) {
 			BCMLOG_ERR(
 				"failed to push add_cdata sz:%x ua_off:%x\n",
@@ -210,7 +212,7 @@ static int chd_dec_proc_user_data(struct crystalhd_adp *adp,
 	}
 
 	rc = crystalhd_user_data((void __user *)ua, &io->udata,
-			sizeof(io->udata), set);
+				 sizeof(io->udata), set);
 	if (rc) {
 		BCMLOG_ERR("failed to %s iodata\n", (set ? "set" : "get"));
 		return rc;
@@ -382,7 +384,7 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 	}
 
 	dev = device_create(crystalhd_class, NULL,
-			 MKDEV(adp->chd_dec_major, 0), NULL, "crystalhd");
+			    MKDEV(adp->chd_dec_major, 0), NULL, "crystalhd");
 	if (IS_ERR(dev)) {
 		rc = PTR_ERR(dev);
 		BCMLOG_ERR("failed to create device\n");
@@ -398,7 +400,7 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 	/* Allocate general purpose ioctl pool. */
 	for (i = 0; i < CHD_IODATA_POOL_SZ; i++) {
 		temp = kzalloc(sizeof(struct crystalhd_ioctl_data),
-					 GFP_KERNEL);
+			       GFP_KERNEL);
 		if (!temp) {
 			BCMLOG_ERR("ioctl data pool kzalloc failed\n");
 			rc = -ENOMEM;
@@ -549,9 +551,9 @@ static int chd_dec_pci_probe(struct pci_dev *pdev,
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	BCMLOG(BCMLOG_DBG,
-		"PCI_INFO: Vendor:0x%04x Device:0x%04x s_vendor:0x%04x s_device: 0x%04x\n",
-		pdev->vendor, pdev->device, pdev->subsystem_vendor,
-		pdev->subsystem_device);
+	       "PCI_INFO: Vendor:0x%04x Device:0x%04x s_vendor:0x%04x s_device: 0x%04x\n",
+	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
+	       pdev->subsystem_device);
 
 	pinfo = kzalloc(sizeof(struct crystalhd_adp), GFP_KERNEL);
 	if (!pinfo) {

