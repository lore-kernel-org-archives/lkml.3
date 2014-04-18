Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaDRR6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:58:10 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:42175 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaDRR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:58:06 -0400
From: Bojan Prtvar <prtvar.b@gmail.com>
To: nsankar@broadcom.com, jarod@wilsonet.com, davilla@4pi.com,
        abraham.manu@gmail.com, gregkh@linuxfoundation.org,
        amarjargal16@gmail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Bojan Prtvar <prtvar.b@gmail.com>
Subject: [PATCH] Staging: crystalhd: Mark local functions as static
Date: Fri, 18 Apr 2014 19:57:51 +0200
Message-Id: <1397843871-10850-1-git-send-email-prtvar.b@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warnings:
drivers/staging/crystalhd/crystalhd_lnx.c:631:5: warning: symbol 'chd_dec_pci_suspend' was not declared. Should it be static?
drivers/staging/crystalhd/crystalhd_lnx.c:665:5: warning: symbol 'chd_dec_pci_resume' was not declared. Should it be static?
drivers/staging/crystalhd/crystalhd_lnx.c:78:29: warning: symbol 'chd_dec_alloc_iodata' was not declared. Should it be static?
drivers/staging/crystalhd/crystalhd_lnx.c:99:6: warning: symbol 'chd_dec_free_iodata' was not declared. Should it be static?

Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index c1f6163..590e0b8 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -75,8 +75,8 @@ static int chd_dec_disable_int(struct crystalhd_adp *adp)
 	return 0;
 }
 
-struct crystalhd_ioctl_data *chd_dec_alloc_iodata(struct crystalhd_adp *adp,
-					 bool isr)
+static struct crystalhd_ioctl_data *
+chd_dec_alloc_iodata(struct crystalhd_adp *adp, bool isr)
 {
 	unsigned long flags = 0;
 	struct crystalhd_ioctl_data *temp;
@@ -96,7 +96,7 @@ struct crystalhd_ioctl_data *chd_dec_alloc_iodata(struct crystalhd_adp *adp,
 	return temp;
 }
 
-void chd_dec_free_iodata(struct crystalhd_adp *adp,
+static void chd_dec_free_iodata(struct crystalhd_adp *adp,
 			 struct crystalhd_ioctl_data *iodata, bool isr)
 {
 	unsigned long flags = 0;
@@ -628,7 +628,7 @@ err:
 }
 
 #ifdef CONFIG_PM
-int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct crystalhd_adp *adp;
 	struct crystalhd_ioctl_data *temp;
@@ -662,7 +662,7 @@ int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-int chd_dec_pci_resume(struct pci_dev *pdev)
+static int chd_dec_pci_resume(struct pci_dev *pdev)
 {
 	struct crystalhd_adp *adp;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
-- 
1.7.9.5

