Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaGAMa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:30:27 -0400
Received: from smtpdg222.aruba.it ([62.149.158.222]:56872 "EHLO
	smtpdg222.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaGAMa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:30:26 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 08:30:25 EDT
From: Davide Gianforte <davide@gengisdave.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 1/2] staging: silicom: checkpatch fixes
Date: Tue, 01 Jul 2014 14:24:36 +0200
Message-ID: <1972083.WZLDx2N35Z@mayhem>
User-Agent: KMail/4.13.2 (Linux/3.15.3; KDE/4.13.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chechpatch.pl cleanup

There are still some warnings, most of them are lines over 80 chars
(mainly a semicolon or closing parenthesis).

Where not specified, I defaulted printk with no log level into pr_debug

Signed-off-by: Davide Gianforte <davide@gengisdave.org>
---

 drivers/staging/silicom/bpctl_mod.c | 712 +++++++++++++++++-------------------
 1 file changed, 339 insertions(+), 373 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 765fce8..1322437 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -43,8 +43,7 @@ MODULE_DESCRIPTION(BP_MOD_DESCR);
 MODULE_VERSION(BP_MOD_VER);
 static spinlock_t bpvm_lock;
 
-#define unlock_bpctl()					\
-	up(&bpctl_sema);
+#define unlock_bpctl() up(&bpctl_sema)
 
 /* Media Types */
 enum bp_media_type {
@@ -94,8 +93,8 @@ struct bpctl_dev {
 	int bp_10g9;
 	int bp_i80;
 	int bp_540;
-	int (*hard_start_xmit_save) (struct sk_buff *skb,
-				     struct net_device *dev);
+	int (*hard_start_xmit_save)(struct sk_buff *skb,
+				    struct net_device *dev);
 	const struct net_device_ops *old_ops;
 	struct net_device_ops new_ops;
 	int bp_self_test_flag;
@@ -155,7 +154,8 @@ static int bp_device_event(struct notifier_block *unused,
 	static struct bpctl_dev *pbpctl_dev, *pbpctl_dev_m;
 	int dev_num = 0, ret = 0, ret_d = 0, time_left = 0;
 
-	/* printk("BP_PROC_SUPPORT event =%d %s %d\n", event,dev->name, dev->ifindex ); */
+	/* printk("BP_PROC_SUPPORT event =%d %s %d\n", event,dev->name,
+	 *	  dev->ifindex ); */
 	/* return NOTIFY_DONE; */
 	if (!dev)
 		return NOTIFY_DONE;
@@ -178,6 +178,7 @@ static int bp_device_event(struct notifier_block *unused,
 	}
 	if (event == NETDEV_UNREGISTER) {
 		int idx_dev = 0;
+
 		for (idx_dev = 0;
 		     ((bpctl_dev_arr[idx_dev].pdev != NULL)
 		      && (idx_dev < device_num)); idx_dev++) {
@@ -195,6 +196,7 @@ static int bp_device_event(struct notifier_block *unused,
 	}
 	if (event == NETDEV_CHANGENAME) {
 		int idx_dev = 0;
+
 		for (idx_dev = 0;
 		     ((bpctl_dev_arr[idx_dev].pdev != NULL)
 		      && (idx_dev < device_num)); idx_dev++) {
@@ -235,18 +237,17 @@ static int bp_device_event(struct notifier_block *unused,
 				return NOTIFY_DONE;
 			ret = bypass_status(pbpctl_dev_m);
 			if (ret == 1)
-				printk("bpmod: %s is in the Bypass mode now",
-				       dev->name);
+				pr_debug("bpmod: %s is in the Bypass mode now",
+					 dev->name);
 			ret_d = disc_status(pbpctl_dev_m);
 			if (ret_d == 1)
-				printk
-				    ("bpmod: %s is in the Disconnect mode now",
-				     dev->name);
+				pr_debug("bpmod: %s is in the Disconnect mode now",
+					 dev->name);
 			if (ret || ret_d) {
 				wdt_timer(pbpctl_dev_m, &time_left);
 				if (time_left == -1)
-					printk("; WDT has expired");
-				printk(".\n");
+					pr_debug("; WDT has expired");
+				pr_debug(".\n");
 
 			}
 			return NOTIFY_DONE;
@@ -294,9 +295,12 @@ static void write_pulse(struct bpctl_dev *pbpctl_dev,
 		if (ctrl_val) {
 			if (pbpctl_dev->bp_10g9) {
 
-				/* To start management : MCLK 1, MDIO 1, output */
+				/* To start management : MCLK 1, MDIO 1,
+				 * output */
 				/* DATA 1 CLK 1 */
-				/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext|BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9)); */
+				/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+				 * (ctrl_ext|BP10G_MCLK_DATA_OUT9|
+				 *  BP10G_MDIO_DATA_OUT9)); */
 				BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 						ctrl_ext |
 						BP10G_MDIO_DATA_OUT9);
@@ -305,35 +309,31 @@ static void write_pulse(struct bpctl_dev *pbpctl_dev,
 						 BP10G_MCLK_DIR_OUT9));
 
 			} else if (pbpctl_dev->bp_fiber5) {
-				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, (ctrl_ext |
-								      BPCTLI_CTRL_EXT_MCLK_DIR5
-								      |
-								      BPCTLI_CTRL_EXT_MDIO_DIR5
-								      |
-								      BPCTLI_CTRL_EXT_MDIO_DATA5
-								      |
-								      BPCTLI_CTRL_EXT_MCLK_DATA5));
+				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+						   (ctrl_ext |
+						    BPCTLI_CTRL_EXT_MCLK_DIR5 |
+						    BPCTLI_CTRL_EXT_MDIO_DIR5 |
+						    BPCTLI_CTRL_EXT_MDIO_DATA5 |
+						    BPCTLI_CTRL_EXT_MCLK_DATA5));
 
 			} else if (pbpctl_dev->bp_i80) {
-				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, (ctrl_ext |
-								      BPCTLI_CTRL_EXT_MDIO_DIR80
-								      |
-								      BPCTLI_CTRL_EXT_MDIO_DATA80));
+				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+						   (ctrl_ext |
+						    BPCTLI_CTRL_EXT_MDIO_DIR80 |
+						    BPCTLI_CTRL_EXT_MDIO_DATA80));
 
-				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, (ctrl |
-									  BPCTLI_CTRL_EXT_MCLK_DIR80
-									  |
-									  BPCTLI_CTRL_EXT_MCLK_DATA80));
+				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+						   (ctrl |
+						    BPCTLI_CTRL_EXT_MCLK_DIR80 |
+						    BPCTLI_CTRL_EXT_MCLK_DATA80));
 
 			} else if (pbpctl_dev->bp_540) {
-				BP10G_WRITE_REG(pbpctl_dev, ESDP, (ctrl |
-								   BP540_MDIO_DIR
-								   |
-								   BP540_MDIO_DATA
-								   |
-								   BP540_MCLK_DIR
-								   |
-								   BP540_MCLK_DATA));
+				BP10G_WRITE_REG(pbpctl_dev, ESDP,
+						(ctrl |
+						 BP540_MDIO_DIR |
+						 BP540_MDIO_DATA |
+						 BP540_MCLK_DIR |
+						 BP540_MCLK_DATA));
 
 			} else if (pbpctl_dev->bp_10gb) {
 				BP10GB_WRITE_REG(pbpctl_dev, MISC_REG_SPIO,
@@ -345,7 +345,8 @@ static void write_pulse(struct bpctl_dev *pbpctl_dev,
 						   BP10GB_MCLK_CLR));
 
 			} else if (!pbpctl_dev->bp_10g)
-				/* To start management : MCLK 1, MDIO 1, output */
+				/* To start management : MCLK 1, MDIO 1,
+				 * output */
 				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 						   (ctrl_ext |
 						    BPCTLI_CTRL_EXT_MCLK_DIR |
@@ -354,7 +355,8 @@ static void write_pulse(struct bpctl_dev *pbpctl_dev,
 						    BPCTLI_CTRL_EXT_MCLK_DATA));
 			else {
 
-				/* To start management : MCLK 1, MDIO 1, output*/
+				/* To start management : MCLK 1, MDIO 1,
+				 * output*/
 				BP10G_WRITE_REG(pbpctl_dev, EODSDP,
 						(ctrl_ext | BP10G_MCLK_DATA_OUT
 						 | BP10G_MDIO_DATA_OUT));
@@ -364,7 +366,9 @@ static void write_pulse(struct bpctl_dev *pbpctl_dev,
 			usec_delay(PULSE_TIME);
 			if (pbpctl_dev->bp_10g9) {
 
-				/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL, ((ctrl_ext|BP10G_MDIO_DATA_OUT9)&~(BP10G_MCLK_DATA_OUT9))); */
+				/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+				 * ((ctrl_ext|BP10G_MDIO_DATA_OUT9)&
+				 * ~(BP10G_MCLK_DATA_OUT9))); */
 				/* DATA 1 CLK 0 */
 				BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 						ctrl_ext |
@@ -384,10 +388,10 @@ static void write_pulse(struct bpctl_dev *pbpctl_dev,
 						    (BPCTLI_CTRL_EXT_MCLK_DATA5)));
 
 			} else if (pbpctl_dev->bp_i80) {
-				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, (ctrl_ext |
-								      BPCTLI_CTRL_EXT_MDIO_DIR80
-								      |
-								      BPCTLI_CTRL_EXT_MDIO_DATA80));
+				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+						   (ctrl_ext |
+						    BPCTLI_CTRL_EXT_MDIO_DIR80 |
+						    BPCTLI_CTRL_EXT_MDIO_DATA80));
 				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 						   ((ctrl |
 						     BPCTLI_CTRL_EXT_MCLK_DIR80)
@@ -435,7 +439,9 @@ static void write_pulse(struct bpctl_dev *pbpctl_dev,
 		} else {
 			if (pbpctl_dev->bp_10g9) {
 				/* DATA 0 CLK 1 */
-				/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL, ((ctrl_ext|BP10G_MCLK_DATA_OUT9)&~BP10G_MDIO_DATA_OUT9)); */
+				/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+				 * ((ctrl_ext|BP10G_MCLK_DATA_OUT9)&
+				 * ~BP10G_MDIO_DATA_OUT9)); */
 				BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 						(ctrl_ext &
 						 ~BP10G_MDIO_DATA_OUT9));
@@ -502,7 +508,9 @@ static void write_pulse(struct bpctl_dev *pbpctl_dev,
 			usec_delay(PULSE_TIME);
 			if (pbpctl_dev->bp_10g9) {
 				/* DATA 0 CLK 0 */
-				/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
+				/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+				 * (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|
+				 *  BP10G_MDIO_DATA_OUT9))); */
 				BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 						(ctrl_ext &
 						 ~BP10G_MDIO_DATA_OUT9));
@@ -593,20 +601,20 @@ static int read_pulse(struct bpctl_dev *pbpctl_dev, unsigned int ctrl_ext,
 
 	while (i--) {
 		if (pbpctl_dev->bp_10g9) {
-			/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL, ((ctrl_ext|BP10G_MDIO_DATA_OUT9)&~BP10G_MCLK_DATA_OUT9)); */
+			/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+			 * ((ctrl_ext|BP10G_MDIO_DATA_OUT9)&
+			 *  ~BP10G_MCLK_DATA_OUT9)); */
 			/* DATA ? CLK 0 */
 			BP10G_WRITE_REG(pbpctl_dev_c, ESDP,
 					((ctrl | BP10G_MCLK_DIR_OUT9) &
 					 ~(BP10G_MCLK_DATA_OUT9)));
 
 		} else if (pbpctl_dev->bp_fiber5) {
-			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-							       BPCTLI_CTRL_EXT_MCLK_DIR5)
-							      &
-							      ~
-							      (BPCTLI_CTRL_EXT_MDIO_DIR5
-							       |
-							       BPCTLI_CTRL_EXT_MCLK_DATA5)));
+			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+					   ((ctrl_ext |
+					     BPCTLI_CTRL_EXT_MCLK_DIR5) &
+					    ~(BPCTLI_CTRL_EXT_MDIO_DIR5 |
+					      BPCTLI_CTRL_EXT_MCLK_DATA5)));
 
 		} else if (pbpctl_dev->bp_i80) {
 			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
@@ -625,42 +633,44 @@ static int read_pulse(struct bpctl_dev *pbpctl_dev, unsigned int ctrl_ext,
 
 			BP10GB_WRITE_REG(pbpctl_dev, MISC_REG_SPIO,
 					 (ctrl_ext | BP10GB_MDIO_DIR |
-					  BP10GB_MCLK_CLR) & ~(BP10GB_MCLK_DIR |
-							       BP10GB_MDIO_CLR |
-							       BP10GB_MDIO_SET |
-							       BP10GB_MCLK_SET));
+					  BP10GB_MCLK_CLR) &
+					 ~(BP10GB_MCLK_DIR |
+					   BP10GB_MDIO_CLR |
+					   BP10GB_MDIO_SET |
+					   BP10GB_MCLK_SET));
 
 		} else if (!pbpctl_dev->bp_10g)
-			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-								   BPCTLI_CTRL_EXT_MCLK_DIR)
-								  &
-								  ~
-								  (BPCTLI_CTRL_EXT_MDIO_DIR
-								   |
-								   BPCTLI_CTRL_EXT_MCLK_DATA)));
+			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+					   ((ctrl_ext |
+					     BPCTLI_CTRL_EXT_MCLK_DIR) &
+					    ~(BPCTLI_CTRL_EXT_MDIO_DIR |
+					      BPCTLI_CTRL_EXT_MCLK_DATA)));
 		else {
 
-			BP10G_WRITE_REG(pbpctl_dev, EODSDP, ((ctrl_ext | BP10G_MDIO_DATA_OUT) & ~BP10G_MCLK_DATA_OUT));	/* ? */
-			/*    printk("0x28=0x%x\n",BP10G_READ_REG(pbpctl_dev,EODSDP);); */
+			BP10G_WRITE_REG(pbpctl_dev, EODSDP,
+					((ctrl_ext | BP10G_MDIO_DATA_OUT) &
+					 ~BP10G_MCLK_DATA_OUT));	/* ? */
+			/*    printk("0x28=0x%x\n",
+			 *	     BP10G_READ_REG(pbpctl_dev,EODSDP);); */
 
 		}
 
 		usec_delay(PULSE_TIME);
 		if (pbpctl_dev->bp_10g9) {
-			/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext|BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9)); */
+			/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+			 * (ctrl_ext|BP10G_MCLK_DATA_OUT9|
+			 *  BP10G_MDIO_DATA_OUT9)); */
 			/* DATA ? CLK 1 */
 			BP10G_WRITE_REG(pbpctl_dev_c, ESDP,
 					(ctrl | BP10G_MCLK_DATA_OUT9 |
 					 BP10G_MCLK_DIR_OUT9));
 
 		} else if (pbpctl_dev->bp_fiber5) {
-			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-							       BPCTLI_CTRL_EXT_MCLK_DIR5
-							       |
-							       BPCTLI_CTRL_EXT_MCLK_DATA5)
-							      &
-							      ~
-							      (BPCTLI_CTRL_EXT_MDIO_DIR5)));
+			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+					   ((ctrl_ext |
+					     BPCTLI_CTRL_EXT_MCLK_DIR5 |
+					     BPCTLI_CTRL_EXT_MCLK_DATA5) &
+					    ~(BPCTLI_CTRL_EXT_MDIO_DIR5)));
 
 		} else if (pbpctl_dev->bp_i80) {
 			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
@@ -679,19 +689,18 @@ static int read_pulse(struct bpctl_dev *pbpctl_dev, unsigned int ctrl_ext,
 		} else if (pbpctl_dev->bp_10gb) {
 			BP10GB_WRITE_REG(pbpctl_dev, MISC_REG_SPIO,
 					 (ctrl_ext | BP10GB_MDIO_DIR |
-					  BP10GB_MCLK_SET) & ~(BP10GB_MCLK_DIR |
-							       BP10GB_MDIO_CLR |
-							       BP10GB_MDIO_SET |
-							       BP10GB_MCLK_CLR));
+					  BP10GB_MCLK_SET) &
+					 ~(BP10GB_MCLK_DIR |
+					   BP10GB_MDIO_CLR |
+					   BP10GB_MDIO_SET |
+					   BP10GB_MCLK_CLR));
 
 		} else if (!pbpctl_dev->bp_10g)
-			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-								   BPCTLI_CTRL_EXT_MCLK_DIR
-								   |
-								   BPCTLI_CTRL_EXT_MCLK_DATA)
-								  &
-								  ~
-								  (BPCTLI_CTRL_EXT_MDIO_DIR)));
+			BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+					   ((ctrl_ext |
+					     BPCTLI_CTRL_EXT_MCLK_DIR |
+					     BPCTLI_CTRL_EXT_MCLK_DATA) &
+					    ~(BPCTLI_CTRL_EXT_MDIO_DIR)));
 		else {
 
 			BP10G_WRITE_REG(pbpctl_dev, EODSDP,
@@ -772,7 +781,9 @@ static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 		ctrl_ext = BP10G_READ_REG(pbpctl_dev, I2CCTL);
 		ctrl = BP10G_READ_REG(pbpctl_dev_c, ESDP);
 		/* DATA 0 CLK 0 */
-		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
+		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+		 * (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|
+		 *  BP10G_MDIO_DATA_OUT9))); */
 		BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 				(ctrl_ext & ~BP10G_MDIO_DATA_OUT9));
 		BP10G_WRITE_REG(pbpctl_dev_c, ESDP,
@@ -781,22 +792,17 @@ static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 
 	} else if (pbpctl_dev->bp_fiber5) {
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL);
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MCLK_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DIR5)
-						      &
-						      ~
-						      (BPCTLI_CTRL_EXT_MDIO_DATA5
-						       |
-						       BPCTLI_CTRL_EXT_MCLK_DATA5)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR5 |
+				     BPCTLI_CTRL_EXT_MDIO_DIR5) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA5 |
+				      BPCTLI_CTRL_EXT_MCLK_DATA5)));
 	} else if (pbpctl_dev->bp_i80) {
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL);
 		ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MDIO_DIR80)
-						      &
-						      ~BPCTLI_CTRL_EXT_MDIO_DATA80));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MDIO_DIR80) &
+				    ~BPCTLI_CTRL_EXT_MDIO_DATA80));
 		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 				   ((ctrl | BPCTLI_CTRL_EXT_MCLK_DIR80) &
 				    ~BPCTLI_CTRL_EXT_MCLK_DATA80));
@@ -820,15 +826,11 @@ static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 	} else if (!pbpctl_dev->bp_10g) {
 
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DIR)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MDIO_DATA
-							   |
-							   BPCTLI_CTRL_EXT_MCLK_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR |
+				     BPCTLI_CTRL_EXT_MDIO_DIR) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA |
+				      BPCTLI_CTRL_EXT_MCLK_DATA)));
 	} else {
 		ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
 		ctrl_ext = BP10G_READ_REG(pbpctl_dev, EODSDP);
@@ -847,7 +849,9 @@ static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 	/*write data */
 	write_pulse(pbpctl_dev, ctrl_ext, value, WR_DATA_LEN);
 	if (pbpctl_dev->bp_10g9) {
-		/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
+		/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+		 * (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|
+		 *  BP10G_MDIO_DATA_OUT9))); */
 		/* DATA 0 CLK 0 */
 		BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 				(ctrl_ext & ~BP10G_MDIO_DATA_OUT9));
@@ -856,20 +860,15 @@ static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 				 ~(BP10G_MCLK_DATA_OUT9)));
 
 	} else if (pbpctl_dev->bp_fiber5) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MCLK_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DIR5)
-						      &
-						      ~
-						      (BPCTLI_CTRL_EXT_MDIO_DATA5
-						       |
-						       BPCTLI_CTRL_EXT_MCLK_DATA5)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR5 |
+				     BPCTLI_CTRL_EXT_MDIO_DIR5) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA5 |
+				      BPCTLI_CTRL_EXT_MCLK_DATA5)));
 	} else if (pbpctl_dev->bp_i80) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MDIO_DIR80)
-						      &
-						      ~BPCTLI_CTRL_EXT_MDIO_DATA80));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MDIO_DIR80) &
+				    ~BPCTLI_CTRL_EXT_MDIO_DATA80));
 		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 				   ((ctrl | BPCTLI_CTRL_EXT_MCLK_DIR80) &
 				    ~BPCTLI_CTRL_EXT_MCLK_DATA80));
@@ -887,15 +886,11 @@ static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 
 	} else if (!pbpctl_dev->bp_10g)
 
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DIR)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MDIO_DATA
-							   |
-							   BPCTLI_CTRL_EXT_MCLK_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR |
+				     BPCTLI_CTRL_EXT_MDIO_DIR) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA |
+				      BPCTLI_CTRL_EXT_MCLK_DATA)));
 	else {
 		BP10G_WRITE_REG(pbpctl_dev, EODSDP,
 				(ctrl_ext &
@@ -943,7 +938,9 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 		ctrl_ext = BP10G_READ_REG(pbpctl_dev, I2CCTL);
 		ctrl = BP10G_READ_REG(pbpctl_dev_c, ESDP);
 
-		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
+		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+		 * (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|
+		 *  BP10G_MDIO_DATA_OUT9))); */
 		/* DATA 0 CLK 0 */
 		BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 				(ctrl_ext & ~BP10G_MDIO_DATA_OUT9));
@@ -954,23 +951,18 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 	} else if (pbpctl_dev->bp_fiber5) {
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL);
 
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MCLK_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DIR5)
-						      &
-						      ~
-						      (BPCTLI_CTRL_EXT_MDIO_DATA5
-						       |
-						       BPCTLI_CTRL_EXT_MCLK_DATA5)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR5 |
+				     BPCTLI_CTRL_EXT_MDIO_DIR5) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA5 |
+				      BPCTLI_CTRL_EXT_MCLK_DATA5)));
 	} else if (pbpctl_dev->bp_i80) {
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL);
 		ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MDIO_DIR80)
-						      &
-						      ~BPCTLI_CTRL_EXT_MDIO_DATA80));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MDIO_DIR80) &
+				    ~BPCTLI_CTRL_EXT_MDIO_DATA80));
 		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 				   ((ctrl | BPCTLI_CTRL_EXT_MCLK_DIR80) &
 				    ~BPCTLI_CTRL_EXT_MCLK_DATA80));
@@ -991,7 +983,8 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 				     BP10GB_MDIO_SET | BP10GB_MCLK_SET));
 #if 0
 
-		/*BP10GB_WRITE_REG(pbpctl_dev, MISC_REG_SPIO, (ctrl_ext | BP10GB_MCLK_DIR | BP10GB_MDIO_DIR|
+		/*BP10GB_WRITE_REG(pbpctl_dev, MISC_REG_SPIO,
+		  (ctrl_ext | BP10GB_MCLK_DIR | BP10GB_MDIO_DIR|
 		   BP10GB_MCLK_CLR|BP10GB_MDIO_CLR));
 		   ctrl_ext = BP10GB_READ_REG(pbpctl_dev, MISC_REG_SPIO);
 		   printk("1reg=%x\n", ctrl_ext); */
@@ -1002,13 +995,14 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 				 & ~(BP10GB_MCLK_CLR | BP10GB_MDIO_SET |
 				     BP10GB_MCLK_DIR | BP10GB_MDIO_DIR));
 
-		/*   bnx2x_set_spio(pbpctl_dev, 5, MISC_REGISTERS_SPIO_OUTPUT_LOW);
-		   bnx2x_set_spio(pbpctl_dev, 4, MISC_REGISTERS_SPIO_OUTPUT_LOW);
-		   bnx2x_set_spio(pbpctl_dev, 4, MISC_REGISTERS_SPIO_INPUT_HI_Z); */
+		/*bnx2x_set_spio(pbpctl_dev, 5, MISC_REGISTERS_SPIO_OUTPUT_LOW);
+		  bnx2x_set_spio(pbpctl_dev, 4, MISC_REGISTERS_SPIO_OUTPUT_LOW);
+		  bnx2x_set_spio(pbpctl_dev, 4, MISC_REGISTERS_SPIO_INPUT_HI_Z);
+		 */
 
 		ctrl_ext = BP10GB_READ_REG(pbpctl_dev, MISC_REG_SPIO);
 
-		printk("2reg=%x\n", ctrl_ext);
+		pr_debug("2reg=%x\n", ctrl_ext);
 
 #ifdef BP_SYNC_FLAG
 		spin_unlock_irqrestore(&pbpctl_dev->bypass_wr_lock, flags);
@@ -1024,15 +1018,11 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DIR)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MDIO_DATA
-							   |
-							   BPCTLI_CTRL_EXT_MCLK_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR |
+				     BPCTLI_CTRL_EXT_MDIO_DIR) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA |
+				      BPCTLI_CTRL_EXT_MCLK_DATA)));
 	} else {
 
 		ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
@@ -1055,7 +1045,9 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 	/* zero */
 	if (pbpctl_dev->bp_10g9) {
 		/* DATA 0 CLK 1 */
-		/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext|BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9)); */
+		/*BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+		 * (ctrl_ext|BP10G_MCLK_DATA_OUT9|
+		 *  BP10G_MDIO_DATA_OUT9)); */
 		BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 				(ctrl_ext | BP10G_MDIO_DATA_OUT9));
 		BP10G_WRITE_REG(pbpctl_dev_c, ESDP,
@@ -1063,15 +1055,11 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 				 BP10G_MCLK_DIR_OUT9));
 
 	} else if (pbpctl_dev->bp_fiber5) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MCLK_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MCLK_DATA5)
-						      &
-						      ~
-						      (BPCTLI_CTRL_EXT_MDIO_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DATA5)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR5 |
+				     BPCTLI_CTRL_EXT_MCLK_DATA5) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DIR5 |
+				      BPCTLI_CTRL_EXT_MDIO_DATA5)));
 
 	} else if (pbpctl_dev->bp_i80) {
 		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
@@ -1095,15 +1083,11 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 				     BP10GB_MDIO_CLR | BP10GB_MCLK_CLR));
 
 	} else if (!pbpctl_dev->bp_10g)
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MCLK_DATA)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MDIO_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR |
+				     BPCTLI_CTRL_EXT_MCLK_DATA) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DIR |
+				      BPCTLI_CTRL_EXT_MDIO_DATA)));
 	else {
 
 		BP10G_WRITE_REG(pbpctl_dev, EODSDP,
@@ -1120,7 +1104,8 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 		ctrl_ext = BP10G_READ_REG(pbpctl_dev, I2CCTL);
 		ctrl = BP10G_READ_REG(pbpctl_dev_c, ESDP);
 
-		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
+		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+		 * (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
 		/* DATA 0 CLK 0 */
 		BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 				(ctrl_ext & ~BP10G_MDIO_DATA_OUT9));
@@ -1129,20 +1114,15 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 				 ~(BP10G_MCLK_DATA_OUT9)));
 
 	} else if (pbpctl_dev->bp_fiber5) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MCLK_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DIR5)
-						      &
-						      ~
-						      (BPCTLI_CTRL_EXT_MDIO_DATA5
-						       |
-						       BPCTLI_CTRL_EXT_MCLK_DATA5)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR5 |
+				     BPCTLI_CTRL_EXT_MDIO_DIR5) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA5 |
+				      BPCTLI_CTRL_EXT_MCLK_DATA5)));
 	} else if (pbpctl_dev->bp_i80) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MDIO_DIR80)
-						      &
-						      ~BPCTLI_CTRL_EXT_MDIO_DATA80));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MDIO_DIR80) &
+				    ~BPCTLI_CTRL_EXT_MDIO_DATA80));
 		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 				   ((ctrl | BPCTLI_CTRL_EXT_MCLK_DIR80) &
 				    ~BPCTLI_CTRL_EXT_MCLK_DATA80));
@@ -1162,15 +1142,11 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 				     BP10GB_MDIO_SET | BP10GB_MCLK_SET));
 
 	} else if (!pbpctl_dev->bp_10g) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DIR)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MDIO_DATA
-							   |
-							   BPCTLI_CTRL_EXT_MCLK_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR |
+				     BPCTLI_CTRL_EXT_MDIO_DIR) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA |
+				      BPCTLI_CTRL_EXT_MCLK_DATA)));
 	} else {
 
 		ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
@@ -1215,7 +1191,8 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 		ctrl_ext = BP10G_READ_REG(pbpctl_dev, I2CCTL);
 		ctrl = BP10G_READ_REG(pbpctl_dev_c, ESDP);
 
-		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
+		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+		 * (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
 		/* DATA 0 CLK 0 */
 		BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 				(ctrl_ext & ~BP10G_MDIO_DATA_OUT9));
@@ -1225,22 +1202,17 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 
 	} else if (pbpctl_dev->bp_fiber5) {
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL);
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MCLK_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DIR5)
-						      &
-						      ~
-						      (BPCTLI_CTRL_EXT_MDIO_DATA5
-						       |
-						       BPCTLI_CTRL_EXT_MCLK_DATA5)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR5 |
+				     BPCTLI_CTRL_EXT_MDIO_DIR5) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA5 |
+				      BPCTLI_CTRL_EXT_MCLK_DATA5)));
 	} else if (pbpctl_dev->bp_i80) {
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL);
 		ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MDIO_DIR80)
-						      &
-						      ~BPCTLI_CTRL_EXT_MDIO_DATA80));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MDIO_DIR80) &
+				    ~BPCTLI_CTRL_EXT_MDIO_DATA80));
 		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 				   ((ctrl | BPCTLI_CTRL_EXT_MCLK_DIR80) &
 				    ~BPCTLI_CTRL_EXT_MCLK_DATA80));
@@ -1260,15 +1232,11 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 	} else if (!pbpctl_dev->bp_10g) {
 
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DIR)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MDIO_DATA
-							   |
-							   BPCTLI_CTRL_EXT_MCLK_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR |
+				     BPCTLI_CTRL_EXT_MDIO_DIR) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA |
+				      BPCTLI_CTRL_EXT_MCLK_DATA)));
 	} else {
 
 		ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
@@ -1279,7 +1247,8 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 
 	}
 	if (pbpctl_dev->bp_10g9) {
-		/*   BP10G_WRITE_REG(pbpctl_dev, I2CCTL, ((ctrl_ext|BP10G_MCLK_DATA_OUT9)&~BP10G_MDIO_DATA_OUT9)); */
+		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+		 * ((ctrl_ext|BP10G_MCLK_DATA_OUT9)&~BP10G_MDIO_DATA_OUT9)); */
 		/* DATA 0 CLK 1 */
 		BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 				(ctrl_ext & ~BP10G_MDIO_DATA_OUT9));
@@ -1288,20 +1257,15 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 				 BP10G_MCLK_DIR_OUT9));
 
 	} else if (pbpctl_dev->bp_fiber5) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MCLK_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MCLK_DATA5)
-						      &
-						      ~
-						      (BPCTLI_CTRL_EXT_MDIO_DATA5)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR5 |
+				     BPCTLI_CTRL_EXT_MDIO_DIR5 |
+				     BPCTLI_CTRL_EXT_MCLK_DATA5) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA5)));
 	} else if (pbpctl_dev->bp_i80) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MDIO_DIR80)
-						      &
-						      ~BPCTLI_CTRL_EXT_MDIO_DATA80));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MDIO_DIR80) &
+				    ~BPCTLI_CTRL_EXT_MDIO_DATA80));
 		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 				   (ctrl | BPCTLI_CTRL_EXT_MCLK_DIR80 |
 				    BPCTLI_CTRL_EXT_MCLK_DATA80));
@@ -1322,15 +1286,11 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 				     BP10GB_MDIO_SET | BP10GB_MCLK_CLR));
 
 	} else if (!pbpctl_dev->bp_10g)
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MCLK_DATA)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MDIO_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR |
+				     BPCTLI_CTRL_EXT_MDIO_DIR |
+				     BPCTLI_CTRL_EXT_MCLK_DATA) &
+				    ~(BPCTLI_CTRL_EXT_MDIO_DATA)));
 	else {
 
 		BP10G_WRITE_REG(pbpctl_dev, EODSDP,
@@ -1341,7 +1301,8 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 
 	usec_delay(WDT_INTERVAL);
 	if (pbpctl_dev->bp_10g9) {
-		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL, (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
+		/* BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
+		 * (ctrl_ext&~(BP10G_MCLK_DATA_OUT9|BP10G_MDIO_DATA_OUT9))); */
 		/* DATA 0 CLK 0 */
 		BP10G_WRITE_REG(pbpctl_dev, I2CCTL,
 				(ctrl_ext & ~BP10G_MDIO_DATA_OUT9));
@@ -1350,20 +1311,15 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 				 ~(BP10G_MCLK_DATA_OUT9)));
 
 	} else if (pbpctl_dev->bp_fiber5) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MCLK_DIR5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DIR5)
-						      &
-						      ~
-						      (BPCTLI_CTRL_EXT_MCLK_DATA5
-						       |
-						       BPCTLI_CTRL_EXT_MDIO_DATA5)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR5 |
+				     BPCTLI_CTRL_EXT_MDIO_DIR5) &
+				    ~(BPCTLI_CTRL_EXT_MCLK_DATA5 |
+				      BPCTLI_CTRL_EXT_MDIO_DATA5)));
 	} else if (pbpctl_dev->bp_i80) {
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL, ((ctrl_ext |
-						       BPCTLI_CTRL_EXT_MDIO_DIR80)
-						      &
-						      ~BPCTLI_CTRL_EXT_MDIO_DATA80));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MDIO_DIR80) &
+				    ~BPCTLI_CTRL_EXT_MDIO_DATA80));
 		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 				   ((ctrl | BPCTLI_CTRL_EXT_MCLK_DIR80) &
 				    ~BPCTLI_CTRL_EXT_MCLK_DATA80));
@@ -1382,22 +1338,18 @@ static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 				     BP10GB_MDIO_SET | BP10GB_MCLK_SET));
 
 	} else if (!pbpctl_dev->bp_10g)
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DIR)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MCLK_DATA
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR |
+				     BPCTLI_CTRL_EXT_MDIO_DIR) &
+				    ~(BPCTLI_CTRL_EXT_MCLK_DATA |
+				      BPCTLI_CTRL_EXT_MDIO_DATA)));
 	else {
 
 		BP10G_WRITE_REG(pbpctl_dev, EODSDP,
 				(ctrl_ext &
 				 ~(BP10G_MCLK_DATA_OUT | BP10G_MDIO_DATA_OUT)));
 	}
-	if ((pbpctl_dev->wdt_status == WDT_STATUS_EN))
+	if (pbpctl_dev->wdt_status == WDT_STATUS_EN)
 		/*&& (pbpctl_dev->bp_ext_ver<PXG4BPFI_VER) */
 		pbpctl_dev->bypass_wdt_on_time = jiffies;
 #ifdef BP_SYNC_FLAG
@@ -1422,19 +1374,18 @@ static void data_pulse(struct bpctl_dev *pbpctl_dev, unsigned char value)
 #endif
 
 	ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
-	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-						   BPCTLI_CTRL_EXT_SDP6_DIR |
-						   BPCTLI_CTRL_EXT_SDP7_DIR) &
-						  ~(BPCTLI_CTRL_EXT_SDP6_DATA |
-						    BPCTLI_CTRL_EXT_SDP7_DATA)));
+	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+			   ((ctrl_ext | BPCTLI_CTRL_EXT_SDP6_DIR |
+			     BPCTLI_CTRL_EXT_SDP7_DIR) &
+			    ~(BPCTLI_CTRL_EXT_SDP6_DATA |
+			      BPCTLI_CTRL_EXT_SDP7_DATA)));
 
 	usec_delay(INIT_CMND_INTERVAL);
-	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-						   BPCTLI_CTRL_EXT_SDP6_DIR |
-						   BPCTLI_CTRL_EXT_SDP7_DIR |
-						   BPCTLI_CTRL_EXT_SDP6_DATA) &
-						  ~
-						  (BPCTLI_CTRL_EXT_SDP7_DATA)));
+	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+			   ((ctrl_ext | BPCTLI_CTRL_EXT_SDP6_DIR |
+			     BPCTLI_CTRL_EXT_SDP7_DIR |
+			     BPCTLI_CTRL_EXT_SDP6_DATA) &
+			    ~(BPCTLI_CTRL_EXT_SDP7_DATA)));
 	usec_delay(INIT_CMND_INTERVAL);
 
 	while (value) {
@@ -1444,24 +1395,21 @@ static void data_pulse(struct bpctl_dev *pbpctl_dev, unsigned char value)
 				   BPCTLI_CTRL_EXT_SDP6_DATA |
 				   BPCTLI_CTRL_EXT_SDP7_DATA);
 		usec_delay(PULSE_INTERVAL);
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_SDP6_DIR
-							   |
-							   BPCTLI_CTRL_EXT_SDP7_DIR
-							   |
-							   BPCTLI_CTRL_EXT_SDP6_DATA)
-							  &
-							  ~BPCTLI_CTRL_EXT_SDP7_DATA));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_SDP6_DIR |
+				     BPCTLI_CTRL_EXT_SDP7_DIR |
+				     BPCTLI_CTRL_EXT_SDP6_DATA) &
+				    ~BPCTLI_CTRL_EXT_SDP7_DATA));
 		usec_delay(PULSE_INTERVAL);
 		value--;
 
 	}
 	usec_delay(INIT_CMND_INTERVAL - PULSE_INTERVAL);
-	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-						   BPCTLI_CTRL_EXT_SDP6_DIR |
-						   BPCTLI_CTRL_EXT_SDP7_DIR) &
-						  ~(BPCTLI_CTRL_EXT_SDP6_DATA |
-						    BPCTLI_CTRL_EXT_SDP7_DATA)));
+	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+			   ((ctrl_ext | BPCTLI_CTRL_EXT_SDP6_DIR |
+			     BPCTLI_CTRL_EXT_SDP7_DIR) &
+			    ~(BPCTLI_CTRL_EXT_SDP6_DATA |
+			      BPCTLI_CTRL_EXT_SDP7_DATA)));
 	usec_delay(WDT_TIME_CNT);
 	if (pbpctl_dev->wdt_status == WDT_STATUS_EN)
 		pbpctl_dev->bypass_wdt_on_time = jiffies;
@@ -1570,19 +1518,15 @@ int zero_set_fn(struct bpctl_dev *pbpctl_dev)
 		return -1;
 
 	if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-		printk("zero_set");
+		pr_debug("zero_set");
 
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 
-		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
-							   BPCTLI_CTRL_EXT_MCLK_DIR)
-							  &
-							  ~
-							  (BPCTLI_CTRL_EXT_MCLK_DATA
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DIR
-							   |
-							   BPCTLI_CTRL_EXT_MDIO_DATA)));
+		BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
+				   ((ctrl_ext | BPCTLI_CTRL_EXT_MCLK_DIR) &
+				    ~(BPCTLI_CTRL_EXT_MCLK_DATA |
+				      BPCTLI_CTRL_EXT_MDIO_DIR |
+				      BPCTLI_CTRL_EXT_MDIO_DATA)));
 
 	}
 	return 0;
@@ -1596,10 +1540,10 @@ int pulse_get2_fn(struct bpctl_dev *pbpctl_dev)
 		return -1;
 
 	if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-		printk("pulse_get_fn\n");
+		pr_debug("pulse_get_fn\n");
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 		ctrl_value = read_pulse_2(pbpctl_dev, ctrl_ext);
-		printk("read:%d\n", ctrl_value);
+		pr_debug("read:%d\n", ctrl_value);
 	}
 	return ctrl_value;
 }
@@ -1613,11 +1557,11 @@ int pulse_get1_fn(struct bpctl_dev *pbpctl_dev)
 
 	if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
 
-		printk("pulse_get_fn\n");
+		pr_debug("pulse_get_fn\n");
 
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 		ctrl_value = read_pulse_1(pbpctl_dev, ctrl_ext);
-		printk("read:%d\n", ctrl_value);
+		pr_debug("read:%d\n", ctrl_value);
 	}
 	return ctrl_value;
 }
@@ -1878,7 +1822,8 @@ static int disc_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 
-	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
+	if ((pbpctl_dev->bp_caps & DISC_CAP) &&
+	    (pbpctl_dev->bp_ext_ver >= 0x8)) {
 		write_data(pbpctl_dev, DISC_OFF);
 		msec_delay_bp(LATCH_DELAY);
 	} else
@@ -1891,7 +1836,8 @@ static int disc_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 
-	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
+	if ((pbpctl_dev->bp_caps & DISC_CAP) &&
+	    (pbpctl_dev->bp_ext_ver >= 0x8)) {
 		write_data(pbpctl_dev, /*DISC_ON */ 0x85);
 		msec_delay_bp(LATCH_DELAY);
 	} else
@@ -1982,6 +1928,7 @@ static int wdt_on(struct bpctl_dev *pbpctl_dev, unsigned int timeout)
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		unsigned int pulse = 0, temp_value = 0, temp_cnt = 0;
+
 		pbpctl_dev->wdt_status = 0;
 
 		if (INTEL_IF_SERIES(pbpctl_dev->subdevice)) {
@@ -2058,8 +2005,7 @@ static s32 bp75_get_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
 	}
 
 	if (i == timeout) {
-		printk
-		    ("bpctl_mod: Driver can't access device - SMBI bit is set.\n");
+		pr_debug("bpctl_mod: Driver can't access device - SMBI bit is set.\n");
 		ret_val = -1;
 		goto out;
 	}
@@ -2079,7 +2025,7 @@ static s32 bp75_get_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
 	if (i == timeout) {
 		/* Release semaphores */
 		bp75_put_hw_semaphore_generic(pbpctl_dev);
-		printk("bpctl_mod: Driver can't access the NVM\n");
+		pr_debug("bpctl_mod: Driver can't access the NVM\n");
 		ret_val = -1;
 		goto out;
 	}
@@ -2139,8 +2085,7 @@ static s32 bp75_acquire_phy(struct bpctl_dev *pbpctl_dev)
 	}
 
 	if (i == timeout) {
-		printk
-		    ("bpctl_mod: Driver can't access resource, SW_FW_SYNC timeout.\n");
+		pr_debug("bpctl_mod: Driver can't access resource, SW_FW_SYNC timeout.\n");
 		ret_val = -1;
 		goto out;
 	}
@@ -2173,12 +2118,12 @@ static s32 bp75_read_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset,
 			break;
 	}
 	if (!(mdic & BPCTLI_MDIC_READY)) {
-		printk("bpctl_mod: MDI Read did not complete\n");
+		pr_debug("bpctl_mod: MDI Read did not complete\n");
 		ret_val = -1;
 		goto out;
 	}
 	if (mdic & BPCTLI_MDIC_ERROR) {
-		printk("bpctl_mod: MDI Error\n");
+		pr_debug("bpctl_mod: MDI Error\n");
 		ret_val = -1;
 		goto out;
 	}
@@ -2208,12 +2153,12 @@ static s32 bp75_write_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset,
 			break;
 	}
 	if (!(mdic & BPCTLI_MDIC_READY)) {
-		printk("bpctl_mod: MDI Write did not complete\n");
+		pr_debug("bpctl_mod: MDI Write did not complete\n");
 		ret_val = -1;
 		goto out;
 	}
 	if (mdic & BPCTLI_MDIC_ERROR) {
-		printk("bpctl_mod: MDI Error\n");
+		pr_debug("bpctl_mod: MDI Error\n");
 		ret_val = -1;
 		goto out;
 	}
@@ -2222,7 +2167,8 @@ static s32 bp75_write_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset,
 	return ret_val;
 }
 
-static s32 bp75_read_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset, u16 *data)
+static s32 bp75_read_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset,
+			     u16 *data)
 {
 	s32 ret_val = 0;
 
@@ -2231,9 +2177,10 @@ static s32 bp75_read_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset, u16 *data
 		goto out;
 
 	if (offset > BPCTLI_MAX_PHY_MULTI_PAGE_REG) {
-		ret_val = bp75_write_phy_reg_mdic(pbpctl_dev,
-						  BPCTLI_IGP01E1000_PHY_PAGE_SELECT,
-						  (u16) offset);
+		ret_val =
+		    bp75_write_phy_reg_mdic(pbpctl_dev,
+					    BPCTLI_IGP01E1000_PHY_PAGE_SELECT,
+					    (u16) offset);
 		if (ret_val)
 			goto release;
 	}
@@ -2248,7 +2195,8 @@ static s32 bp75_read_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset, u16 *data
 	return ret_val;
 }
 
-static s32 bp75_write_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset, u16 data)
+static s32 bp75_write_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset,
+			      u16 data)
 {
 	s32 ret_val = 0;
 
@@ -2257,9 +2205,10 @@ static s32 bp75_write_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset, u16 data
 		goto out;
 
 	if (offset > BPCTLI_MAX_PHY_MULTI_PAGE_REG) {
-		ret_val = bp75_write_phy_reg_mdic(pbpctl_dev,
-						  BPCTLI_IGP01E1000_PHY_PAGE_SELECT,
-						  (u16) offset);
+		ret_val =
+		    bp75_write_phy_reg_mdic(pbpctl_dev,
+					    BPCTLI_IGP01E1000_PHY_PAGE_SELECT,
+					    (u16) offset);
 		if (ret_val)
 			goto release;
 	}
@@ -2320,11 +2269,13 @@ static int set_tx(struct bpctl_dev *pbpctl_dev, int tx_state)
 		if (PEG5_IF_SERIES(pbpctl_dev->subdevice)) {
 			if (tx_state) {
 				uint16_t mii_reg;
+
 				ret = bp75_read_phy_reg(pbpctl_dev,
 					      BPCTLI_PHY_CONTROL,
 					      &mii_reg);
 				if (!ret) {
-					if (mii_reg & BPCTLI_MII_CR_POWER_DOWN) {
+					if (mii_reg &
+					    BPCTLI_MII_CR_POWER_DOWN) {
 						ret =
 						    bp75_write_phy_reg
 						    (pbpctl_dev,
@@ -2335,6 +2286,7 @@ static int set_tx(struct bpctl_dev *pbpctl_dev, int tx_state)
 				}
 			} else {
 				uint16_t mii_reg;
+
 				ret = bp75_read_phy_reg(pbpctl_dev,
 					      BPCTLI_PHY_CONTROL,
 					      &mii_reg);
@@ -2418,7 +2370,8 @@ static int set_tx(struct bpctl_dev *pbpctl_dev, int tx_state)
 				BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT,
 						   ((ctrl |
 						     BPCTLI_CTRL_EXT_SDP6_DIR) &
-						    ~BPCTLI_CTRL_EXT_SDP6_DATA));
+						    ~
+						    BPCTLI_CTRL_EXT_SDP6_DATA));
 
 			} else if (pbpctl_dev->bp_10gb) {
 				if ((bpctl_dev_arr->func == 1)
@@ -2781,7 +2734,8 @@ static int std_nic_off(struct bpctl_dev *pbpctl_dev)
 int wdt_time_left(struct bpctl_dev *pbpctl_dev)
 {
 
-	/* unsigned long curr_time=((long long)(jiffies*1000))/HZ, delta_time=0,wdt_on_time=((long long)(pbpctl_dev->bypass_wdt_on_time*1000))/HZ; */
+	/* unsigned long curr_time=((long long)(jiffies*1000))/HZ, delta_time=0,
+	 * wdt_on_time=((long long)(pbpctl_dev->bypass_wdt_on_time*1000))/HZ; */
 	unsigned long curr_time = jiffies, delta_time = 0, wdt_on_time =
 	    pbpctl_dev->bypass_wdt_on_time, delta_time_msec = 0;
 	int time_left = 0;
@@ -2865,7 +2819,8 @@ static void wd_reset_timer(unsigned long param)
 
 	if (pbpctl_dev->bp_self_test_flag == 1) {
 		skb_tmp = dev_alloc_skb(BPTEST_DATA_LEN + 2);
-		if ((skb_tmp) && (pbpctl_dev->ndev) && (pbpctl_dev->bp_tx_data)) {
+		if ((skb_tmp) && (pbpctl_dev->ndev) &&
+		    (pbpctl_dev->bp_tx_data)) {
 			memcpy(skb_put(skb_tmp, BPTEST_DATA_LEN),
 			       pbpctl_dev->bp_tx_data, BPTEST_DATA_LEN);
 			skb_tmp->dev = pbpctl_dev->ndev;
@@ -3049,6 +3004,7 @@ static int tx_status(struct bpctl_dev *pbpctl_dev)
 	if (pbpctl_dev->bp_caps & TX_CTL_CAP) {
 		if (PEG5_IF_SERIES(pbpctl_dev->subdevice)) {
 			uint16_t mii_reg;
+
 			if (!
 			    (bp75_read_phy_reg
 			     (pbpctl_dev, BPCTLI_PHY_CONTROL, &mii_reg))) {
@@ -3177,6 +3133,7 @@ static int bypass_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 	if (pbpctl_dev->bp_caps & BP_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
 			uint32_t status_reg = 0;
+
 			status_reg = read_reg(pbpctl_dev, STATUS_REG_ADDR);
 			write_reg(pbpctl_dev, status_reg & ~BYPASS_FLAG_MASK,
 				  STATUS_REG_ADDR);
@@ -3343,12 +3300,14 @@ static int wdt_programmed(struct bpctl_dev *pbpctl_dev, int *timeout)
 			if ((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
 			    WDT_EN_MASK) {
 				u8 wdt_val;
+
 				wdt_val = read_reg(pbpctl_dev, WDT_REG_ADDR);
 				*timeout = (1 << wdt_val) * 100;
 			} else
 				*timeout = 0;
 		} else {
 			int curr_wdt_status = pbpctl_dev->wdt_status;
+
 			if (curr_wdt_status == WDT_STATUS_UNKNOWN)
 				*timeout = -1;
 			else
@@ -3767,21 +3726,21 @@ static void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
 
 	if (!(INTEL_IF_SERIES(adapter->bp_device_block.subdevice))) {
 		ret = read_reg(pbpctl_dev, VER_REG_ADDR);
-		printk("VER_REG reg1=%x\n", ret);
+		pr_debug("VER_REG reg1=%x\n", ret);
 		ret = read_reg(pbpctl_dev, PRODUCT_CAP_REG_ADDR);
-		printk("PRODUCT_CAP reg=%x\n", ret);
+		pr_debug("PRODUCT_CAP reg=%x\n", ret);
 		ret = read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR);
-		printk("STATUS_TAP reg1=%x\n", ret);
+		pr_debug("STATUS_TAP reg1=%x\n", ret);
 		ret = read_reg(pbpctl_dev, 0x7);
-		printk("SIG_REG reg1=%x\n", ret);
+		pr_debug("SIG_REG reg1=%x\n", ret);
 		ret = read_reg(pbpctl_dev, STATUS_REG_ADDR);
-		printk("STATUS_REG_ADDR=%x\n", ret);
+		pr_debug("STATUS_REG_ADDR=%x\n", ret);
 		ret = read_reg(pbpctl_dev, WDT_REG_ADDR);
-		printk("WDT_REG_ADDR=%x\n", ret);
+		pr_debug("WDT_REG_ADDR=%x\n", ret);
 		ret = read_reg(pbpctl_dev, TMRL_REG_ADDR);
-		printk("TMRL_REG_ADDR=%x\n", ret);
+		pr_debug("TMRL_REG_ADDR=%x\n", ret);
 		ret = read_reg(pbpctl_dev, TMRH_REG_ADDR);
-		printk("TMRH_REG_ADDR=%x\n", ret);
+		pr_debug("TMRH_REG_ADDR=%x\n", ret);
 	}
 #endif
 	if ((pbpctl_dev->bp_fiber5) || (pbpctl_dev->bp_10g9)) {
@@ -3965,6 +3924,7 @@ static void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
 	pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
 	if (pbpctl_dev_m != NULL) {
 		int cap_reg = 0;
+
 		if (pbpctl_dev_m->bp_ext_ver >= 0x9) {
 			cap_reg = get_bp_prod_caps(pbpctl_dev_m);
 			if ((cap_reg & DISC_PORT_SUPPORT_MASK) ==
@@ -4033,7 +3993,7 @@ int bp_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 	if (!pbpctl_dev)
 		return 1;
-	if ((htons(ETH_P_BPTEST) == eth->h_proto)) {
+	if (htons(ETH_P_BPTEST) == eth->h_proto) {
 
 		pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
 		if (pbpctl_dev_m) {
@@ -4089,7 +4049,8 @@ int set_bp_self_test(struct bpctl_dev *pbpctl_dev, unsigned int param)
 		pbpctl_dev->bp_self_test_flag = param == 0 ? 0 : 1;
 		pbpctl_dev_sl = get_status_port_fn(pbpctl_dev);
 
-		if ((pbpctl_dev_sl->ndev) && (pbpctl_dev_sl->ndev->netdev_ops)) {
+		if ((pbpctl_dev_sl->ndev) &&
+		    (pbpctl_dev_sl->ndev->netdev_ops)) {
 			rtnl_lock();
 			if (pbpctl_dev->bp_self_test_flag == 1) {
 
@@ -4428,7 +4389,8 @@ static int set_dis_tap_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 	if (!pbpctl_dev)
 		return -1;
 
-	if ((pbpctl_dev->bp_caps & TAP_DIS_CAP) && ((cmnd_on(pbpctl_dev)) >= 0)) {
+	if ((pbpctl_dev->bp_caps & TAP_DIS_CAP) &&
+	    ((cmnd_on(pbpctl_dev)) >= 0)) {
 		if (dis_param)
 			ret = dis_tap_cap(pbpctl_dev);
 		else
@@ -4773,6 +4735,7 @@ static void bp_tpl_timer_fn(unsigned long param)
 static void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b;
+
 	if (!pbpctl_dev)
 		return;
 
@@ -4784,7 +4747,6 @@ static void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 			set_tx(pbpctl_dev_b, 1);
 		set_tx(pbpctl_dev, 1);
 	}
-	return;
 }
 
 static int init_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
@@ -4822,6 +4784,7 @@ static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 {
 
 	struct bpctl_dev *pbpctl_dev_b;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -5012,7 +4975,7 @@ static void if_scan_init(void)
 }
 
 static long device_ioctl(struct file *file,	/* see include/linux/fs.h */
-			 unsigned int ioctl_num,	/* number and param for ioctl */
+			 unsigned int ioctl_num,/* number and param for ioctl */
 			 unsigned long ioctl_param)
 {
 	struct bpctl_cmd bpctl_cmd;
@@ -5101,8 +5064,8 @@ static long device_ioctl(struct file *file,	/* see include/linux/fs.h */
 
 	if ((bpctl_dev_arr[dev_idx].bp_10gb)
 	    && (!(bpctl_dev_arr[dev_idx].ifindex))) {
-		printk("Please load network driver for %s adapter!\n",
-		       bpctl_dev_arr[dev_idx].name);
+		pr_debug("Please load network driver for %s adapter!\n",
+			 bpctl_dev_arr[dev_idx].name);
 		bpctl_cmd.status = -1;
 		ret = SUCCESS;
 		/* preempt_enable(); */
@@ -5114,9 +5077,8 @@ static long device_ioctl(struct file *file,	/* see include/linux/fs.h */
 	if ((bpctl_dev_arr[dev_idx].bp_10gb) && (bpctl_dev_arr[dev_idx].ndev)) {
 		if (!(bpctl_dev_arr[dev_idx].ndev->flags & IFF_UP)) {
 			if (!(bpctl_dev_arr[dev_idx].ndev->flags & IFF_UP)) {
-				printk
-				    ("Please bring up network interfaces for %s adapter!\n",
-				     bpctl_dev_arr[dev_idx].name);
+				pr_debug("Please bring up network interfaces for %s adapter!\n",
+					 bpctl_dev_arr[dev_idx].name);
 				bpctl_cmd.status = -1;
 				ret = SUCCESS;
 				/* preempt_enable(); */
@@ -5898,7 +5860,8 @@ static struct bpmod_info tx_ctl_pci_tbl[] = {
 	{BROADCOM_VID, BROADCOM_PE10G2_PID, SILICOM_SVID,
 	 SILICOM_PE10G2BPTT_SSID, PE10G2BPTT, "PE10G2BPTT"},
 
-	/* {BROADCOM_VID, BROADCOM_PE10G2_PID, PCI_ANY_ID, PCI_ANY_ID, PE10G2BPTCX4, "PE10G2BPTCX4"}, */
+	/* {BROADCOM_VID, BROADCOM_PE10G2_PID, PCI_ANY_ID, PCI_ANY_ID,
+	 *  PE10G2BPTCX4, "PE10G2BPTCX4"}, */
 
 	{0x8086, 0x10c9, SILICOM_SVID /*PCI_ANY_ID */ ,
 	 SILICOM_PEG4BPI6_SSID /*PCI_ANY_ID */ , PEG4BPI6, "PEG4BPI6"},
@@ -6250,6 +6213,7 @@ static void find_fw(struct bpctl_dev *dev)
 
 	if (dev->bp_10gb == 1 && dev->bp_fw_ver == 0xff) {
 		int cnt = 100;
+
 		while (cnt--) {
 			iounmap((void *)dev->mem_map);
 			mmio_start = pci_resource_start(pdev1, 0);
@@ -6264,10 +6228,11 @@ static void find_fw(struct bpctl_dev *dev)
 		}
 	}
 	/* dev->bp_fw_ver=0xa8; */
-	printk("firmware version: 0x%x\n", dev->bp_fw_ver);
+	pr_debug("firmware version: 0x%x\n", dev->bp_fw_ver);
 }
 
-static int init_one(struct bpctl_dev *dev, struct bpmod_info *info, struct pci_dev *pdev1)
+static int init_one(struct bpctl_dev *dev, struct bpmod_info *info,
+		    struct pci_dev *pdev1)
 {
 	unsigned long mmio_start, mmio_len;
 
@@ -6305,15 +6270,15 @@ static int init_one(struct bpctl_dev *dev, struct bpmod_info *info, struct pci_d
 	if (BP10GB_IF_SERIES(dev->subdevice)) {
 		if (dev->ifindex == 0) {
 			unregister_chrdev(major_num, DEVICE_NAME);
-			printk("Please load network driver for %s adapter!\n",
-			     dev->name);
+			pr_debug("Please load network driver for %s adapter!\n",
+				 dev->name);
 			return -1;
 		}
 
 		if (dev->ndev && !(dev->ndev->flags & IFF_UP)) {
 			unregister_chrdev(major_num, DEVICE_NAME);
-			printk("Please bring up network interfaces for %s adapter!\n",
-			     dev->name);
+			pr_debug("Please bring up network interfaces for %s adapter!\n",
+				 dev->name);
 			return -1;
 		}
 		dev->bp_10gb = 1;
@@ -6321,8 +6286,7 @@ static int init_one(struct bpctl_dev *dev, struct bpmod_info *info, struct pci_d
 
 	if (!dev->bp_10g9) {
 		if (is_bypass_fn(dev)) {
-			printk(KERN_INFO "%s found, ",
-			       dev->name);
+			pr_info(KERN_INFO "%s found, ", dev->name);
 			find_fw(dev);
 		}
 		dev->wdt_status = WDT_STATUS_UNKNOWN;
@@ -6345,7 +6309,7 @@ static int init_one(struct bpctl_dev *dev, struct bpmod_info *info, struct pci_d
 		memset(dev->bp_tx_data + 7, 0xaa, 5);
 		*(__be16 *)(dev->bp_tx_data + 12) = htons(ETH_P_BPTEST);
 	} else
-		printk("bp_ctl: Memory allocation error!\n");
+		pr_debug("bp_ctl: Memory allocation error!\n");
 #endif
 	return 0;
 }
@@ -6363,7 +6327,7 @@ static int __init bypass_init_module(void)
 	printk(BP_MOD_DESCR " v" BP_MOD_VER "\n");
 	ret_val = register_chrdev(major_num, DEVICE_NAME, &Fops);
 	if (ret_val < 0) {
-		printk("%s failed with %d\n", DEVICE_NAME, ret_val);
+		pr_debug("%s failed with %d\n", DEVICE_NAME, ret_val);
 		return ret_val;
 	}
 	major_num = ret_val;	/* dynamic */
@@ -6378,15 +6342,16 @@ static int __init bypass_init_module(void)
 		}
 	}
 	if (!device_num) {
-		printk("No such device\n");
+		pr_debug("No such device\n");
 		unregister_chrdev(major_num, DEVICE_NAME);
 		return -1;
 	}
 
-	bpctl_dev_arr = kmalloc((device_num) * sizeof(struct bpctl_dev), GFP_KERNEL);
+	bpctl_dev_arr = kmalloc((device_num) * sizeof(struct bpctl_dev),
+				GFP_KERNEL);
 
 	if (!bpctl_dev_arr) {
-		printk("Allocation error\n");
+		pr_debug("Allocation error\n");
 		unregister_chrdev(major_num, DEVICE_NAME);
 		return -1;
 	}
@@ -6415,10 +6380,10 @@ static int __init bypass_init_module(void)
 	     idx_dev++, dev++) {
 		if (dev->bp_10g9) {
 			if (is_bypass_fn(dev)) {
-				printk(KERN_INFO "%s found, ", dev->name);
+				pr_info("%s found, ", dev->name);
 				dev->bp_fw_ver = bypass_fw_ver(dev);
-				printk("firmware version: 0x%x\n",
-				       dev->bp_fw_ver);
+				pr_info("firmware version: 0x%x\n",
+					dev->bp_fw_ver);
 			}
 			dev->wdt_status = WDT_STATUS_UNKNOWN;
 			dev->reset_time = 0;
@@ -6778,7 +6743,8 @@ EXPORT_SYMBOL(get_bp_hw_reset_sd);
 
 int get_bypass_info_sd(int ifindex, struct bp_info *bp_info)
 {
-	return get_bypass_info_fn(get_dev_idx_p(ifindex), bp_info->prod_name, &bp_info->fw_ver);
+	return get_bypass_info_fn(get_dev_idx_p(ifindex), bp_info->prod_name,
+				  &bp_info->fw_ver);
 }
 EXPORT_SYMBOL(get_bypass_info_sd);
 
@@ -7467,8 +7433,8 @@ static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block)
 	/* create device proc dir */
 	procfs_dir = proc_mkdir(current_pfs->dir_name, bp_procfs_dir);
 	if (!procfs_dir) {
-		printk(KERN_DEBUG "Could not create procfs directory %s\n",
-		       current_pfs->dir_name);
+		pr_debug("Could not create procfs directory %s\n",
+			 current_pfs->dir_name);
 		return -1;
 	}
 	current_pfs->bypass_entry = procfs_dir;
@@ -7515,7 +7481,7 @@ static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block)
 	}
 #undef ENTRY
 	if (ret < 0)
-		printk(KERN_DEBUG "Create proc entry failed\n");
+		pr_debug("Create proc entry failed\n");
 
 	return ret;
 }

