Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaCCAAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:00:11 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56913 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaCCAAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:00:06 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: shaun@xresource.ca, sachin.kamat@linaro.org,
        dulshani.gunawardhana89@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5 v2] staging: cxt1e1: fix checkpatch error 'assignment in if condition'
Date: Mon, 03 Mar 2014 09:00:02 +0900
Message-ID: <4091292.138vlEnagH@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


checkpatch.pl error:
 ERROR: do not use assignment in if condition

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/hwprobe.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index d6ccbd9..5f0e05d 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -142,8 +142,8 @@ hdw_sn_get(hdw_info_t *hi, int brdno)
 			hi->mfg_info.Serial[5]);
 #endif
 
-	if ((hi->promfmt = pmc_verify_cksum(&hi->mfg_info.data)) == PROM_FORMAT_Unk)
-	{
+	hi->promfmt = pmc_verify_cksum(&hi->mfg_info.data);
+	if (hi->promfmt == PROM_FORMAT_Unk) {
 		/* bad crc, data is suspect */
 		if (cxt1e1_log_level >= LOG_WARN)
 			pr_info("%s: EEPROM cksum error\n", hi->devname);
@@ -232,8 +232,8 @@ c4_hdw_init(struct pci_dev *pdev, int found)
 	unsigned char busno = 0xff;
 
 	/* our MUSYCC chip supports two functions, 0 & 1 */
-	if ((fun = PCI_FUNC(pdev->devfn)) > 1)
-	{
+	fun = PCI_FUNC(pdev->devfn);
+	if (fun > 1) {
 		pr_warning("unexpected devfun: 0x%x\n", pdev->devfn);
 		return 0;
 	}
@@ -380,11 +380,11 @@ c4hw_attach_all(void)
 		}
 		pci_set_master(hi->pdev[0]);
 		pci_set_master(hi->pdev[1]);
-		if (!(hi->ndev = c4_add_dev(hi, i, (long) hi->addr_mapped[0],
-					    (long) hi->addr_mapped[1],
-					    hi->pdev[0]->irq,
-					    hi->pdev[1]->irq)))
-		{
+		hi->ndev = c4_add_dev(hi, i, (long) hi->addr_mapped[0],
+				      (long) hi->addr_mapped[1],
+				      hi->pdev[0]->irq,
+				      hi->pdev[1]->irq);
+		if (!hi->ndev) {
 			drvr_state = SBE_DRVR_DOWN;
 			cleanup_ioremap();
 			/* NOTE: c4_add_dev() does its own device cleanup */
-- 
1.7.9.5


