Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaF3ItR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:49:17 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:56890 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaF3ItQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:49:16 -0400
Date: Mon, 30 Jun 2014 12:48:45 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: gregkh@linuxfoundation.org
cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, matwey.kornilov@gmail.com
Subject: [PATCH 2/2] parport: parport_pc: Add force_epp module option for
 parport_pc.
Message-ID: <alpine.LRH.2.00.1406301248200.15067@lnfm1.sai.msu.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f5384f47688c116ac765b18bfb01e28b4233b97f Mon Sep 17 00:00:00 2001
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Wed, 25 Jun 2014 01:08:45 +0400
Subject: [PATCH 2/2] parport: parport_pc: Add force_epp module option for parport_pc.

The detection of Intel EPP bug is known to produce much false positives.
The new option is introduced to force enable EPP in spite of the test result.

Tested-by: Heiko Andreas Sommer <hsommer@eso.org>
Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
  drivers/parport/parport_pc.c | 9 ++++++++-
  1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 4b851bb..1a15b9c 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -105,6 +105,9 @@ static int user_specified;
         (defined(CONFIG_PARPORT_1284) && defined(CONFIG_PARPORT_PC_FIFO))
  static int verbose_probing;
  #endif
+#ifdef CONFIG_PARPORT_1284
+static int force_epp;
+#endif
  static int pci_registered_parport;
  static int pnp_registered_parport;

@@ -1765,7 +1768,7 @@ static int parport_EPP_supported(struct parport *pb)
  		return 0;  /* No way to clear timeout */

  	/* Check for Intel bug. */
-	if (intel_bug_present(pb))
+	if (!force_epp && intel_bug_present(pb))
  		return 0;

  	pb->modes |= PARPORT_MODE_EPP;
@@ -3148,6 +3151,10 @@ module_param_array(dma, charp, NULL, 0);
  MODULE_PARM_DESC(verbose_probing, "Log chit-chat during initialisation");
  module_param(verbose_probing, int, 0644);
  #endif
+#ifdef CONFIG_PARPORT_1284
+MODULE_PARM_DESC(force_epp, "Do not disable EPP when it is detected to be broken (default is false)");
+module_param(force_epp, int, 0);
+#endif
  #ifdef CONFIG_PCI
  static char *init_mode;
  MODULE_PARM_DESC(init_mode,
-- 
1.8.1.4

