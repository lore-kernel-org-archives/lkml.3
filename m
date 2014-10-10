Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaJJVKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:10:55 -0400
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:53672 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751672AbaJJVKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:10:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:1:41:69:355:379:541:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1461:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:2637:2828:2898:3138:3139:3140:3141:3142:3865:3866:3867:3870:4250:4321:4384:4385:4395:4605:5007:6119:7652:7903:8603:9592:10004:10848:11026:11473:11657:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12683:13972:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: eyes95_41a023f12db62
X-Filterd-Recvd-Size: 12255
Message-ID: <1412975449.8770.45.camel@joe-AO725>
Subject: [PATCH] media: earthsoft: logging neatening
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        HIRANO Takahito <hiranotaka@zng.info>,
        Akihiro Tsukada <tskd08@gmail.com>
Date: Fri, 10 Oct 2014 14:10:49 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_err instead of pt1_printk
o reduce object code size
o remove now unused pt1_printk macro

Neaten dev_<level> uses in pt3
o add missing newlines
o align arguments
o remove unnecessary OOM messages as there's a generic one
o typo fixes in messages

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/pci/pt1/pt1.c | 13 +++-----
 drivers/media/pci/pt3/pt3.c | 75 ++++++++++++++++++++++-----------------------
 2 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index db887b0..acc35b4 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -109,9 +109,6 @@ struct pt1_adapter {
 	int sleep;
 };
 
-#define pt1_printk(level, pt1, format, arg...)	\
-	dev_printk(level, &(pt1)->pdev->dev, format, ##arg)
-
 static void pt1_write_reg(struct pt1 *pt1, int reg, u32 data)
 {
 	writel(data, pt1->regs + reg * 4);
@@ -154,7 +151,7 @@ static int pt1_sync(struct pt1 *pt1)
 			return 0;
 		pt1_write_reg(pt1, 0, 0x00000008);
 	}
-	pt1_printk(KERN_ERR, pt1, "could not sync\n");
+	dev_err(&pt1->pdev->dev, "could not sync\n");
 	return -EIO;
 }
 
@@ -179,7 +176,7 @@ static int pt1_unlock(struct pt1 *pt1)
 			return 0;
 		schedule_timeout_uninterruptible((HZ + 999) / 1000);
 	}
-	pt1_printk(KERN_ERR, pt1, "could not unlock\n");
+	dev_err(&pt1->pdev->dev, "could not unlock\n");
 	return -EIO;
 }
 
@@ -193,7 +190,7 @@ static int pt1_reset_pci(struct pt1 *pt1)
 			return 0;
 		schedule_timeout_uninterruptible((HZ + 999) / 1000);
 	}
-	pt1_printk(KERN_ERR, pt1, "could not reset PCI\n");
+	dev_err(&pt1->pdev->dev, "could not reset PCI\n");
 	return -EIO;
 }
 
@@ -207,7 +204,7 @@ static int pt1_reset_ram(struct pt1 *pt1)
 			return 0;
 		schedule_timeout_uninterruptible((HZ + 999) / 1000);
 	}
-	pt1_printk(KERN_ERR, pt1, "could not reset RAM\n");
+	dev_err(&pt1->pdev->dev, "could not reset RAM\n");
 	return -EIO;
 }
 
@@ -224,7 +221,7 @@ static int pt1_do_enable_ram(struct pt1 *pt1)
 		}
 		schedule_timeout_uninterruptible((HZ + 999) / 1000);
 	}
-	pt1_printk(KERN_ERR, pt1, "could not enable RAM\n");
+	dev_err(&pt1->pdev->dev, "could not enable RAM\n");
 	return -EIO;
 }
 
diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 1fdeac1..7a37e8f 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -255,7 +255,7 @@ static int pt3_fe_init(struct pt3_board *pt3)
 	pt3_i2c_reset(pt3);
 	ret = pt3_init_all_demods(pt3);
 	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to init demod chips.");
+		dev_warn(&pt3->pdev->dev, "Failed to init demod chips\n");
 		return ret;
 	}
 
@@ -271,7 +271,7 @@ static int pt3_fe_init(struct pt3_board *pt3)
 					      init0_ter, ARRAY_SIZE(init0_ter));
 		if (ret < 0) {
 			dev_warn(&pt3->pdev->dev,
-				 "demod[%d] faild in init sequence0.", i);
+				 "demod[%d] failed in init sequence0\n", i);
 			return ret;
 		}
 		ret = fe->ops.init(fe);
@@ -282,7 +282,7 @@ static int pt3_fe_init(struct pt3_board *pt3)
 	usleep_range(2000, 4000);
 	ret = pt3_set_tuner_power(pt3, true, false);
 	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to control tuner module.");
+		dev_warn(&pt3->pdev->dev, "Failed to control tuner module\n");
 		return ret;
 	}
 
@@ -297,7 +297,7 @@ static int pt3_fe_init(struct pt3_board *pt3)
 						cfg_ter, ARRAY_SIZE(cfg_ter));
 		if (ret < 0) {
 			dev_warn(&pt3->pdev->dev,
-				 "demod[%d] faild in init sequence1.", i);
+				 "demod[%d] failed in init sequence1\n", i);
 			return ret;
 		}
 	}
@@ -311,19 +311,19 @@ static int pt3_fe_init(struct pt3_board *pt3)
 		ret = fe->ops.tuner_ops.init(fe);
 		if (ret < 0) {
 			dev_warn(&pt3->pdev->dev,
-				 "Failed to init SAT-tuner[%d].", i);
+				 "Failed to init SAT-tuner[%d]\n", i);
 			return ret;
 		}
 	}
 	ret = pt3_init_all_mxl301rf(pt3);
 	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to init TERR-tuners.");
+		dev_warn(&pt3->pdev->dev, "Failed to init TERR-tuners\n");
 		return ret;
 	}
 
 	ret = pt3_set_tuner_power(pt3, true, true);
 	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to control tuner module.");
+		dev_warn(&pt3->pdev->dev, "Failed to control tuner module\n");
 		return ret;
 	}
 
@@ -344,7 +344,7 @@ static int pt3_fe_init(struct pt3_board *pt3)
 		}
 		if (ret < 0) {
 			dev_warn(&pt3->pdev->dev,
-				 "Failed in initial tuning of tuner[%d].", i);
+				 "Failed in initial tuning of tuner[%d]\n", i);
 			return ret;
 		}
 	}
@@ -366,7 +366,7 @@ static int pt3_fe_init(struct pt3_board *pt3)
 			fe->ops.set_lna = &pt3_set_lna;
 	}
 	if (i < PT3_NUM_FE) {
-		dev_warn(&pt3->pdev->dev, "FE[%d] failed to standby.", i);
+		dev_warn(&pt3->pdev->dev, "FE[%d] failed to standby\n", i);
 		return ret;
 	}
 	return 0;
@@ -453,8 +453,8 @@ static int pt3_fetch_thread(void *data)
 	pt3_init_dmabuf(adap);
 	adap->num_discard = PT3_INITIAL_BUF_DROPS;
 
-	dev_dbg(adap->dvb_adap.device,
-		"PT3: [%s] started.\n", adap->thread->comm);
+	dev_dbg(adap->dvb_adap.device, "PT3: [%s] started\n",
+		adap->thread->comm);
 	set_freezable();
 	while (!kthread_freezable_should_stop(&was_frozen)) {
 		if (was_frozen)
@@ -468,8 +468,8 @@ static int pt3_fetch_thread(void *data)
 					PT3_FETCH_DELAY_DELTA * NSEC_PER_MSEC,
 					HRTIMER_MODE_REL);
 	}
-	dev_dbg(adap->dvb_adap.device,
-		"PT3: [%s] exited.\n", adap->thread->comm);
+	dev_dbg(adap->dvb_adap.device, "PT3: [%s] exited\n",
+		adap->thread->comm);
 	adap->thread = NULL;
 	return 0;
 }
@@ -485,8 +485,8 @@ static int pt3_start_streaming(struct pt3_adapter *adap)
 		int ret = PTR_ERR(thread);
 
 		dev_warn(adap->dvb_adap.device,
-			"PT3 (adap:%d, dmx:%d): failed to start kthread.\n",
-			adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
+			 "PT3 (adap:%d, dmx:%d): failed to start kthread\n",
+			 adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
 		return ret;
 	}
 	adap->thread = thread;
@@ -501,8 +501,8 @@ static int pt3_stop_streaming(struct pt3_adapter *adap)
 	ret = pt3_stop_dma(adap);
 	if (ret)
 		dev_warn(adap->dvb_adap.device,
-			"PT3: failed to stop streaming of adap:%d/FE:%d\n",
-			adap->dvb_adap.num, adap->fe->id);
+			 "PT3: failed to stop streaming of adap:%d/FE:%d\n",
+			 adap->dvb_adap.num, adap->fe->id);
 
 	/* kill the fetching thread */
 	ret = kthread_stop(adap->thread);
@@ -522,8 +522,8 @@ static int pt3_start_feed(struct dvb_demux_feed *feed)
 		return 0;
 	if (adap->num_feeds != 1) {
 		dev_warn(adap->dvb_adap.device,
-			"%s: unmatched start/stop_feed in adap:%i/dmx:%i.\n",
-			__func__, adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
+			 "%s: unmatched start/stop_feed in adap:%i/dmx:%i\n",
+			 __func__, adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
 		adap->num_feeds = 1;
 	}
 
@@ -553,10 +553,9 @@ static int pt3_alloc_adapter(struct pt3_board *pt3, int index)
 	struct dvb_adapter *da;
 
 	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
-	if (!adap) {
-		dev_err(&pt3->pdev->dev, "failed to alloc mem for adapter.\n");
+	if (!adap)
 		return -ENOMEM;
-	}
+
 	pt3->adaps[index] = adap;
 	adap->adap_idx = index;
 
@@ -565,7 +564,7 @@ static int pt3_alloc_adapter(struct pt3_board *pt3, int index)
 				THIS_MODULE, &pt3->pdev->dev, adapter_nr);
 		if (ret < 0) {
 			dev_err(&pt3->pdev->dev,
-				"failed to register adapter dev.\n");
+				"failed to register adapter dev\n");
 			goto err_mem;
 		}
 		da = &adap->dvb_adap;
@@ -581,7 +580,7 @@ static int pt3_alloc_adapter(struct pt3_board *pt3, int index)
 	adap->demux.stop_feed = pt3_stop_feed;
 	ret = dvb_dmx_init(&adap->demux);
 	if (ret < 0) {
-		dev_err(&pt3->pdev->dev, "failed to init dmx dev.\n");
+		dev_err(&pt3->pdev->dev, "failed to init dmx dev\n");
 		goto err_adap;
 	}
 
@@ -589,13 +588,13 @@ static int pt3_alloc_adapter(struct pt3_board *pt3, int index)
 	adap->dmxdev.demux = &adap->demux.dmx;
 	ret = dvb_dmxdev_init(&adap->dmxdev, da);
 	if (ret < 0) {
-		dev_err(&pt3->pdev->dev, "failed to init dmxdev.\n");
+		dev_err(&pt3->pdev->dev, "failed to init dmxdev\n");
 		goto err_demux;
 	}
 
 	ret = pt3_alloc_dmabuf(adap);
 	if (ret) {
-		dev_err(&pt3->pdev->dev, "failed to alloc DMA buffers.\n");
+		dev_err(&pt3->pdev->dev, "failed to alloc DMA buffers\n");
 		goto err_dmabuf;
 	}
 
@@ -695,7 +694,7 @@ static int pt3_resume(struct device *dev)
 		dvb_frontend_resume(adap->fe);
 		ret = pt3_alloc_dmabuf(adap);
 		if (ret) {
-			dev_err(&pt3->pdev->dev, "failed to alloc DMA bufs.\n");
+			dev_err(&pt3->pdev->dev, "failed to alloc DMA bufs\n");
 			continue;
 		}
 		if (adap->num_feeds > 0)
@@ -753,15 +752,14 @@ static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (ret == 0)
 			dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 		else {
-			dev_err(&pdev->dev, "Failed to set DMA mask.\n");
+			dev_err(&pdev->dev, "Failed to set DMA mask\n");
 			goto err_release_regions;
 		}
-		dev_info(&pdev->dev, "Use 32bit DMA.\n");
+		dev_info(&pdev->dev, "Use 32bit DMA\n");
 	}
 
 	pt3 = kzalloc(sizeof(*pt3), GFP_KERNEL);
 	if (!pt3) {
-		dev_err(&pdev->dev, "Failed to alloc mem for this dev.\n");
 		ret = -ENOMEM;
 		goto err_release_regions;
 	}
@@ -771,15 +769,15 @@ static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pt3->regs[0] = pci_ioremap_bar(pdev, 0);
 	pt3->regs[1] = pci_ioremap_bar(pdev, 2);
 	if (pt3->regs[0] == NULL || pt3->regs[1] == NULL) {
-		dev_err(&pdev->dev, "Failed to ioremap.\n");
+		dev_err(&pdev->dev, "Failed to ioremap\n");
 		ret = -ENOMEM;
 		goto err_kfree;
 	}
 
 	ver = ioread32(pt3->regs[0] + REG_VERSION);
 	if ((ver >> 16) != 0x0301) {
-		dev_warn(&pdev->dev, "PT%d, I/F-ver.:%d not supported",
-			ver >> 24, (ver & 0x00ff0000) >> 16);
+		dev_warn(&pdev->dev, "PT%d, I/F-ver.:%d not supported\n",
+			 ver >> 24, (ver & 0x00ff0000) >> 16);
 		ret = -ENODEV;
 		goto err_iounmap;
 	}
@@ -788,7 +786,6 @@ static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pt3->i2c_buf = kmalloc(sizeof(*pt3->i2c_buf), GFP_KERNEL);
 	if (pt3->i2c_buf == NULL) {
-		dev_err(&pdev->dev, "Failed to alloc mem for i2c.\n");
 		ret = -ENOMEM;
 		goto err_iounmap;
 	}
@@ -801,7 +798,7 @@ static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	i2c_set_adapdata(i2c, pt3);
 	ret = i2c_add_adapter(i2c);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to add i2c adapter.\n");
+		dev_err(&pdev->dev, "Failed to add i2c adapter\n");
 		goto err_i2cbuf;
 	}
 
@@ -815,20 +812,20 @@ static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			break;
 	}
 	if (i < PT3_NUM_FE) {
-		dev_err(&pdev->dev, "Failed to create FE%d.\n", i);
+		dev_err(&pdev->dev, "Failed to create FE%d\n", i);
 		goto err_cleanup_adapters;
 	}
 
 	ret = pt3_fe_init(pt3);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to init frontends.\n");
+		dev_err(&pdev->dev, "Failed to init frontends\n");
 		i = PT3_NUM_FE - 1;
 		goto err_cleanup_adapters;
 	}
 
 	dev_info(&pdev->dev,
-		"successfully init'ed PT%d (fw:0x%02x, I/F:0x%02x).\n",
-		ver >> 24, (ver >> 8) & 0xff, (ver >> 16) & 0xff);
+		 "successfully init'ed PT%d (fw:0x%02x, I/F:0x%02x)\n",
+		 ver >> 24, (ver >> 8) & 0xff, (ver >> 16) & 0xff);
 	return 0;
 
 err_cleanup_adapters:


