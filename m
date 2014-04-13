Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaDMPfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 11:35:54 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:49573 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaDMPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 11:35:52 -0400
X-ME-Helo: PCombes.localdomain
X-ME-Auth: cGFzY29tQHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Apr 2014 17:35:50 +0200
X-ME-IP: 82.124.119.218
Message-ID: <534AAED2.7050205@orange.fr>
Date: Sun, 13 Apr 2014 17:35:46 +0200
From: Pascal COMBES <pascom@orange.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Monam Agarwal <monamagarwal123@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Robert Foss <dev@robertfoss.se>, Jingoo Han <jg1.han@samsung.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>,
        Naren Sankar <nsankar@broadcom.com>, Jarod Wilson <jarod@wilsonet.com>,
        Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix coding style in drivers/staging/crystalhd/crystalhd_lnx.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pascal COMBES <pascom@orange.fr>

Fix alignement issues and two or three other coding style problems in 
drivers/staging/crystalhd/crystalhd_lnx.c.

NB:	-I did this for task 10 of Eudyptula challenge <http://eudyptula-challenge.org/>
	-I did not address camel case related problem because it would have make a big patch.

Signed-off-by: Pascal COMBES <pascom@orange.fr>
---
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 20be957..9f6a9d4 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -28,7 +28,7 @@ static struct crystalhd_adp *g_adp_info;
 
 static irqreturn_t chd_dec_isr(int irq, void *arg)
 {
-	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
+	struct crystalhd_adp *adp = (struct crystalhd_adp *)arg;
 	int rc = 0;
 	if (adp)
 		rc = crystalhd_cmd_interrupt(&adp->cmds);
@@ -112,7 +112,7 @@ static void chd_dec_free_iodata(struct crystalhd_adp *adp,
 }
 
 static inline int crystalhd_user_data(void __user *ud, void *dr,
-			 int size, int set)
+				      int size, int set)
 {
 	int rc;
 
@@ -135,7 +135,9 @@ static inline int crystalhd_user_data(void __user *ud, void *dr,
 }
 
 static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
-	 struct crystalhd_ioctl_data *io, uint32_t m_sz, unsigned long ua)
+			       struct crystalhd_ioctl_data *io,
+			       uint32_t m_sz,
+			       unsigned long ua)
 {
 	unsigned long ua_off;
 	int rc = 0;
@@ -154,7 +156,7 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 	io->add_cdata_sz = m_sz;
 	ua_off = ua + sizeof(io->udata);
 	rc = crystalhd_user_data((void __user *)ua_off, io->add_cdata,
-			io->add_cdata_sz, 0);
+				 io->add_cdata_sz, 0);
 	if (rc) {
 		BCMLOG_ERR("failed to pull add_cdata sz:%x ua_off:%x\n",
 			   io->add_cdata_sz, (unsigned int)ua_off);
@@ -167,7 +169,8 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 }
 
 static int chd_dec_release_cdata(struct crystalhd_adp *adp,
-			 struct crystalhd_ioctl_data *io, unsigned long ua)
+				 struct crystalhd_ioctl_data *io,
+				 unsigned long ua)
 {
 	unsigned long ua_off;
 	int rc;
@@ -180,7 +183,7 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 	if (io->cmd != BCM_IOC_FW_DOWNLOAD) {
 		ua_off = ua + sizeof(io->udata);
 		rc = crystalhd_user_data((void __user *)ua_off, io->add_cdata,
-					io->add_cdata_sz, 1);
+					 io->add_cdata_sz, 1);
 		if (rc) {
 			BCMLOG_ERR(
 				"failed to push add_cdata sz:%x ua_off:%x\n",
@@ -210,7 +213,7 @@ static int chd_dec_proc_user_data(struct crystalhd_adp *adp,
 	}
 
 	rc = crystalhd_user_data((void __user *)ua, &io->udata,
-			sizeof(io->udata), set);
+				 sizeof(io->udata), set);
 	if (rc) {
 		BCMLOG_ERR("failed to %s iodata\n", (set ? "set" : "get"));
 		return rc;
@@ -382,7 +385,7 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 	}
 
 	dev = device_create(crystalhd_class, NULL,
-			 MKDEV(adp->chd_dec_major, 0), NULL, "crystalhd");
+			    MKDEV(adp->chd_dec_major, 0), NULL, "crystalhd");
 	if (IS_ERR(dev)) {
 		rc = PTR_ERR(dev);
 		BCMLOG_ERR("failed to create device\n");
@@ -397,8 +400,7 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 
 	/* Allocate general purpose ioctl pool. */
 	for (i = 0; i < CHD_IODATA_POOL_SZ; i++) {
-		temp = kzalloc(sizeof(struct crystalhd_ioctl_data),
-					 GFP_KERNEL);
+		temp = kzalloc(sizeof(*temp), GFP_KERNEL);
 		if (!temp) {
 			BCMLOG_ERR("ioctl data pool kzalloc failed\n");
 			rc = -ENOMEM;
@@ -549,11 +551,11 @@ static int chd_dec_pci_probe(struct pci_dev *pdev,
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	BCMLOG(BCMLOG_DBG,
-		"PCI_INFO: Vendor:0x%04x Device:0x%04x s_vendor:0x%04x s_device: 0x%04x\n",
-		pdev->vendor, pdev->device, pdev->subsystem_vendor,
-		pdev->subsystem_device);
+	       "PCI_INFO: Vendor:0x%04x Device:0x%04x s_vendor:0x%04x s_device: 0x%04x\n",
+	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
+	       pdev->subsystem_device);
 
-	pinfo = kzalloc(sizeof(struct crystalhd_adp), GFP_KERNEL);
+	pinfo = kzalloc(sizeof(*pinfo), GFP_KERNEL);
 	if (!pinfo) {
 		BCMLOG_ERR("Failed to allocate memory\n");
 		return -ENOMEM;
