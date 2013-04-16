Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936091Ab3DPRAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:00:55 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64435 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935982Ab3DPRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:00:52 -0400
Date: Tue, 16 Apr 2013 10:00:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/02] scsi: pcmcia: nsp_cs: remove module init/exit function
 prototypes
Message-ID: <20130416170044.GB3950@kroah.com>
References: <20130416165143.GA3950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416165143.GA3950@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hsweeten@visionengravers.com>

This driver now uses the module_pcmcia_driver() macro to supply the
init/exit code. The nsp_cs_{init,exit} prototypes should be removed.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/pcmcia/nsp_cs.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 7fc9a9d..4d4b4f5 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -331,10 +331,6 @@ static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
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
1.8.2.1.368.g99c2266

