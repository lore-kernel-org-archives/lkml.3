Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaGWAfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:35:45 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:39158 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbaGWAfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:35:11 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH v2 1/2] staging: cxt1e1: Prefix ambiguous variable names with 'cxt1e1_' for clarity
Date: Tue, 22 Jul 2014 20:34:55 -0400
Message-Id: <1406075696-15912-2-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406075696-15912-1-git-send-email-jeffoczek@gmail.com>
References: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
 <1406075696-15912-1-git-send-email-jeffoczek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed names of ambiguous sounding variable names as follows

error_flag          ->  cxt1e1_error_flag
max_mtu_default     ->  cxt1e1_max_mtu_default
max_txdesc_used     ->  cxt1e1_max_txdesc_used
max_txdesc_default  ->  cxt1e1_max_txdesc_default
max_rxdesc_used     ->  cxt1e1_max_rxdesc_used
max_rxdesc_default  ->  cxt1e1_max_rxdesc_default

Since max_txdesc_used, max_rxdesc_used are module parameters, these were
changed from global to static and the module init function assigns the values
to the newly named global variables

Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
---
 drivers/staging/cxt1e1/hwprobe.c   |  7 ++---
 drivers/staging/cxt1e1/linux.c     | 53 +++++++++++++++++++++-----------------
 drivers/staging/cxt1e1/musycc.c    |  4 +--
 drivers/staging/cxt1e1/pmcc4_drv.c | 22 +++++++++-------
 drivers/staging/cxt1e1/sbeproc.c   |  6 ++---
 5 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 4fa27c8..9eb0313 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -31,7 +31,7 @@
 #include "sbeproc.h"
 #endif
 
-extern int  error_flag;
+extern int  cxt1e1_error_flag;
 extern int  drvr_state;
 
 /* forward references */
@@ -294,7 +294,7 @@ c4hw_attach_all(void)
 	struct pci_dev *pdev = NULL;
 	int         found = 0, i, j;
 
-	error_flag = 0;
+	cxt1e1_error_flag = 0;
 	prep_hdw_info();
 	/*** scan PCI bus for all possible boards */
 	while ((pdev = pci_get_device(PCI_VENDOR_ID_CONEXANT,
@@ -372,7 +372,8 @@ c4hw_attach_all(void)
 #if 0
 			cleanup_devs();
 #endif
-			return error_flag; /* error_flag set w/in add_dev() */
+			/* cxt1e1_error_flag set w/in add_dev() */
+			return cxt1e1_error_flag;
 		}
 		show_two(hi, i); /* displays found information */
 	}
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 09f3d5c..07cc142 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -83,7 +83,7 @@ int         musycc_start_xmit(ci_t *, int, void *);
 extern ci_t *CI;
 extern struct s_hdw_info hdw_info[];
 
-int         error_flag;         /* module load error reporting */
+int         cxt1e1_error_flag;         /* module load error reporting */
 int         cxt1e1_log_level = LOG_ERROR;
 static int  log_level_default = LOG_ERROR;
 module_param(cxt1e1_log_level, int, 0444);
@@ -93,15 +93,17 @@ static int  max_mru_default = MUSYCC_MRU;
 module_param(cxt1e1_max_mru, int, 0444);
 
 int         cxt1e1_max_mtu = MUSYCC_MTU;
-int         max_mtu_default = MUSYCC_MTU;
+int         cxt1e1_max_mtu_default = MUSYCC_MTU;
 module_param(cxt1e1_max_mtu, int, 0444);
 
-int         max_txdesc_used = MUSYCC_TXDESC_MIN;
-int         max_txdesc_default = MUSYCC_TXDESC_MIN;
+static int  max_txdesc_used = MUSYCC_TXDESC_MIN;
+int         cxt1e1_max_txdesc_default = MUSYCC_TXDESC_MIN;
+int	    cxt1e1_max_txdesc_used = MUSYCC_TXDESC_MIN;
 module_param(max_txdesc_used, int, 0444);
 
-int         max_rxdesc_used = MUSYCC_RXDESC_MIN;
-int         max_rxdesc_default = MUSYCC_RXDESC_MIN;
+static int  max_rxdesc_used = MUSYCC_RXDESC_MIN;
+int         cxt1e1_max_rxdesc_default = MUSYCC_RXDESC_MIN;
+int	    cxt1e1_max_rxdesc_used = MUSYCC_RXDESC_MIN;
 module_param(max_rxdesc_used, int, 0444);
 
 /****************************************************************************/
@@ -921,7 +923,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 	if (!ndev) {
 		pr_warning("%s: no memory for struct net_device !\n",
 			   hi->devname);
-		error_flag = -ENOMEM;
+		cxt1e1_error_flag = -ENOMEM;
 		return NULL;
 	}
 	ci = (ci_t *)(netdev_priv(ndev));
@@ -956,7 +958,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		(c4_init(ci, (u_char *) f0, (u_char *) f1) != SBE_DRVR_SUCCESS)) {
 		kfree(netdev_priv(ndev));
 		kfree(ndev);
-		error_flag = -ENODEV;
+		cxt1e1_error_flag = -ENODEV;
 		return NULL;
 	}
 	/*************************************************************
@@ -982,7 +984,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		unregister_netdev(ndev);
 		kfree(netdev_priv(ndev));
 		kfree(ndev);
-		error_flag = -EIO;
+		cxt1e1_error_flag = -EIO;
 		return NULL;
 	}
 #ifdef CONFIG_SBE_PMCC4_NCOMM
@@ -992,7 +994,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		free_irq(irq0, ndev);
 		kfree(netdev_priv(ndev));
 		kfree(ndev);
-		error_flag = -EIO;
+		cxt1e1_error_flag = -EIO;
 		return NULL;
 	}
 #endif
@@ -1042,8 +1044,8 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 	tasklet_enable(&ci->ci_musycc_isr_tasklet);
 #endif
 
-	error_flag = c4_init2(ci);
-	if (error_flag != SBE_DRVR_SUCCESS) {
+	cxt1e1_error_flag = c4_init2(ci);
+	if (cxt1e1_error_flag != SBE_DRVR_SUCCESS) {
 #ifdef CONFIG_PROC_FS
 		sbecom_proc_brd_cleanup(ci);
 #endif
@@ -1052,7 +1054,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		free_irq(irq0, ndev);
 		kfree(netdev_priv(ndev));
 		kfree(ndev);
-		/* failure, error_flag is set */
+		/* failure, cxt1e1_error_flag is set */
 		return NULL;
 	}
 	return ndev;
@@ -1063,6 +1065,11 @@ c4_mod_init(void)
 {
 	int         rtn;
 
+	/* cxt1e1_max vars are used globally but have to avoid changing
+	existing these module parameter names */
+	cxt1e1_max_txdesc_used = max_txdesc_used;
+	cxt1e1_max_rxdesc_used = max_rxdesc_used;
+
 	rtn = c4hw_attach_all();
 	if (rtn)
 		return -rtn; /* installation failure - see system log */
@@ -1074,20 +1081,20 @@ c4_mod_init(void)
 	if (cxt1e1_max_mru != max_mru_default)
 		pr_info("NOTE: driver parameter <cxt1e1_max_mru> changed from default %d to %d.\n",
 			max_mru_default, cxt1e1_max_mru);
-	if (cxt1e1_max_mtu != max_mtu_default)
+	if (cxt1e1_max_mtu != cxt1e1_max_mtu_default)
 		pr_info("NOTE: driver parameter <cxt1e1_max_mtu> changed from default %d to %d.\n",
-			max_mtu_default, cxt1e1_max_mtu);
-	if (max_rxdesc_used != max_rxdesc_default) {
-		if (max_rxdesc_used > 2000)
-			max_rxdesc_used = 2000; /* out-of-bounds reset */
+			cxt1e1_max_mtu_default, cxt1e1_max_mtu);
+	if (cxt1e1_max_rxdesc_used != cxt1e1_max_rxdesc_default) {
+		if (cxt1e1_max_rxdesc_used > 2000)
+			cxt1e1_max_rxdesc_used = 2000; /* out-of-bounds reset */
 		pr_info("NOTE: driver parameter <max_rxdesc_used> changed from default %d to %d.\n",
-			max_rxdesc_default, max_rxdesc_used);
+			cxt1e1_max_rxdesc_default, cxt1e1_max_rxdesc_used);
 	}
-	if (max_txdesc_used != max_txdesc_default) {
-		if (max_txdesc_used > 1000)
-			max_txdesc_used = 1000; /* out-of-bounds reset */
+	if (cxt1e1_max_txdesc_used != cxt1e1_max_txdesc_default) {
+		if (cxt1e1_max_txdesc_used > 1000)
+			cxt1e1_max_txdesc_used = 1000; /* out-of-bounds reset */
 		pr_info("NOTE: driver parameter <max_txdesc_used> changed from default %d to %d.\n",
-			max_txdesc_default, max_txdesc_used);
+			cxt1e1_max_txdesc_default, cxt1e1_max_txdesc_used);
 	}
 	return 0;                       /* installation success */
 }
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 0bcbd8a..5b9b482 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -45,8 +45,8 @@ extern int  drvr_state;
 
 extern int  cxt1e1_max_mru;
 extern int  cxt1e1_max_mtu;
-extern int  max_rxdesc_used;
-extern int  max_txdesc_used;
+extern int  cxt1e1_max_rxdesc_used;
+extern int  cxt1e1_max_txdesc_used;
 extern ci_t *CI;                /* dummy pointr to board ZEROE's data - DEBUG
 				 * USAGE */
 
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 76bebdd..99b02a0 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -61,8 +61,8 @@ extern void musycc_update_tx_thp (mch_t *);
 extern int  cxt1e1_log_level;
 extern int  cxt1e1_max_mru;
 extern int  cxt1e1_max_mtu;
-extern int  max_rxdesc_used, max_rxdesc_default;
-extern int  max_txdesc_used, max_txdesc_default;
+extern int  cxt1e1_max_rxdesc_used, cxt1e1_max_rxdesc_default;
+extern int  cxt1e1_max_txdesc_used, cxt1e1_max_txdesc_default;
 
 #if defined (__powerpc__)
 extern void *memset (void *s, int c, size_t n);
@@ -1314,25 +1314,27 @@ c4_chan_up (ci_t *ci, int channum)
      */
     if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)
     {
-        if (max_rxdesc_used == max_rxdesc_default)      /* use default setting */
-            max_rxdesc_used = MUSYCC_RXDESC_TRANS;
-        if (max_txdesc_used == max_txdesc_default)      /* use default setting */
-            max_txdesc_used = MUSYCC_TXDESC_TRANS;
+	if (cxt1e1_max_rxdesc_used == cxt1e1_max_rxdesc_default)
+		/* use default setting */
+		cxt1e1_max_rxdesc_used = MUSYCC_RXDESC_TRANS;
+	if (cxt1e1_max_txdesc_used == cxt1e1_max_txdesc_default)
+		/* use default setting */
+		cxt1e1_max_txdesc_used = MUSYCC_TXDESC_TRANS;
     }
     /*
      * Increase counts when hyperchanneling, since this implies an increase
      * in throughput per channel
      */
-    rxnum = max_rxdesc_used + (nts / 4);
-    txnum = max_txdesc_used + (nts / 4);
+	rxnum = cxt1e1_max_rxdesc_used + (nts / 4);
+	txnum = cxt1e1_max_txdesc_used + (nts / 4);
 
 #if 0
     /* DEBUG INFO */
     if (cxt1e1_log_level >= LOG_MONITOR)
         pr_info("%s: mode %x rxnum %d (rxused %d def %d) txnum %d (txused %d def %d)\n",
                 ci->devname, ch->p.chan_mode,
-                rxnum, max_rxdesc_used, max_rxdesc_default,
-                txnum, max_txdesc_used, max_txdesc_default);
+		rxnum, cxt1e1_max_rxdesc_used, cxt1e1_max_rxdesc_default,
+		txnum, cxt1e1_max_txdesc_used, cxt1e1_max_txdesc_default);
 #endif
 
     ch->rxd_num = rxnum;
diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index 1c2e52e..a02b259 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -159,15 +159,15 @@ static int sbecom_proc_get_sbe_info(struct seq_file *m, void *v)
 		extern int max_chans_used;
 		extern int cxt1e1_max_mtu;
 #endif
-		extern int max_rxdesc_used, max_txdesc_used;
+		extern int cxt1e1_max_rxdesc_used, cxt1e1_max_txdesc_used;
 
 		seq_printf(m, "\ncxt1e1_max_mru:         %d\n", cxt1e1_max_mru);
 #if 0
 		seq_printf(m, "\nmax_chans_used:  %d\n", max_chans_used);
 		seq_printf(m, "cxt1e1_max_mtu:         %d\n", cxt1e1_max_mtu);
 #endif
-		seq_printf(m, "max_rxdesc_used: %d\n", max_rxdesc_used);
-		seq_printf(m, "max_txdesc_used: %d\n", max_txdesc_used);
+		seq_printf(m, "max_rxdesc_used: %d\n", cxt1e1_max_rxdesc_used);
+		seq_printf(m, "max_txdesc_used: %d\n", cxt1e1_max_txdesc_used);
 	}
 #endif
 
-- 
1.9.1

