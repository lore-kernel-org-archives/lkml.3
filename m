Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbbAKOX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:23:58 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63011 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbAKOX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:23:56 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: libata-core: Remove unused function
Date: Sun, 11 Jan 2015 15:27:01 +0100
Message-Id: <1420986421-18686-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ata_do_simple_cmd() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/ata/libata-core.c |   27 ---------------------------
 drivers/ata/libata.h      |    1 -
 2 files changed, 28 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c5ba15a..e525319 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1747,33 +1747,6 @@ unsigned ata_exec_internal(struct ata_device *dev,
 }
 
 /**
- *	ata_do_simple_cmd - execute simple internal command
- *	@dev: Device to which the command is sent
- *	@cmd: Opcode to execute
- *
- *	Execute a 'simple' command, that only consists of the opcode
- *	'cmd' itself, without filling any other registers
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	Zero on success, AC_ERR_* mask on failure
- */
-unsigned int ata_do_simple_cmd(struct ata_device *dev, u8 cmd)
-{
-	struct ata_taskfile tf;
-
-	ata_tf_init(dev, &tf);
-
-	tf.command = cmd;
-	tf.flags |= ATA_TFLAG_DEVICE;
-	tf.protocol = ATA_PROT_NODATA;
-
-	return ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
-}
-
-/**
  *	ata_pio_need_iordy	-	check if iordy needed
  *	@adev: ATA device
  *
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 5f4e0cc..82ebe26 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -76,7 +76,6 @@ extern unsigned ata_exec_internal_sg(struct ata_device *dev,
 				     struct ata_taskfile *tf, const u8 *cdb,
 				     int dma_dir, struct scatterlist *sg,
 				     unsigned int n_elem, unsigned long timeout);
-extern unsigned int ata_do_simple_cmd(struct ata_device *dev, u8 cmd);
 extern int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 			  int (*check_ready)(struct ata_link *link));
 extern int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
-- 
1.7.10.4

