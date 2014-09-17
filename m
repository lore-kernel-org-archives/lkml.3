Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaIQJas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:30:48 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39680 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbaIQJap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:30:45 -0400
From: Albino Biasutti Neto <bino@riseup.net>
To: linux-kernel@vger.kernel.org
Cc: Albino Biasutti Neto <bino@riseup.net>
Subject: [PATCH 10/10] Fix style code and DDR_DESENTY_4Gb.
Date: Wed, 17 Sep 2014 06:28:14 -0300
Message-Id: <1410946094-2502-1-git-send-email-bino@riseup.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <Fix style coding and add more line 351.>
References: <Fix style coding and add more line 351.>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albino Biasutti Neto  <bino@riseup.net>
---
 drivers/memory/emif.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 1c5bbf2..4045b46 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -201,9 +201,6 @@ static void __exit emif_debugfs_exit(struct emif_data *emif)
 static inline int __init_or_module emif_debugfs_init(struct emif_data *emif)
 	return 0;
 
-//static inline void __exit emif_debugfs_exit(struct emif_data *emif)
-//{
-//}
 #endif
 
 /*
@@ -354,6 +351,7 @@ static const struct lpddr2_addressing *get_addressing_table(
 		case DDR_DENSITY_1Gb:
 		case DDR_DENSITY_2Gb:
 		case DDR_DENSITY_4Gb:
+
 		  index = density + 3;
 			break;
 		default:
@@ -812,8 +810,7 @@ static u32 get_pwr_mgmt_ctrl(u32 freq, struct emif_data *emif, u32 ip_rev)
 	/* Setup required timing */
 	pwr_mgmt_ctrl = (timeout << shift) & mask;
 	/* setup a default mask for rest of the modes */
-	pwr_mgmt_ctrl |= (SR_TIM_MASK | CS_TIM_MASK | PD_TIM_MASK) &
-			  ~mask;
+	pwr_mgmt_ctrl |= (SR_TIM_MASK | CS_TIM_MASK | PD_TIM_MASK) & ~mask;
 
 	/* No CS_TIM in EMIF_4D5 */
 	if (ip_rev == EMIF_4D5)
@@ -1062,10 +1059,10 @@ static irqreturn_t emif_threaded_isr(int irq, void *dev_id)
 	if (emif->curr_regs) {
 		setup_temperature_sensitive_regs(emif, emif->curr_regs);
 		do_freq_update();
-	} else {
-		dev_err(emif->dev, "temperature alert before registers are calculated, not de-rating timings\n");
-	}
-
+	} 
+        else 
+	   dev_err(emif->dev, "temperature alert before registers are calculated, not de-rating timings\n");
+	
 	spin_unlock_irqrestore(&emif_lock, irq_state);
 
 	return IRQ_HANDLED;
@@ -1506,9 +1503,9 @@ static struct emif_data *__init_or_module get_device_details(
 				__LINE__);
 			get_default_timings(emif);
 		}
-	} else {
-		get_default_timings(emif);
-	}
+	} 
+        else 
+           get_default_timings(emif);
 
 	if (pd->min_tck) {
 		temp = devm_kzalloc(dev, sizeof(*pd->min_tck), GFP_KERNEL);
@@ -1520,9 +1517,9 @@ static struct emif_data *__init_or_module get_device_details(
 				__LINE__);
 			pd->min_tck = &lpddr2_jedec_min_tck;
 		}
-	} else {
-		pd->min_tck = &lpddr2_jedec_min_tck;
-	}
+	} 
+       else 
+	   pd->min_tck = &lpddr2_jedec_min_tck;
 
 out:
 	return emif;
-- 
2.1.0

