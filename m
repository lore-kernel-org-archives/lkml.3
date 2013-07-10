Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3GJPeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:34:24 -0400
Received: from sauhun.de ([89.238.76.85]:54465 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab3GJPeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:34:19 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 2/2] tree-wide: use reinit_completion instead of INIT_COMPLETION
Date: Wed, 10 Jul 2013 16:33:57 +0100
Message-Id: <1373470437-16908-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373470437-16908-1-git-send-email-wsa@the-dreams.de>
References: <1373470437-16908-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this new function to make code more comprehensible, since we are
reinitialzing the completion, not initializing.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
---

This is now a tree-wide patch for easier review. I can easily split it up later.

 arch/arm/mach-tegra/apbio.c                      |    2 +-
 arch/powerpc/platforms/powermac/low_i2c.c        |    6 +++---
 arch/powerpc/platforms/pseries/suspend.c         |    2 +-
 crypto/af_alg.c                                  |    2 +-
 crypto/tcrypt.c                                  |    4 ++--
 crypto/testmgr.c                                 |   12 ++++++------
 drivers/ata/libata-eh.c                          |    2 +-
 drivers/base/power/main.c                        |    4 ++--
 drivers/block/amiflop.c                          |    2 +-
 drivers/block/cciss.c                            |    4 ++--
 drivers/char/hw_random/timeriomem-rng.c          |    2 +-
 drivers/crypto/tegra-aes.c                       |    2 +-
 drivers/firewire/core-transaction.c              |    2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c       |    2 +-
 drivers/hwmon/jz4740-hwmon.c                     |    2 +-
 drivers/i2c/busses/i2c-at91.c                    |    2 +-
 drivers/i2c/busses/i2c-bcm2835.c                 |    2 +-
 drivers/i2c/busses/i2c-davinci.c                 |    2 +-
 drivers/i2c/busses/i2c-designware-core.c         |    2 +-
 drivers/i2c/busses/i2c-ismt.c                    |    2 +-
 drivers/i2c/busses/i2c-mxs.c                     |    2 +-
 drivers/i2c/busses/i2c-omap.c                    |    2 +-
 drivers/i2c/busses/i2c-tegra.c                   |    2 +-
 drivers/i2c/busses/i2c-wmt.c                     |    4 ++--
 drivers/iio/adc/ad_sigma_delta.c                 |    6 +++---
 drivers/input/touchscreen/cyttsp_core.c          |    2 +-
 drivers/md/dm-crypt.c                            |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c   |    2 +-
 drivers/media/platform/coda.c                    |    2 +-
 drivers/media/radio/radio-wl1273.c               |   10 +++++-----
 drivers/media/radio/si470x/radio-si470x-common.c |    4 ++--
 drivers/media/rc/iguanair.c                      |    2 +-
 drivers/memstick/core/memstick.c                 |    2 +-
 drivers/memstick/host/r592.c                     |    2 +-
 drivers/misc/ti-st/st_kim.c                      |   12 ++++++------
 drivers/mtd/nand/mxc_nand.c                      |    2 +-
 drivers/mtd/nand/r852.c                          |    2 +-
 drivers/mtd/onenand/omap2.c                      |   10 +++++-----
 drivers/net/ieee802154/at86rf230.c               |    2 +-
 drivers/net/ieee802154/mrf24j40.c                |    2 +-
 drivers/net/wireless/ath/carl9170/usb.c          |    2 +-
 drivers/net/wireless/ath/wil6210/main.c          |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c    |    4 ++--
 drivers/net/wireless/zd1211rw/zd_usb.c           |    2 +-
 drivers/parport/parport_ip32.c                   |    4 ++--
 drivers/platform/x86/apple-gmux.c                |    2 +-
 drivers/power/ab8500_fg.c                        |    4 ++--
 drivers/power/jz4740-battery.c                   |    2 +-
 drivers/rtc/rtc-hid-sensor-time.c                |    2 +-
 drivers/spi/spi-bcm2835.c                        |    2 +-
 drivers/spi/spi-clps711x.c                       |    2 +-
 drivers/spi/spi-davinci.c                        |    2 +-
 drivers/spi/spi-fsl-espi.c                       |    2 +-
 drivers/spi/spi-fsl-spi.c                        |    2 +-
 drivers/spi/spi-mpc512x-psc.c                    |    2 +-
 drivers/spi/spi-mxs.c                            |    2 +-
 drivers/spi/spi-s3c64xx.c                        |    2 +-
 drivers/spi/spi-sh-msiof.c                       |    2 +-
 drivers/spi/spi-sirf.c                           |    2 +-
 drivers/spi/spi-tegra114.c                       |    6 +++---
 drivers/spi/spi-tegra20-sflash.c                 |    2 +-
 drivers/spi/spi-tegra20-slink.c                  |    6 +++---
 drivers/spi/spi-xilinx.c                         |    2 +-
 drivers/staging/iio/adc/mxs-lradc.c              |    2 +-
 drivers/staging/media/solo6x10/solo6x10-p2m.c    |    2 +-
 drivers/staging/tidspbridge/core/sync.c          |    4 ++--
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    6 +++---
 drivers/tty/metag_da.c                           |    2 +-
 drivers/usb/c67x00/c67x00-sched.c                |    2 +-
 drivers/usb/gadget/f_fs.c                        |    2 +-
 drivers/usb/serial/mos7720.c                     |    2 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c    |    4 ++--
 fs/ecryptfs/crypto.c                             |    4 ++--
 fs/nfs/nfs4state.c                               |    2 +-
 fs/ocfs2/dlmglue.c                               |    4 ++--
 sound/soc/samsung/ac97.c                         |    6 +++---
 76 files changed, 118 insertions(+), 118 deletions(-)

diff --git a/arch/arm/mach-tegra/apbio.c b/arch/arm/mach-tegra/apbio.c
index d7aa52e..bc47197 100644
--- a/arch/arm/mach-tegra/apbio.c
+++ b/arch/arm/mach-tegra/apbio.c
@@ -114,7 +114,7 @@ static int do_dma_transfer(unsigned long apb_add,
 	dma_desc->callback = apb_dma_complete;
 	dma_desc->callback_param = NULL;
 
-	INIT_COMPLETION(tegra_apb_wait);
+	reinit_completion(&tegra_apb_wait);
 
 	dmaengine_submit(dma_desc);
 	dma_async_issue_pending(tegra_apb_dma_chan);
diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index fc536f2..7553b6a 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -452,7 +452,7 @@ static int kw_i2c_xfer(struct pmac_i2c_bus *bus, u8 addrdir, int subsize,
 	 */
 	if (use_irq) {
 		/* Clear completion */
-		INIT_COMPLETION(host->complete);
+		reinit_completion(&host->complete);
 		/* Ack stale interrupts */
 		kw_write_reg(reg_isr, kw_read_reg(reg_isr));
 		/* Arm timeout */
@@ -717,7 +717,7 @@ static int pmu_i2c_xfer(struct pmac_i2c_bus *bus, u8 addrdir, int subsize,
 			return -EINVAL;
 		}
 
-		INIT_COMPLETION(comp);
+		reinit_completion(&comp);
 		req->data[0] = PMU_I2C_CMD;
 		req->reply[0] = 0xff;
 		req->nbytes = sizeof(struct pmu_i2c_hdr) + 1;
@@ -748,7 +748,7 @@ static int pmu_i2c_xfer(struct pmac_i2c_bus *bus, u8 addrdir, int subsize,
 
 		hdr->bus = PMU_I2C_BUS_STATUS;
 
-		INIT_COMPLETION(comp);
+		reinit_completion(&comp);
 		req->data[0] = PMU_I2C_CMD;
 		req->reply[0] = 0xff;
 		req->nbytes = 2;
diff --git a/arch/powerpc/platforms/pseries/suspend.c b/arch/powerpc/platforms/pseries/suspend.c
index 5f997e7..16a2552 100644
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -106,7 +106,7 @@ static int pseries_prepare_late(void)
 	atomic_set(&suspend_data.done, 0);
 	atomic_set(&suspend_data.error, 0);
 	suspend_data.complete = &suspend_work;
-	INIT_COMPLETION(suspend_work);
+	reinit_completion(&suspend_work);
 	return 0;
 }
 
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ac33d5f..966f893 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -434,7 +434,7 @@ int af_alg_wait_for_completion(int err, struct af_alg_completion *completion)
 	case -EINPROGRESS:
 	case -EBUSY:
 		wait_for_completion(&completion->completion);
-		INIT_COMPLETION(completion->completion);
+		reinit_completion(&completion->completion);
 		err = completion->err;
 		break;
 	};
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 25a5934..1ab8258 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -493,7 +493,7 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 		ret = wait_for_completion_interruptible(&tr->completion);
 		if (!ret)
 			ret = tr->err;
-		INIT_COMPLETION(tr->completion);
+		reinit_completion(&tr->completion);
 	}
 	return ret;
 }
@@ -721,7 +721,7 @@ static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
 		ret = wait_for_completion_interruptible(&tr->completion);
 		if (!ret)
 			ret = tr->err;
-		INIT_COMPLETION(tr->completion);
+		reinit_completion(&tr->completion);
 	}
 
 	return ret;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2f00607..88a4271 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -179,7 +179,7 @@ static int do_one_async_hash_op(struct ahash_request *req,
 		ret = wait_for_completion_interruptible(&tr->completion);
 		if (!ret)
 			ret = tr->err;
-		INIT_COMPLETION(tr->completion);
+		reinit_completion(&tr->completion);
 	}
 	return ret;
 }
@@ -336,7 +336,7 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 				ret = wait_for_completion_interruptible(
 					&tresult.completion);
 				if (!ret && !(ret = tresult.err)) {
-					INIT_COMPLETION(tresult.completion);
+					reinit_completion(&tresult.completion);
 					break;
 				}
 				/* fall through */
@@ -543,7 +543,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 				ret = wait_for_completion_interruptible(
 					&result.completion);
 				if (!ret && !(ret = result.err)) {
-					INIT_COMPLETION(result.completion);
+					reinit_completion(&result.completion);
 					break;
 				}
 			case -EBADMSG:
@@ -697,7 +697,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 				ret = wait_for_completion_interruptible(
 					&result.completion);
 				if (!ret && !(ret = result.err)) {
-					INIT_COMPLETION(result.completion);
+					reinit_completion(&result.completion);
 					break;
 				}
 			case -EBADMSG:
@@ -983,7 +983,7 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				ret = wait_for_completion_interruptible(
 					&result.completion);
 				if (!ret && !((ret = result.err))) {
-					INIT_COMPLETION(result.completion);
+					reinit_completion(&result.completion);
 					break;
 				}
 				/* fall through */
@@ -1086,7 +1086,7 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				ret = wait_for_completion_interruptible(
 					&result.completion);
 				if (!ret && !((ret = result.err))) {
-					INIT_COMPLETION(result.completion);
+					reinit_completion(&result.completion);
 					break;
 				}
 				/* fall through */
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c69fcce..12f9a06 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3023,7 +3023,7 @@ static inline void ata_eh_pull_park_action(struct ata_port *ap)
 	 */
 
 	spin_lock_irqsave(ap->lock, flags);
-	INIT_COMPLETION(ap->park_req_pending);
+	reinit_completion(&ap->park_req_pending);
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ALL) {
 			struct ata_eh_info *ehi = &link->eh_info;
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 5a9b656..80b12c3 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -681,7 +681,7 @@ void dpm_resume(pm_message_t state)
 	async_error = 0;
 
 	list_for_each_entry(dev, &dpm_suspended_list, power.entry) {
-		INIT_COMPLETION(dev->power.completion);
+		reinit_completion(&dev->power.completion);
 		if (is_async(dev)) {
 			get_device(dev);
 			async_schedule(async_resume, dev);
@@ -1155,7 +1155,7 @@ static void async_suspend(void *data, async_cookie_t cookie)
 
 static int device_suspend(struct device *dev)
 {
-	INIT_COMPLETION(dev->power.completion);
+	reinit_completion(&dev->power.completion);
 
 	if (pm_async_enabled && dev->power.async_suspend) {
 		get_device(dev);
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 4ff85b8..748dea4 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -343,7 +343,7 @@ static int fd_motor_on(int nr)
 		unit[nr].motor = 1;
 		fd_select(nr);
 
-		INIT_COMPLETION(motor_on_completion);
+		reinit_completion(&motor_on_completion);
 		motor_on_timer.data = nr;
 		mod_timer(&motor_on_timer, jiffies + HZ/2);
 
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 62b6c2c..2481556 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2807,7 +2807,7 @@ resend_cmd2:
 		/* erase the old error information */
 		memset(c->err_info, 0, sizeof(ErrorInfo_struct));
 		return_status = IO_OK;
-		INIT_COMPLETION(wait);
+		reinit_completion(&wait);
 		goto resend_cmd2;
 	}
 
@@ -3668,7 +3668,7 @@ static int add_to_scan_list(struct ctlr_info *h)
 		}
 	}
 	if (!found && !h->busy_scanning) {
-		INIT_COMPLETION(h->scan_wait);
+		reinit_completion(&h->scan_wait);
 		list_add_tail(&h->scan_list, &scan_q);
 		ret = 1;
 	}
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index d2120ba..73ce739 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -79,7 +79,7 @@ static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
 	priv->expires = cur + delay;
 	priv->present = 0;
 
-	INIT_COMPLETION(priv->completion);
+	reinit_completion(&priv->completion);
 	mod_timer(&priv->timer, priv->expires);
 
 	return 4;
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 85ea752..14d95c0 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -268,7 +268,7 @@ static int aes_start_crypt(struct tegra_aes_dev *dd, u32 in_addr, u32 out_addr,
 	aes_writel(dd, value, TEGRA_AES_SECURE_INPUT_SELECT);
 
 	aes_writel(dd, out_addr, TEGRA_AES_SECURE_DEST_ADDR);
-	INIT_COMPLETION(dd->op_complete);
+	reinit_completion(&dd->op_complete);
 
 	for (i = 0; i < AES_HW_MAX_ICQ_LENGTH - 1; i++) {
 		do {
diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 28a94c7..d3f8356 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -477,7 +477,7 @@ void fw_send_phy_config(struct fw_card *card,
 	phy_config_packet.header[1] = data;
 	phy_config_packet.header[2] = ~data;
 	phy_config_packet.generation = generation;
-	INIT_COMPLETION(phy_config_done);
+	reinit_completion(&phy_config_done);
 
 	card->driver->send_request(card, &phy_config_packet);
 	wait_for_completion_timeout(&phy_config_done, timeout);
diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
index 1eb86c7..e281070 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
@@ -99,7 +99,7 @@ static int xfer_read(struct i2c_adapter *adap, struct i2c_msg *pmsg)
 	i2c_dev->status = I2C_STAT_INIT;
 	i2c_dev->msg = pmsg;
 	i2c_dev->buf_offset = 0;
-	INIT_COMPLETION(i2c_dev->complete);
+	reinit_completion(&i2c_dev->complete);
 
 	/* Enable I2C transaction */
 	temp = ((pmsg->len) << 20) | HI2C_EDID_READ | HI2C_ENABLE_TRANSACTION;
diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index e0d66b9..a183e48 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -66,7 +66,7 @@ static ssize_t jz4740_hwmon_read_adcin(struct device *dev,
 
 	mutex_lock(&hwmon->lock);
 
-	INIT_COMPLETION(*completion);
+	reinit_completion(completion);
 
 	enable_irq(hwmon->irq);
 	hwmon->cell->enable(to_platform_device(dev));
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 6bb839b..4d93d1e 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -372,7 +372,7 @@ static int at91_do_twi_transfer(struct at91_twi_dev *dev)
 	dev_dbg(dev->dev, "transfer: %s %d bytes.\n",
 		(dev->msg->flags & I2C_M_RD) ? "read" : "write", dev->buf_len);
 
-	INIT_COMPLETION(dev->cmd_complete);
+	reinit_completion(&dev->cmd_complete);
 	dev->transfer_status = 0;
 
 	if (!dev->buf_len) {
diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index ea4b08f..d7e8600 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -151,7 +151,7 @@ static int bcm2835_i2c_xfer_msg(struct bcm2835_i2c_dev *i2c_dev,
 
 	i2c_dev->msg_buf = msg->buf;
 	i2c_dev->msg_buf_remaining = msg->len;
-	INIT_COMPLETION(i2c_dev->completion);
+	reinit_completion(&i2c_dev->completion);
 
 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_C, BCM2835_I2C_C_CLEAR);
 
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index fa55605..7eab731 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -326,7 +326,7 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_CNT_REG, dev->buf_len);
 
-	INIT_COMPLETION(dev->cmd_complete);
+	reinit_completion(&dev->cmd_complete);
 	dev->cmd_err = 0;
 
 	/* Take I2C out of reset and configure it as master */
diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index ad46616..67e7300 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -574,7 +574,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	mutex_lock(&dev->lock);
 	pm_runtime_get_sync(dev->dev);
 
-	INIT_COMPLETION(dev->cmd_complete);
+	reinit_completion(&dev->cmd_complete);
 	dev->msgs = msgs;
 	dev->msgs_num = num;
 	dev->cmd_err = 0;
diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index cd82eb4..53e52fa 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -538,7 +538,7 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 		desc->dptr_high = upper_32_bits(dma_addr);
 	}
 
-	INIT_COMPLETION(priv->cmp);
+	reinit_completion(&priv->cmp);
 
 	/* Add the descriptor */
 	ismt_submit_desc(priv);
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index df8ff5a..74463ac 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -498,7 +498,7 @@ static int mxs_i2c_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg,
 		if (ret)
 			mxs_i2c_reset(i2c);
 	} else {
-		INIT_COMPLETION(i2c->cmd_complete);
+		reinit_completion(&i2c->cmd_complete);
 		ret = mxs_i2c_dma_setup_xfer(adap, msg, flags);
 		if (ret)
 			return ret;
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 142b694d..a4c222f 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -547,7 +547,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	w |= OMAP_I2C_BUF_RXFIF_CLR | OMAP_I2C_BUF_TXFIF_CLR;
 	omap_i2c_write_reg(dev, OMAP_I2C_BUF_REG, w);
 
-	INIT_COMPLETION(dev->cmd_complete);
+	reinit_completion(&dev->cmd_complete);
 	dev->cmd_err = 0;
 
 	w = OMAP_I2C_CON_EN | OMAP_I2C_CON_MST | OMAP_I2C_CON_STT;
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 9aa1b60..4f96cb5 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -545,7 +545,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 	i2c_dev->msg_buf_remaining = msg->len;
 	i2c_dev->msg_err = I2C_ERR_NONE;
 	i2c_dev->msg_read = (msg->flags & I2C_M_RD);
-	INIT_COMPLETION(i2c_dev->msg_complete);
+	reinit_completion(&i2c_dev->msg_complete);
 
 	packet_header = (0 << PACKET_HEADER0_HEADER_SIZE_SHIFT) |
 			PACKET_HEADER0_PROTOCOL_I2C |
diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index baaa7d1..f8e1836 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -159,7 +159,7 @@ static int wmt_i2c_write(struct i2c_adapter *adap, struct i2c_msg *pmsg,
 		writew(val, i2c_dev->base + REG_CR);
 	}
 
-	INIT_COMPLETION(i2c_dev->complete);
+	reinit_completion(&i2c_dev->complete);
 
 	if (i2c_dev->mode == I2C_MODE_STANDARD)
 		tcr_val = TCR_STANDARD_MODE;
@@ -248,7 +248,7 @@ static int wmt_i2c_read(struct i2c_adapter *adap, struct i2c_msg *pmsg,
 		writew(val, i2c_dev->base + REG_CR);
 	}
 
-	INIT_COMPLETION(i2c_dev->complete);
+	reinit_completion(&i2c_dev->complete);
 
 	if (i2c_dev->mode == I2C_MODE_STANDARD)
 		tcr_val = TCR_STANDARD_MODE;
diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index f0d6335..e766bf7 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -188,7 +188,7 @@ static int ad_sd_calibrate(struct ad_sigma_delta *sigma_delta,
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
-	INIT_COMPLETION(sigma_delta->completion);
+	reinit_completion(&sigma_delta->completion);
 
 	ret = ad_sigma_delta_set_mode(sigma_delta, mode);
 	if (ret < 0)
@@ -259,7 +259,7 @@ int ad_sigma_delta_single_conversion(struct iio_dev *indio_dev,
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
-	INIT_COMPLETION(sigma_delta->completion);
+	reinit_completion(&sigma_delta->completion);
 
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_SINGLE);
 
@@ -343,7 +343,7 @@ static int ad_sd_buffer_postdisable(struct iio_dev *indio_dev)
 {
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
 
-	INIT_COMPLETION(sigma_delta->completion);
+	reinit_completion(&sigma_delta->completion);
 	wait_for_completion_timeout(&sigma_delta->completion, HZ);
 
 	if (!sigma_delta->irq_dis) {
diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index d53e0b7..4204841 100644
--- a/drivers/input/touchscreen/cyttsp_core.c
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -242,7 +242,7 @@ static int cyttsp_soft_reset(struct cyttsp *ts)
 	int retval;
 
 	/* wait for interrupt to set ready completion */
-	INIT_COMPLETION(ts->bl_ready);
+	reinit_completion(&ts->bl_ready);
 	ts->state = CY_BL_STATE;
 
 	enable_irq(ts->irq);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6d2d41a..f3829ca 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -774,7 +774,7 @@ static int crypt_convert(struct crypt_config *cc,
 		/* async */
 		case -EBUSY:
 			wait_for_completion(&ctx->restart);
-			INIT_COMPLETION(ctx->restart);
+			reinit_completion(&ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
 			this_cc->req = NULL;
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 0e55b08..195f76b 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -428,7 +428,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 		return ret;
 	}
 
-	INIT_COMPLETION(bcap_dev->comp);
+	reinit_completion(&bcap_dev->comp);
 	bcap_dev->stop = false;
 	return 0;
 }
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 9d1481a..5c08f5a 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -748,7 +748,7 @@ static void coda_device_run(void *m2m_priv)
 	/* 1 second timeout in case CODA locks up */
 	schedule_delayed_work(&dev->timeout, HZ);
 
-	INIT_COMPLETION(dev->done);
+	reinit_completion(&dev->done);
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 }
 
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 97c2c18..9cf6731 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -375,7 +375,7 @@ static int wl1273_fm_set_tx_freq(struct wl1273_device *radio, unsigned int freq)
 	if (r)
 		return r;
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 
 	/* wait for the FR IRQ */
 	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(2000));
@@ -389,7 +389,7 @@ static int wl1273_fm_set_tx_freq(struct wl1273_device *radio, unsigned int freq)
 	if (r)
 		return r;
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 
 	/* wait for the POWER_ENB IRQ */
 	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000));
@@ -444,7 +444,7 @@ static int wl1273_fm_set_rx_freq(struct wl1273_device *radio, unsigned int freq)
 		goto err;
 	}
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 
 	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(2000));
 	if (!r) {
@@ -805,7 +805,7 @@ static int wl1273_fm_set_seek(struct wl1273_device *radio,
 	if (level < SCHAR_MIN || level > SCHAR_MAX)
 		return -EINVAL;
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 	dev_dbg(radio->dev, "%s: BUSY\n", __func__);
 
 	r = core->write(core, WL1273_INT_MASK_SET, radio->irq_flags);
@@ -847,7 +847,7 @@ static int wl1273_fm_set_seek(struct wl1273_device *radio,
 	if (r)
 		goto out;
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 	dev_dbg(radio->dev, "%s: BUSY\n", __func__);
 
 	r = core->write(core, WL1273_TUNER_MODE_SET, TUNER_MODE_AUTO_SEEK);
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 5c57e5b..0bd2500 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -218,7 +218,7 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 		goto done;
 
 	/* wait till tune operation has completed */
-	INIT_COMPLETION(radio->completion);
+	reinit_completion(&radio->completion);
 	retval = wait_for_completion_timeout(&radio->completion,
 			msecs_to_jiffies(tune_timeout));
 	if (!retval)
@@ -341,7 +341,7 @@ static int si470x_set_seek(struct si470x_device *radio,
 		return retval;
 
 	/* wait till tune operation has completed */
-	INIT_COMPLETION(radio->completion);
+	reinit_completion(&radio->completion);
 	retval = wait_for_completion_timeout(&radio->completion,
 			msecs_to_jiffies(seek_timeout));
 	if (!retval)
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index a4ab2e6..bd354d7 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -207,7 +207,7 @@ static int iguanair_send(struct iguanair *ir, unsigned size)
 {
 	int rc;
 
-	INIT_COMPLETION(ir->completion);
+	reinit_completion(&ir->completion);
 
 	ir->urb_out->transfer_buffer_length = size;
 	rc = usb_submit_urb(ir->urb_out, GFP_KERNEL);
diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index ffcb10a..b78f623 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -253,7 +253,7 @@ void memstick_new_req(struct memstick_host *host)
 {
 	if (host->card) {
 		host->retries = cmd_retries;
-		INIT_COMPLETION(host->card->mrq_complete);
+		reinit_completion(&host->card->mrq_complete);
 		host->request(host);
 	}
 }
diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 1b6e913..31727bf 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -290,7 +290,7 @@ static int r592_transfer_fifo_dma(struct r592_device *dev)
 	dbg_verbose("doing dma transfer");
 
 	dev->dma_error = 0;
-	INIT_COMPLETION(dev->dma_done);
+	reinit_completion(&dev->dma_done);
 
 	/* TODO: hidden assumption about nenth beeing always 1 */
 	sg_count = dma_map_sg(&dev->pci_dev->dev, &dev->req->sg, 1, is_write ?
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 83907c7..96853a0 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -218,7 +218,7 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 
 	pr_debug("%s", __func__);
 
-	INIT_COMPLETION(kim_gdata->kim_rcvd);
+	reinit_completion(&kim_gdata->kim_rcvd);
 	if (4 != st_int_write(kim_gdata->core_data, read_ver_cmd, 4)) {
 		pr_err("kim: couldn't write 4 bytes");
 		return -EIO;
@@ -229,7 +229,7 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 		pr_err(" waiting for ver info- timed out ");
 		return -ETIMEDOUT;
 	}
-	INIT_COMPLETION(kim_gdata->kim_rcvd);
+	reinit_completion(&kim_gdata->kim_rcvd);
 	/* the positions 12 & 13 in the response buffer provide with the
 	 * chip, major & minor numbers
 	 */
@@ -362,7 +362,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 			/* reinit completion before sending for the
 			 * relevant wait
 			 */
-			INIT_COMPLETION(kim_gdata->kim_rcvd);
+			reinit_completion(&kim_gdata->kim_rcvd);
 
 			/*
 			 * Free space found in uart buffer, call st_int_write
@@ -398,7 +398,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 				release_firmware(kim_gdata->fw_entry);
 				return -ETIMEDOUT;
 			}
-			INIT_COMPLETION(kim_gdata->kim_rcvd);
+			reinit_completion(&kim_gdata->kim_rcvd);
 			break;
 		case ACTION_DELAY:	/* sleep */
 			pr_info("sleep command in scr");
@@ -474,7 +474,7 @@ long st_kim_start(void *kim_data)
 		gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
 		mdelay(100);
 		/* re-initialize the completion */
-		INIT_COMPLETION(kim_gdata->ldisc_installed);
+		reinit_completion(&kim_gdata->ldisc_installed);
 		/* send notification to UIM */
 		kim_gdata->ldisc_install = 1;
 		pr_info("ldisc_install = 1");
@@ -525,7 +525,7 @@ long st_kim_stop(void *kim_data)
 		kim_gdata->kim_pdev->dev.platform_data;
 	struct tty_struct	*tty = kim_gdata->core_data->tty;
 
-	INIT_COMPLETION(kim_gdata->ldisc_installed);
+	reinit_completion(&kim_gdata->ldisc_installed);
 
 	if (tty) {	/* can be called before ldisc is installed */
 		/* Flush any pending characters in the driver and discipline. */
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 07e5784..980c7fc 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -395,7 +395,7 @@ static void wait_op_done(struct mxc_nand_host *host, int useirq)
 
 	if (useirq) {
 		if (!host->devtype_data->check_int(host)) {
-			INIT_COMPLETION(host->op_completion);
+			reinit_completion(&host->op_completion);
 			irq_control(host, 1);
 			wait_for_completion(&host->op_completion);
 		}
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index 4495f85..23dc711 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -181,7 +181,7 @@ static void r852_do_dma(struct r852_device *dev, uint8_t *buf, int do_read)
 	/* Set dma direction */
 	dev->dma_dir = do_read;
 	dev->dma_stage = 1;
-	INIT_COMPLETION(dev->dma_done);
+	reinit_completion(&dev->dma_done);
 
 	dbg_verbose("doing dma %s ", do_read ? "read" : "write");
 
diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index d98b198..e4c552d 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -159,7 +159,7 @@ static int omap2_onenand_wait(struct mtd_info *mtd, int state)
 				syscfg = read_reg(c, ONENAND_REG_SYS_CFG1);
 		}
 
-		INIT_COMPLETION(c->irq_done);
+		reinit_completion(&c->irq_done);
 		if (c->gpio_irq) {
 			result = gpio_get_value(c->gpio_irq);
 			if (result == -1) {
@@ -349,7 +349,7 @@ static int omap3_onenand_read_bufferram(struct mtd_info *mtd, int area,
 	omap_set_dma_dest_params(c->dma_channel, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_dst, 0, 0);
 
-	INIT_COMPLETION(c->dma_done);
+	reinit_completion(&c->dma_done);
 	omap_start_dma(c->dma_channel);
 
 	timeout = jiffies + msecs_to_jiffies(20);
@@ -420,7 +420,7 @@ static int omap3_onenand_write_bufferram(struct mtd_info *mtd, int area,
 	omap_set_dma_dest_params(c->dma_channel, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_dst, 0, 0);
 
-	INIT_COMPLETION(c->dma_done);
+	reinit_completion(&c->dma_done);
 	omap_start_dma(c->dma_channel);
 
 	timeout = jiffies + msecs_to_jiffies(20);
@@ -499,7 +499,7 @@ static int omap2_onenand_read_bufferram(struct mtd_info *mtd, int area,
 	omap_set_dma_dest_params(c->dma_channel, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_dst, 0, 0);
 
-	INIT_COMPLETION(c->dma_done);
+	reinit_completion(&c->dma_done);
 	omap_start_dma(c->dma_channel);
 	wait_for_completion(&c->dma_done);
 
@@ -544,7 +544,7 @@ static int omap2_onenand_write_bufferram(struct mtd_info *mtd, int area,
 	omap_set_dma_dest_params(c->dma_channel, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_dst, 0, 0);
 
-	INIT_COMPLETION(c->dma_done);
+	reinit_completion(&c->dma_done);
 	omap_start_dma(c->dma_channel);
 	wait_for_completion(&c->dma_done);
 
diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 6f10b49..2cbe1c2 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -561,7 +561,7 @@ at86rf230_xmit(struct ieee802154_dev *dev, struct sk_buff *skb)
 
 	spin_lock_irqsave(&lp->lock, flags);
 	lp->is_tx = 1;
-	INIT_COMPLETION(lp->tx_complete);
+	reinit_completion(&lp->tx_complete);
 	spin_unlock_irqrestore(&lp->lock, flags);
 
 	rc = at86rf230_write_fbuf(lp, skb->data, skb->len);
diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index ede3ce4..dc56fd7 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -355,7 +355,7 @@ static int mrf24j40_tx(struct ieee802154_dev *dev, struct sk_buff *skb)
 		val |= 0x4;
 	write_short_reg(devrec, REG_TXNCON, val);
 
-	INIT_COMPLETION(devrec->tx_complete);
+	reinit_completion(&devrec->tx_complete);
 
 	/* Wait for the device to send the TX complete interrupt. */
 	ret = wait_for_completion_interruptible_timeout(
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 307bc0d..ca115f3 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -773,7 +773,7 @@ void carl9170_usb_stop(struct ar9170 *ar)
 	complete_all(&ar->cmd_wait);
 
 	/* This is required to prevent an early completion on _start */
-	INIT_COMPLETION(ar->cmd_wait);
+	reinit_completion(&ar->cmd_wait);
 
 	/*
 	 * Note:
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0a2844c..fd30cdd 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -250,7 +250,7 @@ int wil_reset(struct wil6210_priv *wil)
 
 	/* init after reset */
 	wil->pending_connect_cid = -1;
-	INIT_COMPLETION(wil->wmi_ready);
+	reinit_completion(&wil->wmi_ready);
 
 	/* TODO: release MAC reset */
 	wil6210_enable_irq(wil);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 79555f0..de1b1b9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1148,7 +1148,7 @@ static s32 brcmf_p2p_af_searching_channel(struct brcmf_p2p_info *p2p)
 
 	pri_vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 
-	INIT_COMPLETION(afx_hdl->act_frm_scan);
+	reinit_completion(&afx_hdl->act_frm_scan);
 	set_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL, &p2p->status);
 	afx_hdl->is_active = true;
 	afx_hdl->peer_chan = P2P_INVALID_CHANNEL;
@@ -1501,7 +1501,7 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	INIT_COMPLETION(p2p->send_af_done);
+	reinit_completion(&p2p->send_af_done);
 	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status);
 	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 7ef0b4a..84d94f5 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1619,7 +1619,7 @@ static void prepare_read_regs_int(struct zd_usb *usb,
 	atomic_set(&intr->read_regs_enabled, 1);
 	intr->read_regs.req = req;
 	intr->read_regs.req_count = count;
-	INIT_COMPLETION(intr->read_regs.completion);
+	reinit_completion(&intr->read_regs.completion);
 	spin_unlock_irq(&intr->lock);
 }
 
diff --git a/drivers/parport/parport_ip32.c b/drivers/parport/parport_ip32.c
index d471627..c864f82 100644
--- a/drivers/parport/parport_ip32.c
+++ b/drivers/parport/parport_ip32.c
@@ -1331,7 +1331,7 @@ static unsigned int parport_ip32_fwp_wait_interrupt(struct parport *p)
 			break;
 
 		/* Initialize mutex used to take interrupts into account */
-		INIT_COMPLETION(priv->irq_complete);
+		reinit_completion(&priv->irq_complete);
 
 		/* Enable serviceIntr */
 		parport_ip32_frob_econtrol(p, ECR_SERVINTR, 0);
@@ -1446,7 +1446,7 @@ static size_t parport_ip32_fifo_write_block_dma(struct parport *p,
 	priv->irq_mode = PARPORT_IP32_IRQ_HERE;
 
 	parport_ip32_dma_start(DMA_TO_DEVICE, (void *)buf, len);
-	INIT_COMPLETION(priv->irq_complete);
+	reinit_completion(&priv->irq_complete);
 	parport_ip32_frob_econtrol(p, ECR_DMAEN | ECR_SERVINTR, ECR_DMAEN);
 
 	nfault_timeout = min((unsigned long)physport->cad->timeout,
diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index f74bfcb..2e08f15 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -289,7 +289,7 @@ static int gmux_switchto(enum vga_switcheroo_client_id id)
 static int gmux_set_discrete_state(struct apple_gmux_data *gmux_data,
 				   enum vga_switcheroo_state state)
 {
-	INIT_COMPLETION(gmux_data->powerchange_done);
+	reinit_completion(&gmux_data->powerchange_done);
 
 	if (state == VGA_SWITCHEROO_ON) {
 		gmux_write8(gmux_data, GMUX_PORT_DISCRETE_POWER, 1);
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c5391f5..272ad07 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -574,8 +574,8 @@ int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
 	}
 
 	/* Return and WFI */
-	INIT_COMPLETION(di->ab8500_fg_started);
-	INIT_COMPLETION(di->ab8500_fg_complete);
+	reinit_completion(&di->ab8500_fg_started);
+	reinit_completion(&di->ab8500_fg_complete);
 	enable_irq(di->irq);
 
 	/* Note: cc_lock is still locked */
diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index c675553..3c2fb0c 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -73,7 +73,7 @@ static long jz_battery_read_voltage(struct jz_battery *battery)
 
 	mutex_lock(&battery->lock);
 
-	INIT_COMPLETION(battery->read_completion);
+	reinit_completion(&battery->read_completion);
 
 	enable_irq(battery->irq);
 	battery->cell->enable(battery->pdev);
diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 7273b01..4b8ff66 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -213,7 +213,7 @@ static int hid_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		platform_get_drvdata(to_platform_device(dev));
 	int ret;
 
-	INIT_COMPLETION(time_state->comp_last_time);
+	reinit_completion(&time_state->comp_last_time);
 	/* get a report with all values through requesting one value */
 	sensor_hub_input_attr_get_raw_value(time_state->common_attributes.hsdev,
 			HID_USAGE_SENSOR_TIME, hid_time_addresses[0],
diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index a4185e4..bcdcc1a 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -217,7 +217,7 @@ static int bcm2835_spi_start_transfer(struct spi_device *spi,
 		cs |= spi->chip_select;
 	}
 
-	INIT_COMPLETION(bs->done);
+	reinit_completion(&bs->done);
 	bs->tx_buf = tfr->tx_buf;
 	bs->rx_buf = tfr->rx_buf;
 	bs->len = tfr->len;
diff --git a/drivers/spi/spi-clps711x.c b/drivers/spi/spi-clps711x.c
index 17965fe..e5f3948 100644
--- a/drivers/spi/spi-clps711x.c
+++ b/drivers/spi/spi-clps711x.c
@@ -105,7 +105,7 @@ static int spi_clps711x_transfer_one_message(struct spi_master *master,
 
 		gpio_set_value(cs, !!(msg->spi->mode & SPI_CS_HIGH));
 
-		INIT_COMPLETION(hw->done);
+		reinit_completion(&hw->done);
 
 		hw->count = 0;
 		hw->len = xfer->len;
diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index 222d3e3..701f7cb 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -553,7 +553,7 @@ static int davinci_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
 	clear_io_bits(dspi->base + SPIGCR1, SPIGCR1_POWERDOWN_MASK);
 	set_io_bits(dspi->base + SPIGCR1, SPIGCR1_SPIENA_MASK);
 
-	INIT_COMPLETION(dspi->done);
+	reinit_completion(&dspi->done);
 
 	if (spicfg->io_type == SPI_IO_TYPE_INTR)
 		set_io_bits(dspi->base + SPIINT, SPIINT_MASKINT);
diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index 6a74d78..5f2a243 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -230,7 +230,7 @@ static int fsl_espi_bufs(struct spi_device *spi, struct spi_transfer *t)
 	mpc8xxx_spi->tx = t->tx_buf;
 	mpc8xxx_spi->rx = t->rx_buf;
 
-	INIT_COMPLETION(mpc8xxx_spi->done);
+	reinit_completion(&mpc8xxx_spi->done);
 
 	/* Set SPCOM[CS] and SPCOM[TRANLEN] field */
 	if ((t->len - 1) > SPCOM_TRANLEN_MAX) {
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 41e89c3..8e1f9ac 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -339,7 +339,7 @@ static int fsl_spi_bufs(struct spi_device *spi, struct spi_transfer *t,
 	mpc8xxx_spi->tx = t->tx_buf;
 	mpc8xxx_spi->rx = t->rx_buf;
 
-	INIT_COMPLETION(mpc8xxx_spi->done);
+	reinit_completion(&mpc8xxx_spi->done);
 
 	if (mpc8xxx_spi->flags & SPI_CPM_MODE)
 		ret = fsl_spi_cpm_bufs(mpc8xxx_spi, t, is_dma_mapped);
diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 29fce6a..e673be5 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -164,7 +164,7 @@ static int mpc512x_psc_spi_transfer_rxtx(struct spi_device *spi,
 			}
 
 			/* have the ISR trigger when the TX FIFO is empty */
-			INIT_COMPLETION(mps->txisrdone);
+			reinit_completion(&mps->txisrdone);
 			out_be32(&fifo->txisr, MPC512x_PSC_FIFO_EMPTY);
 			out_be32(&fifo->tximr, MPC512x_PSC_FIFO_EMPTY);
 			wait_for_completion(&mps->txisrdone);
diff --git a/drivers/spi/spi-mxs.c b/drivers/spi/spi-mxs.c
index 424d38e..bad58b9 100644
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -231,7 +231,7 @@ static int mxs_spi_txrx_dma(struct mxs_spi *spi, int cs,
 	if (!dma_xfer)
 		return -ENOMEM;
 
-	INIT_COMPLETION(spi->c);
+	reinit_completion(&spi->c);
 
 	ctrl0 = readl(ssp->base + HW_SSP_CTRL0);
 	ctrl0 &= ~BM_SSP_CTRL0_XFER_COUNT;
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index eb53df2..c77f6f1 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -905,7 +905,7 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 		unsigned long flags;
 		int use_dma;
 
-		INIT_COMPLETION(sdd->xfer_completion);
+		reinit_completion(&sdd->xfer_completion);
 
 		/* Only BPW and Speed may change across transfers */
 		bpw = xfer->bits_per_word;
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 2bc5a6b..3c34797 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -465,7 +465,7 @@ static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TXE);
 
 	/* start by setting frame bit */
-	INIT_COMPLETION(p->done);
+	reinit_completion(&p->done);
 	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TFSE);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to start hardware\n");
diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
index fc20bcf..38916b5 100644
--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -276,7 +276,7 @@ static int spi_sirfsoc_transfer(struct spi_device *spi, struct spi_transfer *t)
 	sspi->tx = t->tx_buf;
 	sspi->rx = t->rx_buf;
 	sspi->left_tx_cnt = sspi->left_rx_cnt = t->len;
-	INIT_COMPLETION(sspi->done);
+	reinit_completion(&sspi->done);
 
 	writel(SIRFSOC_SPI_INT_MASK_ALL, sspi->base + SIRFSOC_SPI_INT_STATUS);
 
diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index e8f542a..712c18d 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -450,7 +450,7 @@ static void tegra_spi_dma_complete(void *args)
 
 static int tegra_spi_start_tx_dma(struct tegra_spi_data *tspi, int len)
 {
-	INIT_COMPLETION(tspi->tx_dma_complete);
+	reinit_completion(&tspi->tx_dma_complete);
 	tspi->tx_dma_desc = dmaengine_prep_slave_single(tspi->tx_dma_chan,
 				tspi->tx_dma_phys, len, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
@@ -469,7 +469,7 @@ static int tegra_spi_start_tx_dma(struct tegra_spi_data *tspi, int len)
 
 static int tegra_spi_start_rx_dma(struct tegra_spi_data *tspi, int len)
 {
-	INIT_COMPLETION(tspi->rx_dma_complete);
+	reinit_completion(&tspi->rx_dma_complete);
 	tspi->rx_dma_desc = dmaengine_prep_slave_single(tspi->rx_dma_chan,
 				tspi->rx_dma_phys, len, DMA_DEV_TO_MEM,
 				DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
@@ -826,7 +826,7 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 
 	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		INIT_COMPLETION(tspi->xfer_completion);
+		reinit_completion(&tspi->xfer_completion);
 		ret = tegra_spi_start_transfer_one(spi, xfer,
 					is_first_msg, single_xfer);
 		if (ret < 0) {
diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index c1d5d95..2544ec3 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -345,7 +345,7 @@ static int tegra_sflash_transfer_one_message(struct spi_master *master,
 	msg->actual_length = 0;
 	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		INIT_COMPLETION(tsd->xfer_completion);
+		reinit_completion(&tsd->xfer_completion);
 		ret = tegra_sflash_start_transfer_one(spi, xfer,
 					is_first_msg, single_xfer);
 		if (ret < 0) {
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 80490cc..ceeec5d 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -462,7 +462,7 @@ static void tegra_slink_dma_complete(void *args)
 
 static int tegra_slink_start_tx_dma(struct tegra_slink_data *tspi, int len)
 {
-	INIT_COMPLETION(tspi->tx_dma_complete);
+	reinit_completion(&tspi->tx_dma_complete);
 	tspi->tx_dma_desc = dmaengine_prep_slave_single(tspi->tx_dma_chan,
 				tspi->tx_dma_phys, len, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
@@ -481,7 +481,7 @@ static int tegra_slink_start_tx_dma(struct tegra_slink_data *tspi, int len)
 
 static int tegra_slink_start_rx_dma(struct tegra_slink_data *tspi, int len)
 {
-	INIT_COMPLETION(tspi->rx_dma_complete);
+	reinit_completion(&tspi->rx_dma_complete);
 	tspi->rx_dma_desc = dmaengine_prep_slave_single(tspi->rx_dma_chan,
 				tspi->rx_dma_phys, len, DMA_DEV_TO_MEM,
 				DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
@@ -844,7 +844,7 @@ static int tegra_slink_transfer_one_message(struct spi_master *master,
 
 	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		INIT_COMPLETION(tspi->xfer_completion);
+		reinit_completion(&tspi->xfer_completion);
 		ret = tegra_slink_start_transfer_one(spi, xfer,
 					is_first_msg, single_xfer);
 		if (ret < 0) {
diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index fb56fcf..686d764 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -259,7 +259,7 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 	xspi->tx_ptr = t->tx_buf;
 	xspi->rx_ptr = t->rx_buf;
 	xspi->remaining_bytes = t->len;
-	INIT_COMPLETION(xspi->done);
+	reinit_completion(&xspi->done);
 
 
 	/* Enable the transmit empty interrupt, which we use to determine
diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index d92c97a..5278501 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -259,7 +259,7 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 	if (!ret)
 		return -EBUSY;
 
-	INIT_COMPLETION(lradc->completion);
+	reinit_completion(&lradc->completion);
 
 	/*
 	 * No buffered operation in progress, map the channel and trigger it.
diff --git a/drivers/staging/media/solo6x10/solo6x10-p2m.c b/drivers/staging/media/solo6x10/solo6x10-p2m.c
index 3335941..7f2f247 100644
--- a/drivers/staging/media/solo6x10/solo6x10-p2m.c
+++ b/drivers/staging/media/solo6x10/solo6x10-p2m.c
@@ -87,7 +87,7 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev,
 	if (mutex_lock_interruptible(&p2m_dev->mutex))
 		return -EINTR;
 
-	INIT_COMPLETION(p2m_dev->completion);
+	reinit_completion(&p2m_dev->completion);
 	p2m_dev->error = 0;
 
 	if (desc_cnt > 1 && solo_dev->type != SOLO_DEV_6110 && desc_mode) {
diff --git a/drivers/staging/tidspbridge/core/sync.c b/drivers/staging/tidspbridge/core/sync.c
index 7bb550a..743ff09 100644
--- a/drivers/staging/tidspbridge/core/sync.c
+++ b/drivers/staging/tidspbridge/core/sync.c
@@ -72,7 +72,7 @@ int sync_wait_on_multiple_events(struct sync_object **events,
 	spin_lock_bh(&sync_lock);
 	for (i = 0; i < count; i++) {
 		if (completion_done(&events[i]->comp)) {
-			INIT_COMPLETION(events[i]->comp);
+			reinit_completion(&events[i]->comp);
 			*index = i;
 			spin_unlock_bh(&sync_lock);
 			status = 0;
@@ -92,7 +92,7 @@ int sync_wait_on_multiple_events(struct sync_object **events,
 	spin_lock_bh(&sync_lock);
 	for (i = 0; i < count; i++) {
 		if (completion_done(&events[i]->comp)) {
-			INIT_COMPLETION(events[i]->comp);
+			reinit_completion(&events[i]->comp);
 			*index = i;
 			status = 0;
 		}
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 6d04eb4..1aa4a3f 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -332,7 +332,7 @@ static void bridge_recover(struct work_struct *work)
 	struct dev_object *dev;
 	struct cfg_devnode *dev_node;
 	if (atomic_read(&bridge_cref)) {
-		INIT_COMPLETION(bridge_comp);
+		reinit_completion(&bridge_comp);
 		while (!wait_for_completion_timeout(&bridge_comp,
 						msecs_to_jiffies(REC_TIMEOUT)))
 			pr_info("%s:%d handle(s) still opened\n",
@@ -348,7 +348,7 @@ static void bridge_recover(struct work_struct *work)
 
 void bridge_recover_schedule(void)
 {
-	INIT_COMPLETION(bridge_open_comp);
+	reinit_completion(&bridge_open_comp);
 	recover = true;
 	queue_work(bridge_rec_queue, &bridge_recovery_work);
 }
@@ -389,7 +389,7 @@ static int omap3_bridge_startup(struct platform_device *pdev)
 #ifdef CONFIG_TIDSPBRIDGE_RECOVERY
 	bridge_rec_queue = create_workqueue("bridge_rec_queue");
 	INIT_WORK(&bridge_recovery_work, bridge_recover);
-	INIT_COMPLETION(bridge_comp);
+	reinit_completion(&bridge_comp);
 #endif
 
 #ifdef CONFIG_PM
diff --git a/drivers/tty/metag_da.c b/drivers/tty/metag_da.c
index 0e888621..7332e2c 100644
--- a/drivers/tty/metag_da.c
+++ b/drivers/tty/metag_da.c
@@ -495,7 +495,7 @@ static int dashtty_write(struct tty_struct *tty, const unsigned char *buf,
 	count = dport->xmit_cnt;
 	/* xmit buffer no longer empty? */
 	if (count)
-		INIT_COMPLETION(dport->xmit_empty);
+		reinit_completion(&dport->xmit_empty);
 	mutex_unlock(&dport->xmit_lock);
 
 	if (total) {
diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index aa49162..892cc96 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -344,7 +344,7 @@ void c67x00_endpoint_disable(struct usb_hcd *hcd, struct usb_host_endpoint *ep)
 		/* it could happen that we reinitialize this completion, while
 		 * somebody was waiting for that completion.  The timeout and
 		 * while loop handle such cases, but this might be improved */
-		INIT_COMPLETION(c67x00->endpoint_disable);
+		reinit_completion(&c67x00->endpoint_disable);
 		c67x00_sched_kick(c67x00);
 		wait_for_completion_timeout(&c67x00->endpoint_disable, 1 * HZ);
 
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index f394f29..a58d1a6 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -373,7 +373,7 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	if (req->buf == NULL)
 		req->buf = (void *)0xDEADBABE;
 
-	INIT_COMPLETION(ffs->ep0req_completion);
+	reinit_completion(&ffs->ep0req_completion);
 
 	ret = usb_ep_queue(ffs->gadget->ep0, req, GFP_ATOMIC);
 	if (unlikely(ret < 0))
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 51da424..1af9e7e 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -448,7 +448,7 @@ static int parport_prologue(struct parport *pp)
 		return -1;
 	}
 	mos_parport->msg_pending = true;   /* synch usb call pending */
-	INIT_COMPLETION(mos_parport->syncmsg_compl);
+	reinit_completion(&mos_parport->syncmsg_compl);
 	spin_unlock(&release_lock);
 
 	mutex_lock(&mos_parport->serial->disc_mutex);
diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.c b/drivers/video/exynos/exynos_mipi_dsi_common.c
index 520fc9b..c1d8cc3 100644
--- a/drivers/video/exynos/exynos_mipi_dsi_common.c
+++ b/drivers/video/exynos/exynos_mipi_dsi_common.c
@@ -220,7 +220,7 @@ int exynos_mipi_dsi_wr_data(struct mipi_dsim_device *dsim, unsigned int data_id,
 	case MIPI_DSI_DCS_LONG_WRITE:
 	{
 		unsigned int size, payload = 0;
-		INIT_COMPLETION(dsim_wr_comp);
+		reinit_completion(&dsim_wr_comp);
 
 		size = data_size * 4;
 
@@ -356,7 +356,7 @@ int exynos_mipi_dsi_rd_data(struct mipi_dsim_device *dsim, unsigned int data_id,
 	msleep(20);
 
 	mutex_lock(&dsim->lock);
-	INIT_COMPLETION(dsim_rd_comp);
+	reinit_completion(&dsim_rd_comp);
 	exynos_mipi_dsi_rd_tx_header(dsim,
 		MIPI_DSI_SET_MAXIMUM_RETURN_PACKET_SIZE, req_size);
 
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index cfa109a..6dc341c 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -399,7 +399,7 @@ static int encrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 
 		wait_for_completion(&ecr->completion);
 		rc = ecr->rc;
-		INIT_COMPLETION(ecr->completion);
+		reinit_completion(&ecr->completion);
 	}
 out:
 	ablkcipher_request_free(req);
@@ -709,7 +709,7 @@ static int decrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 
 		wait_for_completion(&ecr->completion);
 		rc = ecr->rc;
-		INIT_COMPLETION(ecr->completion);
+		reinit_completion(&ecr->completion);
 	}
 out:
 	ablkcipher_request_free(req);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index e22862f..33b38f0 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -261,7 +261,7 @@ static int nfs4_drain_slot_tbl(struct nfs4_slot_table *tbl)
 	set_bit(NFS4_SLOT_TBL_DRAINING, &tbl->slot_tbl_state);
 	spin_lock(&tbl->slot_tbl_lock);
 	if (tbl->highest_used_slotid != NFS4_NO_SLOT) {
-		INIT_COMPLETION(tbl->complete);
+		reinit_completion(&tbl->complete);
 		spin_unlock(&tbl->slot_tbl_lock);
 		return wait_for_completion_interruptible(&tbl->complete);
 	}
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 3a44a64..3407b2c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1304,7 +1304,7 @@ static int ocfs2_wait_for_mask(struct ocfs2_mask_waiter *mw)
 {
 	wait_for_completion(&mw->mw_complete);
 	/* Re-arm the completion in case we want to wait on it again */
-	INIT_COMPLETION(mw->mw_complete);
+	reinit_completion(&mw->mw_complete);
 	return mw->mw_status;
 }
 
@@ -1355,7 +1355,7 @@ static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
 	else
 		ret = mw->mw_status;
 	/* Re-arm the completion in case we want to wait on it again */
-	INIT_COMPLETION(mw->mw_complete);
+	reinit_completion(&mw->mw_complete);
 	return ret;
 }
 
diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
index 2dd623f..cbb1566 100644
--- a/sound/soc/samsung/ac97.c
+++ b/sound/soc/samsung/ac97.c
@@ -74,7 +74,7 @@ static void s3c_ac97_activate(struct snd_ac97 *ac97)
 	if (stat == S3C_AC97_GLBSTAT_MAINSTATE_ACTIVE)
 		return; /* Return if already active */
 
-	INIT_COMPLETION(s3c_ac97.done);
+	reinit_completion(&s3c_ac97.done);
 
 	ac_glbctrl = readl(s3c_ac97.regs + S3C_AC97_GLBCTRL);
 	ac_glbctrl = S3C_AC97_GLBCTRL_ACLINKON;
@@ -103,7 +103,7 @@ static unsigned short s3c_ac97_read(struct snd_ac97 *ac97,
 
 	s3c_ac97_activate(ac97);
 
-	INIT_COMPLETION(s3c_ac97.done);
+	reinit_completion(&s3c_ac97.done);
 
 	ac_codec_cmd = readl(s3c_ac97.regs + S3C_AC97_CODEC_CMD);
 	ac_codec_cmd = S3C_AC97_CODEC_CMD_READ | AC_CMD_ADDR(reg);
@@ -140,7 +140,7 @@ static void s3c_ac97_write(struct snd_ac97 *ac97, unsigned short reg,
 
 	s3c_ac97_activate(ac97);
 
-	INIT_COMPLETION(s3c_ac97.done);
+	reinit_completion(&s3c_ac97.done);
 
 	ac_codec_cmd = readl(s3c_ac97.regs + S3C_AC97_CODEC_CMD);
 	ac_codec_cmd = AC_CMD_ADDR(reg) | AC_CMD_DATA(val);
-- 
1.7.10.4

