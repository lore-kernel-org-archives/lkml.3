Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3DOQnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:43:53 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.99]:56421 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab3DOQnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:43:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1366044217!7248404!21
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: pcmcia: nsp_cs: remove module init/exit function prototypes
Date: Mon, 15 Apr 2013 09:42:37 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
CC: <fengguang.wu@intel.com>, <JBottomley@parallels.com>,
        <yokota@netlab.is.tsukuba.ac.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201304150942.37837.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver now uses the module_pcmcia_driver() macro to supply the
init/exit code. The nsp_cs_{init,exit} prototypes should be removed.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/pcmcia/nsp_cs.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index afd64f0..ea5122f 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -326,10 +326,6 @@ static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
 /* Interrupt handler */
 //static irqreturn_t nspintr(int irq, void *dev_id);
 
-/* Module entry point*/
-static int  __init nsp_cs_init(void);
-static void __exit nsp_cs_exit(void);
-
 /* Debug */
 #ifdef NSP_DEBUG
 static void show_command (struct scsi_cmnd *SCpnt);
-- 
1.8.1.4

