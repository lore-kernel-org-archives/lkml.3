Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaILV5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:57:03 -0400
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:54966 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752258AbaILV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:57:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:327:355:371:372:379:541:800:960:966:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2693:2828:2904:2909:2915:3138:3139:3140:3141:3142:3743:3865:3866:3867:3871:3873:4250:4321:4384:4385:4395:4605:5007:6117:6119:7652:7875:7903:8603:9040:10004:10848:10954:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12681:12683:13019:13137:13150:13230:13231:13868:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: woman84_2a1a4511655e
X-Filterd-Recvd-Size: 20620
Message-ID: <1410559016.9942.53.camel@joe-AO725>
Subject: [PATCH] mmc: Convert pr_warning to pr_warn
From: Joe Perches <joe@perches.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2014 14:56:56 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the much more common pr_warn instead of pr_warning.

Other miscellanea:

o Coalesce formats
o Realign arguments
o Remove extra spaces when coalescing formats

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/card/block.c     |  4 ++--
 drivers/mmc/card/queue.c     |  6 ++----
 drivers/mmc/card/sdio_uart.c |  9 ++++-----
 drivers/mmc/core/core.c      |  8 ++++----
 drivers/mmc/core/mmc.c       | 17 +++++++----------
 drivers/mmc/core/mmc_ops.c   |  4 ++--
 drivers/mmc/core/sd.c        | 33 ++++++++++++++-------------------
 drivers/mmc/core/sdio.c      |  7 +++----
 drivers/mmc/core/sdio_bus.c  |  4 ++--
 drivers/mmc/core/sdio_irq.c  |  7 +++----
 drivers/mmc/host/s3cmci.c    |  3 ++-
 drivers/mmc/host/sdhci.c     | 34 ++++++++++++++++------------------
 drivers/mmc/host/tifm_sd.c   |  4 ++--
 drivers/mmc/host/wbsd.c      | 21 ++++++---------------
 14 files changed, 69 insertions(+), 92 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index e248b96..ec8ac2a 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1928,8 +1928,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		case MMC_BLK_ECC_ERR:
 			if (brq->data.blocks > 1) {
 				/* Redo read one sector at a time */
-				pr_warning("%s: retrying using single block read\n",
-					   req->rq_disk->disk_name);
+				pr_warn("%s: retrying using single block read\n",
+					req->rq_disk->disk_name);
 				disable_multi = 1;
 				break;
 			}
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 3e049c1..feea926 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -229,14 +229,12 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 		if (bouncesz > 512) {
 			mqrq_cur->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
 			if (!mqrq_cur->bounce_buf) {
-				pr_warning("%s: unable to "
-					"allocate bounce cur buffer\n",
+				pr_warn("%s: unable to allocate bounce cur buffer\n",
 					mmc_card_name(card));
 			}
 			mqrq_prev->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
 			if (!mqrq_prev->bounce_buf) {
-				pr_warning("%s: unable to "
-					"allocate bounce prev buffer\n",
+				pr_warn("%s: unable to allocate bounce prev buffer\n",
 					mmc_card_name(card));
 				kfree(mqrq_cur->bounce_buf);
 				mqrq_cur->bounce_buf = NULL;
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index f093cea..d2de592 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -1063,8 +1063,8 @@ static int sdio_uart_probe(struct sdio_func *func,
 		return -ENOMEM;
 
 	if (func->class == SDIO_CLASS_UART) {
-		pr_warning("%s: need info on UART class basic setup\n",
-		       sdio_func_id(func));
+		pr_warn("%s: need info on UART class basic setup\n",
+			sdio_func_id(func));
 		kfree(port);
 		return -ENOSYS;
 	} else if (func->class == SDIO_CLASS_GPS) {
@@ -1082,9 +1082,8 @@ static int sdio_uart_probe(struct sdio_func *func,
 				break;
 		}
 		if (!tpl) {
-			pr_warning(
-       "%s: can't find tuple 0x91 subtuple 0 (SUBTPL_SIOREG) for GPS class\n",
-			       sdio_func_id(func));
+			pr_warn("%s: can't find tuple 0x91 subtuple 0 (SUBTPL_SIOREG) for GPS class\n",
+				sdio_func_id(func));
 			kfree(port);
 			return -EINVAL;
 		}
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index e2e1dd4..b1e209f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -433,8 +433,8 @@ static void mmc_wait_for_req_done(struct mmc_host *host,
 		 */
 		if (cmd->sanitize_busy && cmd->error == -ETIMEDOUT) {
 			if (!mmc_interrupt_hpi(host->card)) {
-				pr_warning("%s: %s: Interrupted sanitize\n",
-					   mmc_hostname(host), __func__);
+				pr_warn("%s: %s: Interrupted sanitize\n",
+					mmc_hostname(host), __func__);
 				cmd->error = 0;
 				break;
 			} else {
@@ -1417,8 +1417,8 @@ int mmc_set_signal_voltage(struct mmc_host *host, int signal_voltage, u32 ocr)
 	if (!host->ops->start_signal_voltage_switch)
 		return -EPERM;
 	if (!host->ops->card_busy)
-		pr_warning("%s: cannot verify signal voltage switch\n",
-				mmc_hostname(host));
+		pr_warn("%s: cannot verify signal voltage switch\n",
+			mmc_hostname(host));
 
 	cmd.opcode = SD_SWITCH_VOLTAGE;
 	cmd.arg = 0;
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 69e6273..51085b4 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -226,9 +226,7 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
 				"Card will be ignored.\n",
 				mmc_hostname(card->host));
 		} else {
-			pr_warning("%s: unable to read "
-				"EXT_CSD, performance might "
-				"suffer.\n",
+			pr_warn("%s: unable to read EXT_CSD, performance might suffer\n",
 				mmc_hostname(card->host));
 			err = 0;
 		}
@@ -790,8 +788,8 @@ static int __mmc_select_powerclass(struct mmc_card *card,
 				ext_csd->raw_pwr_cl_200_360;
 		break;
 	default:
-		pr_warning("%s: Voltage range not supported "
-			   "for power class.\n", mmc_hostname(host));
+		pr_warn("%s: Voltage range not supported for power class\n",
+			mmc_hostname(host));
 		return -EINVAL;
 	}
 
@@ -1432,8 +1430,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		if (err && err != -EBADMSG)
 			goto free_card;
 		if (err) {
-			pr_warning("%s: Enabling HPI failed\n",
-				   mmc_hostname(card->host));
+			pr_warn("%s: Enabling HPI failed\n",
+				mmc_hostname(card->host));
 			err = 0;
 		} else
 			card->ext_csd.hpi_en = 1;
@@ -1454,9 +1452,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		 * Only if no error, cache is turned on successfully.
 		 */
 		if (err) {
-			pr_warning("%s: Cache is supported, "
-					"but failed to turn on (%d)\n",
-					mmc_hostname(card->host), err);
+			pr_warn("%s: Cache is supported, but failed to turn on (%d)\n",
+				mmc_hostname(card->host), err);
 			card->ext_csd.cache_ctrl = 0;
 			err = 0;
 		} else {
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index ba0275e..7911e05 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -649,8 +649,8 @@ int mmc_send_hpi_cmd(struct mmc_card *card, u32 *status)
 	int err;
 
 	if (!card->ext_csd.hpi) {
-		pr_warning("%s: Card didn't support HPI command\n",
-			   mmc_hostname(card->host));
+		pr_warn("%s: Card didn't support HPI command\n",
+			mmc_hostname(card->host));
 		return -EINVAL;
 	}
 
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 2591388..d90a6de 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -229,8 +229,8 @@ static int mmc_read_ssr(struct mmc_card *card)
 	u32 *ssr;
 
 	if (!(card->csd.cmdclass & CCC_APP_SPEC)) {
-		pr_warning("%s: card lacks mandatory SD Status "
-			"function.\n", mmc_hostname(card->host));
+		pr_warn("%s: card lacks mandatory SD Status function\n",
+			mmc_hostname(card->host));
 		return 0;
 	}
 
@@ -240,8 +240,8 @@ static int mmc_read_ssr(struct mmc_card *card)
 
 	err = mmc_app_sd_status(card, ssr);
 	if (err) {
-		pr_warning("%s: problem reading SD Status "
-			"register.\n", mmc_hostname(card->host));
+		pr_warn("%s: problem reading SD Status register\n",
+			mmc_hostname(card->host));
 		err = 0;
 		goto out;
 	}
@@ -265,8 +265,8 @@ static int mmc_read_ssr(struct mmc_card *card)
 				card->ssr.erase_offset = eo * 1000;
 			}
 		} else {
-			pr_warning("%s: SD Status: Invalid Allocation Unit size.\n",
-				   mmc_hostname(card->host));
+			pr_warn("%s: SD Status: Invalid Allocation Unit size\n",
+				mmc_hostname(card->host));
 		}
 	}
 out:
@@ -286,8 +286,7 @@ static int mmc_read_switch(struct mmc_card *card)
 		return 0;
 
 	if (!(card->csd.cmdclass & CCC_SWITCH)) {
-		pr_warning("%s: card lacks mandatory switch "
-			"function, performance might suffer.\n",
+		pr_warn("%s: card lacks mandatory switch function, performance might suffer\n",
 			mmc_hostname(card->host));
 		return 0;
 	}
@@ -316,7 +315,7 @@ static int mmc_read_switch(struct mmc_card *card)
 		if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 			goto out;
 
-		pr_warning("%s: problem reading Bus Speed modes.\n",
+		pr_warn("%s: problem reading Bus Speed modes\n",
 			mmc_hostname(card->host));
 		err = 0;
 
@@ -372,8 +371,7 @@ int mmc_sd_switch_hs(struct mmc_card *card)
 		goto out;
 
 	if ((status[16] & 0xF) != 1) {
-		pr_warning("%s: Problem switching card "
-			"into high-speed mode!\n",
+		pr_warn("%s: Problem switching card into high-speed mode!\n",
 			mmc_hostname(card->host));
 		err = 0;
 	} else {
@@ -440,7 +438,7 @@ static int sd_select_driver_type(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[15] & 0xF) != drive_strength) {
-		pr_warning("%s: Problem setting drive strength!\n",
+		pr_warn("%s: Problem setting drive strength!\n",
 			mmc_hostname(card->host));
 		return 0;
 	}
@@ -518,7 +516,7 @@ static int sd_set_bus_speed_mode(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[16] & 0xF) != card->sd_bus_speed)
-		pr_warning("%s: Problem setting bus speed mode!\n",
+		pr_warn("%s: Problem setting bus speed mode!\n",
 			mmc_hostname(card->host));
 	else {
 		mmc_set_timing(card->host, timing);
@@ -598,7 +596,7 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
 			return err;
 
 		if (((status[15] >> 4) & 0x0F) != current_limit)
-			pr_warning("%s: Problem setting current limit!\n",
+			pr_warn("%s: Problem setting current limit!\n",
 				mmc_hostname(card->host));
 
 	}
@@ -727,8 +725,7 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 try_again:
 	if (!retries) {
 		ocr &= ~SD_OCR_S18R;
-		pr_warning("%s: Skipping voltage switch\n",
-			mmc_hostname(host));
+		pr_warn("%s: Skipping voltage switch\n", mmc_hostname(host));
 	}
 
 	/*
@@ -872,9 +869,7 @@ int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
 		}
 
 		if (ro < 0) {
-			pr_warning("%s: host does not "
-				"support reading read-only "
-				"switch. assuming write-enable.\n",
+			pr_warn("%s: host does not support reading read-only switch, assuming write-enable\n",
 				mmc_hostname(host));
 		} else if (ro > 0) {
 			mmc_card_set_readonly(card);
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 3fc40a7..2439e71 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -216,8 +216,8 @@ static int sdio_enable_wide(struct mmc_card *card)
 		return ret;
 
 	if ((ctrl & SDIO_BUS_WIDTH_MASK) == SDIO_BUS_WIDTH_RESERVED)
-		pr_warning("%s: SDIO_CCCR_IF is invalid: 0x%02x\n",
-			   mmc_hostname(card->host), ctrl);
+		pr_warn("%s: SDIO_CCCR_IF is invalid: 0x%02x\n",
+			mmc_hostname(card->host), ctrl);
 
 	/* set as 4-bit bus width */
 	ctrl &= ~SDIO_BUS_WIDTH_MASK;
@@ -605,8 +605,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 
 try_again:
 	if (!retries) {
-		pr_warning("%s: Skipping voltage switch\n",
-				mmc_hostname(host));
+		pr_warn("%s: Skipping voltage switch\n", mmc_hostname(host));
 		ocr &= ~R4_18V_PRESENT;
 	}
 
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 4fa8fef9..e4eb456 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -177,8 +177,8 @@ static int sdio_bus_remove(struct device *dev)
 	drv->remove(func);
 
 	if (func->irq_handler) {
-		pr_warning("WARNING: driver %s did not remove "
-			"its interrupt handler!\n", drv->name);
+		pr_warn("WARNING: driver %s did not remove its interrupt handler!\n",
+			drv->name);
 		sdio_claim_host(func);
 		sdio_release_irq(func);
 		sdio_release_host(func);
diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index 696eca4..09cc67d 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -69,16 +69,15 @@ static int process_sdio_pending_irqs(struct mmc_host *host)
 		if (pending & (1 << i)) {
 			func = card->sdio_func[i - 1];
 			if (!func) {
-				pr_warning("%s: pending IRQ for "
-					"non-existent function\n",
+				pr_warn("%s: pending IRQ for non-existent function\n",
 					mmc_card_id(card));
 				ret = -EINVAL;
 			} else if (func->irq_handler) {
 				func->irq_handler(func);
 				count++;
 			} else {
-				pr_warning("%s: pending IRQ with no handler\n",
-				       sdio_func_id(func));
+				pr_warn("%s: pending IRQ with no handler\n",
+					sdio_func_id(func));
 				ret = -EINVAL;
 			}
 		}
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index e4e1a53..94cddf3 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -985,7 +985,8 @@ static int s3cmci_setup_data(struct s3cmci_host *host, struct mmc_data *data)
 		 * one block being transferred. */
 
 		if (data->blocks > 1) {
-			pr_warning("%s: can't do non-word sized block transfers (blksz %d)\n", __func__, data->blksz);
+			pr_warn("%s: can't do non-word sized block transfers (blksz %d)\n",
+				__func__, data->blksz);
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7481bd8..db113ab 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1754,8 +1754,8 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 			ret = regulator_set_voltage(mmc->supply.vqmmc, 2700000,
 						    3600000);
 			if (ret) {
-				pr_warning("%s: Switching to 3.3V signalling voltage "
-						" failed\n", mmc_hostname(mmc));
+				pr_warn("%s: Switching to 3.3V signalling voltage failed\n",
+					mmc_hostname(mmc));
 				return -EIO;
 			}
 		}
@@ -1767,8 +1767,8 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 		if (!(ctrl & SDHCI_CTRL_VDD_180))
 			return 0;
 
-		pr_warning("%s: 3.3V regulator output did not became stable\n",
-				mmc_hostname(mmc));
+		pr_warn("%s: 3.3V regulator output did not became stable\n",
+			mmc_hostname(mmc));
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_180:
@@ -1776,8 +1776,8 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 			ret = regulator_set_voltage(mmc->supply.vqmmc,
 					1700000, 1950000);
 			if (ret) {
-				pr_warning("%s: Switching to 1.8V signalling voltage "
-						" failed\n", mmc_hostname(mmc));
+				pr_warn("%s: Switching to 1.8V signalling voltage failed\n",
+					mmc_hostname(mmc));
 				return -EIO;
 			}
 		}
@@ -1794,8 +1794,8 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 		if (ctrl & SDHCI_CTRL_VDD_180)
 			return 0;
 
-		pr_warning("%s: 1.8V regulator output did not became stable\n",
-				mmc_hostname(mmc));
+		pr_warn("%s: 1.8V regulator output did not became stable\n",
+			mmc_hostname(mmc));
 
 		return -EAGAIN;
 	case MMC_SIGNAL_VOLTAGE_120:
@@ -1803,8 +1803,8 @@ static int sdhci_do_start_signal_voltage_switch(struct sdhci_host *host,
 			ret = regulator_set_voltage(mmc->supply.vqmmc, 1100000,
 						    1300000);
 			if (ret) {
-				pr_warning("%s: Switching to 1.2V signalling voltage "
-						" failed\n", mmc_hostname(mmc));
+				pr_warn("%s: Switching to 1.2V signalling voltage failed\n",
+					mmc_hostname(mmc));
 				return -EIO;
 			}
 		}
@@ -2844,8 +2844,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma) {
 			if (host->ops->enable_dma(host)) {
-				pr_warning("%s: No suitable DMA "
-					"available. Falling back to PIO.\n",
+				pr_warn("%s: No suitable DMA available - falling back to PIO\n",
 					mmc_hostname(mmc));
 				host->flags &=
 					~(SDHCI_USE_SDMA | SDHCI_USE_ADMA);
@@ -2867,15 +2866,14 @@ int sdhci_add_host(struct sdhci_host *host)
 			dma_free_coherent(mmc_dev(mmc), ADMA_SIZE,
 					  host->adma_desc, host->adma_addr);
 			kfree(host->align_buffer);
-			pr_warning("%s: Unable to allocate ADMA "
-				"buffers. Falling back to standard DMA.\n",
+			pr_warn("%s: Unable to allocate ADMA buffers - falling back to standard DMA\n",
 				mmc_hostname(mmc));
 			host->flags &= ~SDHCI_USE_ADMA;
 			host->adma_desc = NULL;
 			host->align_buffer = NULL;
 		} else if (host->adma_addr & 3) {
-			pr_warning("%s: unable to allocate aligned ADMA descriptor\n",
-				   mmc_hostname(mmc));
+			pr_warn("%s: unable to allocate aligned ADMA descriptor\n",
+				mmc_hostname(mmc));
 			host->flags &= ~SDHCI_USE_ADMA;
 			dma_free_coherent(mmc_dev(mmc), ADMA_SIZE,
 					  host->adma_desc, host->adma_addr);
@@ -3202,8 +3200,8 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->max_blk_size = (caps[0] & SDHCI_MAX_BLOCK_MASK) >>
 				SDHCI_MAX_BLOCK_SHIFT;
 		if (mmc->max_blk_size >= 3) {
-			pr_warning("%s: Invalid maximum block size, "
-				"assuming 512 bytes\n", mmc_hostname(mmc));
+			pr_warn("%s: Invalid maximum block size, assuming 512 bytes\n",
+				mmc_hostname(mmc));
 			mmc->max_blk_size = 0;
 		}
 	}
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index d1760eb..93c4b40 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -952,8 +952,8 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 
 	if (!(TIFM_SOCK_STATE_OCCUPIED
 	      & readl(sock->addr + SOCK_PRESENT_STATE))) {
-		pr_warning("%s : card gone, unexpectedly\n",
-		       dev_name(&sock->dev));
+		pr_warn("%s : card gone, unexpectedly\n",
+			dev_name(&sock->dev));
 		return rc;
 	}
 
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 1defd5e..9a6dfb0 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -803,8 +803,7 @@ static void wbsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 		default:
 #ifdef CONFIG_MMC_DEBUG
-			pr_warning("%s: Data command %d is not "
-				"supported by this controller.\n",
+			pr_warn("%s: Data command %d is not supported by this controller\n",
 				mmc_hostname(host->mmc), cmd->opcode);
 #endif
 			cmd->error = -EINVAL;
@@ -1429,8 +1428,8 @@ free:
 	free_dma(dma);
 
 err:
-	pr_warning(DRIVER_NAME ": Unable to allocate DMA %d. "
-		"Falling back on FIFO.\n", dma);
+	pr_warn(DRIVER_NAME ": Unable to allocate DMA %d - falling back on FIFO\n",
+		dma);
 }
 
 static void wbsd_release_dma(struct wbsd_host *host)
@@ -1664,9 +1663,7 @@ static int wbsd_init(struct device *dev, int base, int irq, int dma,
 	ret = wbsd_scan(host);
 	if (ret) {
 		if (pnp && (ret == -ENODEV)) {
-			pr_warning(DRIVER_NAME
-				": Unable to confirm device presence. You may "
-				"experience lock-ups.\n");
+			pr_warn(DRIVER_NAME ": Unable to confirm device presence - you may experience lock-ups\n");
 		} else {
 			wbsd_free_mmc(dev);
 			return ret;
@@ -1688,10 +1685,7 @@ static int wbsd_init(struct device *dev, int base, int irq, int dma,
 	 */
 	if (pnp) {
 		if ((host->config != 0) && !wbsd_chip_validate(host)) {
-			pr_warning(DRIVER_NAME
-				": PnP active but chip not configured! "
-				"You probably have a buggy BIOS. "
-				"Configuring chip manually.\n");
+			pr_warn(DRIVER_NAME ": PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
 			wbsd_chip_config(host);
 		}
 	} else
@@ -1884,10 +1878,7 @@ static int wbsd_pnp_resume(struct pnp_dev *pnp_dev)
 	 */
 	if (host->config != 0) {
 		if (!wbsd_chip_validate(host)) {
-			pr_warning(DRIVER_NAME
-				": PnP active but chip not configured! "
-				"You probably have a buggy BIOS. "
-				"Configuring chip manually.\n");
+			pr_warn(DRIVER_NAME ": PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
 			wbsd_chip_config(host);
 		}
 	}



