Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbaISVaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:30:17 -0400
Received: from ozlabs.org ([103.22.144.67]:60688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757804AbaISVaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:30:15 -0400
Date: Sat, 20 Sep 2014 07:30:14 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tpm/tpm_ibmvtpm: Remove unnecessary casts
Message-ID: <20140920073014.071007cc@kryten>
In-Reply-To: <20140920072942.27c28768@kryten>
References: <20140920072942.27c28768@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to cast from a void pointer to another pointer.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/drivers/char/tpm/tpm_ibmvtpm.c
===================================================================
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -65,7 +65,7 @@ static struct ibmvtpm_dev *ibmvtpm_get_d
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	BUG_ON(!chip);
-	return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
+	return TPM_VPRIV(chip);
 }
 
 /**
@@ -83,7 +83,7 @@ static int tpm_ibmvtpm_recv(struct tpm_c
 	u16 len;
 	int sig;
 
-	ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
+	ibmvtpm = TPM_VPRIV(chip);
 
 	if (!ibmvtpm->rtce_buf) {
 		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
@@ -127,7 +127,7 @@ static int tpm_ibmvtpm_send(struct tpm_c
 	u64 *word = (u64 *) &crq;
 	int rc;
 
-	ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
+	ibmvtpm = TPM_VPRIV(chip);
 
 	if (!ibmvtpm->rtce_buf) {
 		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
@@ -521,7 +521,7 @@ static void ibmvtpm_crq_process(struct i
  **/
 static irqreturn_t ibmvtpm_interrupt(int irq, void *vtpm_instance)
 {
-	struct ibmvtpm_dev *ibmvtpm = (struct ibmvtpm_dev *) vtpm_instance;
+	struct ibmvtpm_dev *ibmvtpm = vtpm_instance;
 	struct ibmvtpm_crq *crq;
 
 	/* while loop is needed for initial setup (get version and
