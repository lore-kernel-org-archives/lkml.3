Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbbADNg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:36:26 -0500
Received: from mout.web.de ([212.227.15.4]:50450 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbbADNgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:36:23 -0500
Message-ID: <54A941C1.4020906@users.sourceforge.net>
Date: Sun, 04 Jan 2015 14:36:01 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>,
        Johannes Berg <johannes@sipsolutions.net>,
        Clemens Ladisch <clemens@ladisch.de>,
        Russell King <linux@arm.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
        Thibaut Varene <T-Bone@parisc-linux.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 11/13] ALSA: Deletion of checks before the function call "iounmap"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:2eWb/2VWP1M3B3DC2QKbbSv9hHvBcUKtdiIfNYJsK2T1e8/kYJm
 IwvIdA3XoTfZlLUG0SHs1Z+rQsxcp+qvh0xxscYknmNdjz3kzXk2qww3Q2sKzcAmfsXpJ9m
 nsd7jVz7W6AoFsoWxQs0WHfZVFeKEYWpAvVymWXH22bWgRHtiBtswgGoynntwrFWWqE+Joy
 OBTEyyvAPGGCTtgwRznxw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 3 Jan 2015 22:55:54 +0100

The iounmap() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/aoa/soundbus/i2sbus/core.c | 13 ++++++-------
 sound/arm/aaci.c                 |  4 ++--
 sound/drivers/ml403-ac97cr.c     |  3 +--
 sound/isa/msnd/msnd_pinnacle.c   |  3 +--
 sound/parisc/harmony.c           |  4 +---
 sound/pci/ad1889.c               |  5 +----
 sound/pci/asihpi/hpioctl.c       |  6 ++----
 sound/pci/atiixp.c               |  3 +--
 sound/pci/atiixp_modem.c         |  3 +--
 sound/pci/aw2/aw2-alsa.c         |  4 +---
 sound/pci/bt87x.c                |  3 +--
 sound/pci/cs4281.c               |  6 ++----
 sound/pci/cs46xx/cs46xx_lib.c    |  4 ++--
 sound/pci/ctxfi/cthw20k1.c       |  5 +----
 sound/pci/ctxfi/cthw20k2.c       |  5 +----
 sound/pci/echoaudio/echoaudio.c  |  6 +-----
 sound/pci/hda/hda_intel.c        |  3 +--
 sound/pci/lola/lola.c            |  6 ++----
 sound/pci/mixart/mixart.c        |  7 +++----
 sound/pci/nm256/nm256.c          |  6 ++----
 sound/pci/rme9652/hdsp.c         |  4 +---
 sound/pci/rme9652/hdspm.c        |  4 +---
 sound/pci/rme9652/rme9652.c      |  3 +--
 sound/pci/sis7019.c              |  5 +----
 sound/pci/ymfpci/ymfpci_main.c   |  3 +--
 sound/ppc/pmac.c                 | 15 +++++----------
 26 files changed, 43 insertions(+), 90 deletions(-)

diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 4e2b4fb..7835045 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -74,10 +74,9 @@ static void i2sbus_release_dev(struct device *dev)
 	int i;
 
 	i2sdev = container_of(dev, struct i2sbus_dev, sound.ofdev.dev);
-
- 	if (i2sdev->intfregs) iounmap(i2sdev->intfregs);
- 	if (i2sdev->out.dbdma) iounmap(i2sdev->out.dbdma);
- 	if (i2sdev->in.dbdma) iounmap(i2sdev->in.dbdma);
+	iounmap(i2sdev->intfregs);
+	iounmap(i2sdev->out.dbdma);
+	iounmap(i2sdev->in.dbdma);
 	for (i = aoa_resource_i2smmio; i <= aoa_resource_rxdbdma; i++)
 		release_and_free_resource(i2sdev->allocated_resource[i]);
 	free_dbdma_descriptor_ring(i2sdev, &i2sdev->out.dbdma_ring);
@@ -318,9 +317,9 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 			free_irq(dev->interrupts[i], dev);
 	free_dbdma_descriptor_ring(dev, &dev->out.dbdma_ring);
 	free_dbdma_descriptor_ring(dev, &dev->in.dbdma_ring);
-	if (dev->intfregs) iounmap(dev->intfregs);
-	if (dev->out.dbdma) iounmap(dev->out.dbdma);
-	if (dev->in.dbdma) iounmap(dev->in.dbdma);
+	iounmap(dev->intfregs);
+	iounmap(dev->out.dbdma);
+	iounmap(dev->in.dbdma);
 	for (i=0;i<3;i++)
 		release_and_free_resource(dev->allocated_resource[i]);
 	mutex_destroy(&dev->lock);
diff --git a/sound/arm/aaci.c b/sound/arm/aaci.c
index 0e83a73..4140b1b 100644
--- a/sound/arm/aaci.c
+++ b/sound/arm/aaci.c
@@ -889,8 +889,8 @@ static int aaci_probe_ac97(struct aaci *aaci)
 static void aaci_free_card(struct snd_card *card)
 {
 	struct aaci *aaci = card->private_data;
-	if (aaci->base)
-		iounmap(aaci->base);
+
+	iounmap(aaci->base);
 }
 
 static struct aaci *aaci_init_card(struct amba_device *dev)
diff --git a/sound/drivers/ml403-ac97cr.c b/sound/drivers/ml403-ac97cr.c
index ec01de1..bdcb572 100644
--- a/sound/drivers/ml403-ac97cr.c
+++ b/sound/drivers/ml403-ac97cr.c
@@ -1094,8 +1094,7 @@ static int snd_ml403_ac97cr_free(struct snd_ml403_ac97cr *ml403_ac97cr)
 	if (ml403_ac97cr->capture_irq >= 0)
 		free_irq(ml403_ac97cr->capture_irq, ml403_ac97cr);
 	/* give back "port" */
-	if (ml403_ac97cr->port != NULL)
-		iounmap(ml403_ac97cr->port);
+	iounmap(ml403_ac97cr->port);
 	kfree(ml403_ac97cr);
 	PDEBUG(INIT_INFO, "free(): (done)\n");
 	return 0;
diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 65b3682..4c07266 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -627,8 +627,7 @@ static int snd_msnd_attach(struct snd_card *card)
 	return 0;
 
 err_release_region:
-	if (chip->mappedbase)
-		iounmap(chip->mappedbase);
+	iounmap(chip->mappedbase);
 	release_mem_region(chip->base, BUFFSIZE);
 	release_region(chip->io, DSP_NUMIO);
 	free_irq(chip->irq, chip);
diff --git a/sound/parisc/harmony.c b/sound/parisc/harmony.c
index 29604a2..f2350c1 100644
--- a/sound/parisc/harmony.c
+++ b/sound/parisc/harmony.c
@@ -893,9 +893,7 @@ snd_harmony_free(struct snd_harmony *h)
 	if (h->irq >= 0)
 		free_irq(h->irq, h);
 
-	if (h->iobase)
-		iounmap(h->iobase);
-
+	iounmap(h->iobase);
 	kfree(h);
 	return 0;
 }
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index 547ee30..0de3129 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -853,12 +853,9 @@ snd_ad1889_free(struct snd_ad1889 *chip)
 		free_irq(chip->irq, chip);
 
 skip_hw:
-	if (chip->iobase)
-		iounmap(chip->iobase);
-
+	iounmap(chip->iobase);
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
-
 	kfree(chip);
 	return 0;
 }
diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index 72af66b..67d1133 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -541,10 +541,8 @@ void asihpi_adapter_remove(struct pci_dev *pci_dev)
 	hpi_send_recv_ex(&hm, &hr, HOWNER_KERNEL);
 
 	/* unmap PCI memory space, mapped during device init. */
-	for (idx = 0; idx < HPI_MAX_ADAPTER_MEM_SPACES; idx++) {
-		if (pci.ap_mem_base[idx])
-			iounmap(pci.ap_mem_base[idx]);
-	}
+	for (idx = 0; idx < HPI_MAX_ADAPTER_MEM_SPACES; ++idx)
+		iounmap(pci.ap_mem_base[idx]);
 
 	if (pa->irq)
 		free_irq(pa->irq, pa);
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 9c1c445..d24188f 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1585,8 +1585,7 @@ static int snd_atiixp_free(struct atiixp *chip)
       __hw_end:
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	if (chip->remap_addr)
-		iounmap(chip->remap_addr);
+	iounmap(chip->remap_addr);
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 	kfree(chip);
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index b2f63e0..c321a97 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1211,8 +1211,7 @@ static int snd_atiixp_free(struct atiixp_modem *chip)
       __hw_end:
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	if (chip->remap_addr)
-		iounmap(chip->remap_addr);
+	iounmap(chip->remap_addr);
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 	kfree(chip);
diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
index e1cf019..8d2fee7 100644
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -229,9 +229,7 @@ static int snd_aw2_dev_free(struct snd_device *device)
 	if (chip->irq >= 0)
 		free_irq(chip->irq, (void *)chip);
 	/* release the i/o ports & memory */
-	if (chip->iobase_virt)
-		iounmap(chip->iobase_virt);
-
+	iounmap(chip->iobase_virt);
 	pci_release_regions(chip->pci);
 	/* disable the PCI entry */
 	pci_disable_device(chip->pci);
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 058b997..e82ceac 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -690,8 +690,7 @@ static int snd_bt87x_free(struct snd_bt87x *chip)
 		snd_bt87x_stop(chip);
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	if (chip->mmio)
-		iounmap(chip->mmio);
+	iounmap(chip->mmio);
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 	kfree(chip);
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 05a4337..ea33911 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1316,10 +1316,8 @@ static int snd_cs4281_free(struct cs4281 *chip)
 
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	if (chip->ba0)
-		iounmap(chip->ba0);
-	if (chip->ba1)
-		iounmap(chip->ba1);
+	iounmap(chip->ba0);
+	iounmap(chip->ba1);
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 
diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index dfec84e..128bbfe 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -2949,8 +2949,8 @@ static int snd_cs46xx_free(struct snd_cs46xx *chip)
 
 	for (idx = 0; idx < 5; idx++) {
 		struct snd_cs46xx_region *region = &chip->region.idx[idx];
-		if (region->remap_addr)
-			iounmap(region->remap_addr);
+
+		iounmap(region->remap_addr);
 		release_and_free_resource(region->resource);
 	}
 
diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
index b425aa8..b8b0d8e 100644
--- a/sound/pci/ctxfi/cthw20k1.c
+++ b/sound/pci/ctxfi/cthw20k1.c
@@ -1985,10 +1985,7 @@ static int hw_card_shutdown(struct hw *hw)
 		free_irq(hw->irq, hw);
 
 	hw->irq	= -1;
-
-	if (hw->mem_base)
-		iounmap(hw->mem_base);
-
+	iounmap(hw->mem_base);
 	hw->mem_base = NULL;
 
 	if (hw->io_base)
diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index 253899d..4e16b4d 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -2110,10 +2110,7 @@ static int hw_card_shutdown(struct hw *hw)
 		free_irq(hw->irq, hw);
 
 	hw->irq	= -1;
-
-	if (hw->mem_base)
-		iounmap(hw->mem_base);
-
+	iounmap(hw->mem_base);
 	hw->mem_base = NULL;
 
 	if (hw->io_base)
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 21228ad..98d4f35 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -1872,12 +1872,8 @@ static int snd_echo_free(struct echoaudio *chip)
 	if (chip->comm_page)
 		snd_dma_free_pages(&chip->commpage_dma_buf);
 
-	if (chip->dsp_registers)
-		iounmap(chip->dsp_registers);
-
+	iounmap(chip->dsp_registers);
 	release_and_free_resource(chip->iores);
-
-
 	pci_disable_device(chip->pci);
 
 	/* release chip data */
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index d426a0b..a971425 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1138,8 +1138,7 @@ static int azx_free(struct azx *chip)
 		free_irq(chip->irq, (void*)chip);
 	if (chip->msi)
 		pci_disable_msi(chip->pci);
-	if (chip->remap_addr)
-		iounmap(chip->remap_addr);
+	iounmap(chip->remap_addr);
 
 	azx_free_stream_pages(chip);
 	if (chip->region_requested)
diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
index 4cf4be5..9ff60008 100644
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -551,10 +551,8 @@ static void lola_free(struct lola *chip)
 	lola_free_mixer(chip);
 	if (chip->irq >= 0)
 		free_irq(chip->irq, (void *)chip);
-	if (chip->bar[0].remap_addr)
-		iounmap(chip->bar[0].remap_addr);
-	if (chip->bar[1].remap_addr)
-		iounmap(chip->bar[1].remap_addr);
+	iounmap(chip->bar[0].remap_addr);
+	iounmap(chip->bar[1].remap_addr);
 	if (chip->rb.area)
 		snd_dma_free_pages(&chip->rb);
 	pci_release_regions(chip->pci);
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 1faf47e..c3a9f39 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1114,10 +1114,9 @@ static int snd_mixart_free(struct mixart_mgr *mgr)
 	}
 
 	/* release the i/o ports */
-	for (i = 0; i < 2; i++) {
-		if (mgr->mem[i].virt)
-			iounmap(mgr->mem[i].virt);
-	}
+	for (i = 0; i < 2; ++i)
+		iounmap(mgr->mem[i].virt);
+
 	pci_release_regions(mgr->pci);
 
 	/* free flowarray */
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 4e41a4e..3f52a44 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1460,10 +1460,8 @@ static int snd_nm256_free(struct nm256 *chip)
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 
-	if (chip->cport)
-		iounmap(chip->cport);
-	if (chip->buffer)
-		iounmap(chip->buffer);
+	iounmap(chip->cport);
+	iounmap(chip->buffer);
 	release_and_free_resource(chip->res_cport);
 	release_and_free_resource(chip->res_buffer);
 
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index cf5a6c8..fe66bcb 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -5309,9 +5309,7 @@ static int snd_hdsp_free(struct hdsp *hdsp)
 
 	release_firmware(hdsp->firmware);
 	vfree(hdsp->fw_uploaded);
-
-	if (hdsp->iobase)
-		iounmap(hdsp->iobase);
+	iounmap(hdsp->iobase);
 
 	if (hdsp->port)
 		pci_release_regions(hdsp->pci);
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 3342705..8109b8e 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6965,9 +6965,7 @@ static int snd_hdspm_free(struct hdspm * hdspm)
 		free_irq(hdspm->irq, (void *) hdspm);
 
 	kfree(hdspm->mixer);
-
-	if (hdspm->iobase)
-		iounmap(hdspm->iobase);
+	iounmap(hdspm->iobase);
 
 	if (hdspm->port)
 		pci_release_regions(hdspm->pci);
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 6521521..648911c 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -1756,8 +1756,7 @@ static int snd_rme9652_free(struct snd_rme9652 *rme9652)
 
 	if (rme9652->irq >= 0)
 		free_irq(rme9652->irq, (void *)rme9652);
-	if (rme9652->iobase)
-		iounmap(rme9652->iobase);
+	iounmap(rme9652->iobase);
 	if (rme9652->port)
 		pci_release_regions(rme9652->pci);
 
diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index 7f6a0a0..5e9437b 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -1064,12 +1064,9 @@ static int sis_chip_free(struct sis7019 *sis)
 	if (sis->irq >= 0)
 		free_irq(sis->irq, sis);
 
-	if (sis->ioaddr)
-		iounmap(sis->ioaddr);
-
+	iounmap(sis->ioaddr);
 	pci_release_regions(sis->pci);
 	pci_disable_device(sis->pci);
-
 	sis_free_suspend(sis);
 	return 0;
 }
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index f5581a9..de7f06f 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -2246,8 +2246,7 @@ static int snd_ymfpci_free(struct snd_ymfpci *chip)
 	release_and_free_resource(chip->mpu_res);
 	release_and_free_resource(chip->fm_res);
 	snd_ymfpci_free_gameport(chip);
-	if (chip->reg_area_virt)
-		iounmap(chip->reg_area_virt);
+	iounmap(chip->reg_area_virt);
 	if (chip->work_ptr.area)
 		snd_dma_free_pages(&chip->work_ptr);
 	
diff --git a/sound/ppc/pmac.c b/sound/ppc/pmac.c
index 5a13b22..d399df4 100644
--- a/sound/ppc/pmac.c
+++ b/sound/ppc/pmac.c
@@ -867,16 +867,11 @@ static int snd_pmac_free(struct snd_pmac *chip)
 	snd_pmac_dbdma_free(chip, &chip->capture.cmd);
 	snd_pmac_dbdma_free(chip, &chip->extra_dma);
 	snd_pmac_dbdma_free(chip, &emergency_dbdma);
-	if (chip->macio_base)
-		iounmap(chip->macio_base);
-	if (chip->latch_base)
-		iounmap(chip->latch_base);
-	if (chip->awacs)
-		iounmap(chip->awacs);
-	if (chip->playback.dma)
-		iounmap(chip->playback.dma);
-	if (chip->capture.dma)
-		iounmap(chip->capture.dma);
+	iounmap(chip->macio_base);
+	iounmap(chip->latch_base);
+	iounmap(chip->awacs);
+	iounmap(chip->playback.dma);
+	iounmap(chip->capture.dma);
 
 	if (chip->node) {
 		int i;
-- 
2.2.1

