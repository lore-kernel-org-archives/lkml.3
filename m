Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3LEVWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:22:12 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:37149 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3LEVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:22:08 -0500
From: Will Tange <bh34rt@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Will Tange <bh34rt@gmail.com>
Subject: [PATCH] staging: silicom: fix 'return is not a function, parentheses are not required' in bpctl_mod.c
Date: Thu,  5 Dec 2013 22:23:53 +0100
Message-Id: <1386278633-29641-1-git-send-email-bh34rt@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes warnings regarding redundant parantheses thrown by the checkpatch tool in bpctl_mod.c

Signed-off-by: Will Tange <bh34rt@gmail.com>
---
 drivers/staging/silicom/bpctl_mod.c | 122 ++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 39dc92a..ffd5d48 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -3125,11 +3125,11 @@ static int tx_status(struct bpctl_dev *pbpctl_dev)
 
 		ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL);
 		if (pbpctl_dev->bp_i80)
-			return ((ctrl & BPCTLI_CTRL_SWDPIN1) != 0 ? 0 : 1);
+			return (ctrl & BPCTLI_CTRL_SWDPIN1) != 0 ? 0 : 1;
 		if (pbpctl_dev->bp_540) {
 			ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
 
-			return ((ctrl & BP10G_SDP1_DATA) != 0 ? 0 : 1);
+			return (ctrl & BP10G_SDP1_DATA) != 0 ? 0 : 1;
 		}
 
 	}
@@ -3150,8 +3150,8 @@ static int tx_status(struct bpctl_dev *pbpctl_dev)
 		}
 
 		if (pbpctl_dev->bp_10g9) {
-			return ((BP10G_READ_REG(pbpctl_dev, ESDP) &
-				 BP10G_SDP3_DATA) != 0 ? 0 : 1);
+			return (BP10G_READ_REG(pbpctl_dev, ESDP) &
+				 BP10G_SDP3_DATA) != 0 ? 0 : 1;
 
 		} else if (pbpctl_dev->bp_fiber5) {
 			ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
@@ -3186,10 +3186,10 @@ static int tx_status(struct bpctl_dev *pbpctl_dev)
 			if (pbpctl_dev->bp_540) {
 				ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
 
-				return ((ctrl & BP10G_SDP1_DATA) != 0 ? 0 : 1);
+				return (ctrl & BP10G_SDP1_DATA) != 0 ? 0 : 1;
 			}
 
-			return ((ctrl & BPCTLI_CTRL_SWDPIN0) != 0 ? 0 : 1);
+			return (ctrl & BPCTLI_CTRL_SWDPIN0) != 0 ? 0 : 1;
 		} else
 			return ((BP10G_READ_REG(pbpctl_dev, ESDP) &
 				 BP10G_SDP0_DATA) != 0 ? 0 : 1);
@@ -3204,8 +3204,8 @@ static int bp_force_link_status(struct bpctl_dev *pbpctl_dev)
 	if (DBI_IF_SERIES(pbpctl_dev->subdevice)) {
 
 		if ((pbpctl_dev->bp_10g) || (pbpctl_dev->bp_10g9)) {
-			return ((BP10G_READ_REG(pbpctl_dev, ESDP) &
-				 BP10G_SDP1_DIR) != 0 ? 1 : 0);
+			return (BP10G_READ_REG(pbpctl_dev, ESDP) &
+				 BP10G_SDP1_DIR) != 0 ? 1 : 0;
 
 		}
 	}
@@ -3251,9 +3251,9 @@ int bypass_flag_status(struct bpctl_dev *pbpctl_dev)
 
 	if ((pbpctl_dev->bp_caps & BP_CAP)) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
+			return (((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
 				  BYPASS_FLAG_MASK) ==
-				 BYPASS_FLAG_MASK) ? 1 : 0);
+				 BYPASS_FLAG_MASK) ? 1 : 0;
 		}
 	}
 	return BP_NOT_CAP;
@@ -3298,8 +3298,8 @@ int bypass_off_status(struct bpctl_dev *pbpctl_dev)
 
 	if (pbpctl_dev->bp_caps & BP_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
-				  BYPASS_OFF_MASK) == BYPASS_OFF_MASK) ? 1 : 0);
+			return (((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
+				  BYPASS_OFF_MASK) == BYPASS_OFF_MASK) ? 1 : 0;
 		}
 	}
 	return BP_NOT_CAP;
@@ -3333,18 +3333,18 @@ static int bypass_status(struct bpctl_dev *pbpctl_dev)
 				ctrl_ext = BP10G_READ_REG(pbpctl_dev_b, I2CCTL);
 				BP10G_WRITE_REG(pbpctl_dev_b, I2CCTL,
 						(ctrl_ext | BP10G_I2C_CLK_OUT));
-				return ((BP10G_READ_REG(pbpctl_dev_b, I2CCTL) &
-					 BP10G_I2C_CLK_IN) != 0 ? 0 : 1);
+				return (BP10G_READ_REG(pbpctl_dev_b, I2CCTL) &
+					 BP10G_I2C_CLK_IN) != 0 ? 0 : 1;
 
 			} else if (pbpctl_dev->bp_540) {
-				return (((BP10G_READ_REG(pbpctl_dev_b, ESDP)) &
-					 BP10G_SDP0_DATA) != 0 ? 0 : 1);
+				return ((BP10G_READ_REG(pbpctl_dev_b, ESDP)) &
+					 BP10G_SDP0_DATA) != 0 ? 0 : 1;
 			}
 
 			else if ((pbpctl_dev->bp_fiber5)
 				 || (pbpctl_dev->bp_i80)) {
-				return (((BPCTL_READ_REG(pbpctl_dev_b, CTRL)) &
-					 BPCTLI_CTRL_SWDPIN0) != 0 ? 0 : 1);
+				return ((BPCTL_READ_REG(pbpctl_dev_b, CTRL)) &
+					 BPCTLI_CTRL_SWDPIN0) != 0 ? 0 : 1;
 			} else if (pbpctl_dev->bp_10gb) {
 				ctrl_ext =
 				    BP10GB_READ_REG(pbpctl_dev, MISC_REG_GPIO);
@@ -3353,10 +3353,10 @@ static int bypass_status(struct bpctl_dev *pbpctl_dev)
 						 & ~(BP10GB_GPIO3_SET_P0 |
 						     BP10GB_GPIO3_CLR_P0));
 
-				return (((BP10GB_READ_REG
+				return ((BP10GB_READ_REG
 					  (pbpctl_dev,
 					   MISC_REG_GPIO)) & BP10GB_GPIO3_P0) !=
-					0 ? 0 : 1);
+					0 ? 0 : 1;
 			}
 
 			else if (!pbpctl_dev->bp_10g)
@@ -3371,14 +3371,14 @@ static int bypass_status(struct bpctl_dev *pbpctl_dev)
 				BP10G_WRITE_REG(pbpctl_dev_b, EODSDP,
 						(ctrl_ext |
 						 BP10G_SDP7_DATA_OUT));
-				return ((BP10G_READ_REG(pbpctl_dev_b, EODSDP) &
-					 BP10G_SDP7_DATA_IN) != 0 ? 0 : 1);
+				return (BP10G_READ_REG(pbpctl_dev_b, EODSDP) &
+					 BP10G_SDP7_DATA_IN) != 0 ? 0 : 1;
 			}
 
 		} else if (pbpctl_dev->media_type == BP_COPPER) {
 
-			return (((BPCTL_READ_REG(pbpctl_dev_b, CTRL)) &
-				 BPCTLI_CTRL_SWDPIN1) != 0 ? 1 : 0);
+			return ((BPCTL_READ_REG(pbpctl_dev_b, CTRL)) &
+				 BPCTLI_CTRL_SWDPIN1) != 0 ? 1 : 0;
 		} else {
 			if ((bypass_status_clear(pbpctl_dev)) >= 0)
 				return bypass_from_last_read(pbpctl_dev);
@@ -3394,10 +3394,10 @@ int default_pwron_status(struct bpctl_dev *pbpctl_dev)
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
 		if (pbpctl_dev->bp_caps & BP_PWUP_CTL_CAP) {
 			if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-				return ((((read_reg
+				return (((read_reg
 					   (pbpctl_dev,
 					    STATUS_REG_ADDR)) & DFLT_PWRON_MASK)
-					 == DFLT_PWRON_MASK) ? 0 : 1);
+					 == DFLT_PWRON_MASK) ? 0 : 1;
 			}
 		}		/*else if ((!pbpctl_dev->bp_caps&BP_DIS_CAP)&&
 				   (pbpctl_dev->bp_caps&BP_PWUP_ON_CAP))
@@ -3414,8 +3414,8 @@ static int default_pwroff_status(struct bpctl_dev *pbpctl_dev)
 	   return 1; */
 	if ((pbpctl_dev->bp_caps & SW_CTL_CAP)
 	    && (pbpctl_dev->bp_caps & BP_PWOFF_CTL_CAP)) {
-		return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
-			  DFLT_PWROFF_MASK) == DFLT_PWROFF_MASK) ? 0 : 1);
+		return (((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
+			  DFLT_PWROFF_MASK) == DFLT_PWROFF_MASK) ? 0 : 1;
 	}
 	return BP_NOT_CAP;
 }
@@ -3425,9 +3425,9 @@ int dis_bypass_cap_status(struct bpctl_dev *pbpctl_dev)
 
 	if (pbpctl_dev->bp_caps & BP_DIS_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
+			return (((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
 				  DIS_BYPASS_CAP_MASK) ==
-				 DIS_BYPASS_CAP_MASK) ? 1 : 0);
+				 DIS_BYPASS_CAP_MASK) ? 1 : 0;
 		}
 	}
 	return BP_NOT_CAP;
@@ -3438,8 +3438,8 @@ int cmd_en_status(struct bpctl_dev *pbpctl_dev)
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
-				  CMND_EN_MASK) == CMND_EN_MASK) ? 1 : 0);
+			return (((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
+				  CMND_EN_MASK) == CMND_EN_MASK) ? 1 : 0;
 		}
 	}
 	return BP_NOT_CAP;
@@ -3450,8 +3450,8 @@ int wdt_en_status(struct bpctl_dev *pbpctl_dev)
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
-				  WDT_EN_MASK) == WDT_EN_MASK) ? 1 : 0);
+			return (((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
+				  WDT_EN_MASK) == WDT_EN_MASK) ? 1 : 0;
 		}
 	}
 	return BP_NOT_CAP;
@@ -3617,8 +3617,8 @@ int tap_status(struct bpctl_dev *pbpctl_dev)
 				BP10G_WRITE_REG(pbpctl_dev_b, EODSDP,
 						(ctrl_ext |
 						 BP10G_SDP6_DATA_OUT));
-				return ((BP10G_READ_REG(pbpctl_dev_b, EODSDP) &
-					 BP10G_SDP6_DATA_IN) != 0 ? 0 : 1);
+				return (BP10G_READ_REG(pbpctl_dev_b, EODSDP) &
+					 BP10G_SDP6_DATA_IN) != 0 ? 0 : 1;
 			}
 
 		} else if (pbpctl_dev->media_type == BP_COPPER)
@@ -3706,14 +3706,14 @@ int disc_off_status(struct bpctl_dev *pbpctl_dev)
 				  DISC_OFF_MASK) == DISC_OFF_MASK) ? 1 : 0);
 
 		if (pbpctl_dev->bp_i80) {
-			return (((BPCTL_READ_REG(pbpctl_dev_b, CTRL_EXT)) &
-				 BPCTLI_CTRL_EXT_SDP6_DATA) != 0 ? 1 : 0);
+			return ((BPCTL_READ_REG(pbpctl_dev_b, CTRL_EXT)) &
+				 BPCTLI_CTRL_EXT_SDP6_DATA) != 0 ? 1 : 0;
 
 		}
 		if (pbpctl_dev->bp_540) {
 			ctrl_ext = BP10G_READ_REG(pbpctl_dev_b, ESDP);
-			return ((BP10G_READ_REG(pbpctl_dev_b, ESDP) &
-				 BP10G_SDP2_DATA) != 0 ? 1 : 0);
+			return (BP10G_READ_REG(pbpctl_dev_b, ESDP) &
+				 BP10G_SDP2_DATA) != 0 ? 1 : 0;
 
 		}
 		if (pbpctl_dev->media_type == BP_COPPER) {
@@ -3736,12 +3736,12 @@ int disc_off_status(struct bpctl_dev *pbpctl_dev)
 				BP10G_WRITE_REG(pbpctl_dev_b, I2CCTL,
 						(ctrl_ext |
 						 BP10G_I2C_DATA_OUT));
-				return ((BP10G_READ_REG(pbpctl_dev_b, I2CCTL) &
-					 BP10G_I2C_DATA_IN) != 0 ? 1 : 0);
+				return (BP10G_READ_REG(pbpctl_dev_b, I2CCTL) &
+					 BP10G_I2C_DATA_IN) != 0 ? 1 : 0;
 
 			} else if (pbpctl_dev->bp_fiber5) {
-				return (((BPCTL_READ_REG(pbpctl_dev_b, CTRL)) &
-					 BPCTLI_CTRL_SWDPIN1) != 0 ? 1 : 0);
+				return ((BPCTL_READ_REG(pbpctl_dev_b, CTRL)) &
+					 BPCTLI_CTRL_SWDPIN1) != 0 ? 1 : 0;
 			} else if (pbpctl_dev->bp_10gb) {
 				ctrl_ext =
 				    BP10GB_READ_REG(pbpctl_dev, MISC_REG_GPIO);
@@ -3750,25 +3750,25 @@ int disc_off_status(struct bpctl_dev *pbpctl_dev)
 						 & ~(BP10GB_GPIO3_SET_P1 |
 						     BP10GB_GPIO3_CLR_P1));
 
-				return (((BP10GB_READ_REG
+				return ((BP10GB_READ_REG
 					  (pbpctl_dev,
 					   MISC_REG_GPIO)) & BP10GB_GPIO3_P1) !=
-					0 ? 1 : 0);
+					0 ? 1 : 0;
 			}
 			if (!pbpctl_dev->bp_10g) {
 
-				return (((BPCTL_READ_REG
+				return ((BPCTL_READ_REG
 					  (pbpctl_dev_b,
 					   CTRL_EXT)) &
 					 BPCTLI_CTRL_EXT_SDP6_DATA) !=
-					0 ? 1 : 0);
+					0 ? 1 : 0;
 			} else {
 				ctrl_ext = BP10G_READ_REG(pbpctl_dev_b, EODSDP);
 				BP10G_WRITE_REG(pbpctl_dev_b, EODSDP,
 						(ctrl_ext |
 						 BP10G_SDP6_DATA_OUT));
-				return (((BP10G_READ_REG(pbpctl_dev_b, EODSDP))
-					 & BP10G_SDP6_DATA_IN) != 0 ? 1 : 0);
+				return ((BP10G_READ_REG(pbpctl_dev_b, EODSDP))
+					 & BP10G_SDP6_DATA_IN) != 0 ? 1 : 0;
 			}
 
 		}
@@ -3783,7 +3783,7 @@ static int disc_status(struct bpctl_dev *pbpctl_dev)
 		ctrl = disc_off_status(pbpctl_dev);
 		if (ctrl < 0)
 			return ctrl;
-		return ((ctrl == 0) ? 1 : 0);
+		return (ctrl == 0) ? 1 : 0;
 	}
 	return BP_NOT_CAP;
 }
@@ -3824,8 +3824,8 @@ int disc_port_status(struct bpctl_dev *pbpctl_dev)
 
 	if (pbpctl_dev_m->bp_caps_ex & DISC_PORT_CAP_EX) {
 		if (is_bypass_fn(pbpctl_dev) == 1) {
-			return ((((read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR)) &
-				  TX_DISA_MASK) == TX_DISA_MASK) ? 1 : 0);
+			return (((read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR)) &
+				  TX_DISA_MASK) == TX_DISA_MASK) ? 1 : 0;
 		} else
 			return ((((read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR)) &
 				  TX_DISB_MASK) == TX_DISB_MASK) ? 1 : 0);
@@ -3885,8 +3885,8 @@ int tpl2_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {
-		return ((((read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR)) &
-			  TPL2_FLAG_MASK) == TPL2_FLAG_MASK) ? 1 : 0);
+		return (((read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR)) &
+			  TPL2_FLAG_MASK) == TPL2_FLAG_MASK) ? 1 : 0;
 
 	}
 	return BP_NOT_CAP;
@@ -3940,8 +3940,8 @@ int std_nic_status(struct bpctl_dev *pbpctl_dev)
 		if (INTEL_IF_SERIES(pbpctl_dev->subdevice))
 			return BP_NOT_CAP;
 		if (pbpctl_dev->bp_ext_ver >= BP_FW_EXT_VER8) {
-			return ((((read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR)) &
-				  STD_NIC_ON_MASK) == STD_NIC_ON_MASK) ? 1 : 0);
+			return (((read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR)) &
+				  STD_NIC_ON_MASK) == STD_NIC_ON_MASK) ? 1 : 0;
 		}
 
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
@@ -4377,7 +4377,7 @@ int is_bypass_fn(struct bpctl_dev *pbpctl_dev)
 	if (!pbpctl_dev)
 		return -1;
 
-	return (((pbpctl_dev->func == 0) || (pbpctl_dev->func == 2)) ? 1 : 0);
+	return ((pbpctl_dev->func == 0) || (pbpctl_dev->func == 2)) ? 1 : 0;
 }
 
 int set_bypass_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
@@ -4641,7 +4641,7 @@ int get_tap_pwup_fn(struct bpctl_dev *pbpctl_dev)
 	ret = default_pwron_tap_status(pbpctl_dev);
 	if (ret < 0)
 		return ret;
-	return ((ret == 0) ? 1 : 0);
+	return (ret == 0) ? 1 : 0;
 }
 
 int get_tap_change_fn(struct bpctl_dev *pbpctl_dev)
@@ -4730,7 +4730,7 @@ int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 		return -1;
 
 	ret = default_pwron_disc_status(pbpctl_dev);
-	return (ret == 0 ? 1 : (ret < 0 ? BP_NOT_CAP : 0));
+	return ret == 0 ? 1 : (ret < 0 ? BP_NOT_CAP : 0);
 }
 
 int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
@@ -4817,7 +4817,7 @@ int get_disc_port_pwup_fn(struct bpctl_dev *pbpctl_dev)
 	ret = default_pwron_disc_port_status(pbpctl_dev);
 	if (ret < 0)
 		return ret;
-	return ((ret == 0) ? 1 : 0);
+	return (ret == 0) ? 1 : 0;
 }
 
 int get_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev)
-- 
1.8.4.2

