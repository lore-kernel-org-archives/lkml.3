Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaKCKeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:34:36 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56277 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaKCKea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:34:30 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ALSA: echoaudio: remove all snd_printk
Date: Mon,  3 Nov 2014 16:04:13 +0530
Message-Id: <1415010853-4334-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1415010853-4334-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415010853-4334-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed all references of snd_printk with the standard dev_* macro.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

change in v2 : replaced dev_info with dev_dbg.

 sound/pci/echoaudio/darla20_dsp.c        |   7 +-
 sound/pci/echoaudio/darla24_dsp.c        |  15 ++--
 sound/pci/echoaudio/echo3g_dsp.c         |   7 +-
 sound/pci/echoaudio/echoaudio.c          | 141 ++++++++++++++++---------------
 sound/pci/echoaudio/echoaudio.h          |  28 ------
 sound/pci/echoaudio/echoaudio_3g.c       |  32 ++++---
 sound/pci/echoaudio/echoaudio_dsp.c      | 111 ++++++++++++++----------
 sound/pci/echoaudio/echoaudio_gml.c      |  11 +--
 sound/pci/echoaudio/gina20_dsp.c         |  15 ++--
 sound/pci/echoaudio/gina24_dsp.c         |  39 +++++----
 sound/pci/echoaudio/indigo_dsp.c         |  13 +--
 sound/pci/echoaudio/indigo_express_dsp.c |   6 +-
 sound/pci/echoaudio/indigodj_dsp.c       |  13 +--
 sound/pci/echoaudio/indigodjx_dsp.c      |   7 +-
 sound/pci/echoaudio/indigoio_dsp.c       |  10 ++-
 sound/pci/echoaudio/indigoiox_dsp.c      |   7 +-
 sound/pci/echoaudio/layla20_dsp.c        |  37 ++++----
 sound/pci/echoaudio/layla24_dsp.c        |  34 ++++----
 sound/pci/echoaudio/mia_dsp.c            |  17 ++--
 sound/pci/echoaudio/midi.c               |  29 ++++---
 sound/pci/echoaudio/mona_dsp.c           |  35 ++++----
 21 files changed, 329 insertions(+), 285 deletions(-)

diff --git a/sound/pci/echoaudio/darla20_dsp.c b/sound/pci/echoaudio/darla20_dsp.c
index 20c7cbc..2eba172 100644
--- a/sound/pci/echoaudio/darla20_dsp.c
+++ b/sound/pci/echoaudio/darla20_dsp.c
@@ -33,12 +33,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Darla20\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Darla20\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != DARLA20))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw: could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -57,7 +58,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw: done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/darla24_dsp.c b/sound/pci/echoaudio/darla24_dsp.c
index 6da6663..4db3b99 100644
--- a/sound/pci/echoaudio/darla24_dsp.c
+++ b/sound/pci/echoaudio/darla24_dsp.c
@@ -33,12 +33,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Darla24\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Darla24\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != DARLA24))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw: could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -56,7 +57,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw: done\n");
 	return err;
 }
 
@@ -128,15 +129,17 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 		clock = GD24_8000;
 		break;
 	default:
-		DE_ACT(("set_sample_rate: Error, invalid sample rate %d\n",
-			rate));
+		dev_err(chip->card->dev,
+			"set_sample_rate: Error, invalid sample rate %d\n",
+			rate);
 		return -EINVAL;
 	}
 
 	if (wait_handshake(chip))
 		return -EIO;
 
-	DE_ACT(("set_sample_rate: %d clock %d\n", rate, clock));
+	dev_dbg(chip->card->dev,
+		"set_sample_rate: %d clock %d\n", rate, clock);
 	chip->sample_rate = rate;
 
 	/* Override the sample rate if this card is set to Echo sync. */
diff --git a/sound/pci/echoaudio/echo3g_dsp.c b/sound/pci/echoaudio/echo3g_dsp.c
index 3cdc2ee..d25830b 100644
--- a/sound/pci/echoaudio/echo3g_dsp.c
+++ b/sound/pci/echoaudio/echo3g_dsp.c
@@ -46,12 +46,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 	int err;
 
 	local_irq_enable();
-	DE_INIT(("init_hw() - Echo3G\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Echo3G\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != ECHO3G))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -98,7 +99,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 				ECHOCAPS_HAS_DIGITAL_MODE_SPDIF_OPTICAL |
 				ECHOCAPS_HAS_DIGITAL_MODE_ADAT;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index db1b247..8ebc015 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -48,13 +48,16 @@ static int get_firmware(const struct firmware **fw_entry,
 
 #ifdef CONFIG_PM_SLEEP
 	if (chip->fw_cache[fw_index]) {
-		DE_ACT(("firmware requested: %s is cached\n", card_fw[fw_index].data));
+		dev_dbg(chip->card->dev,
+			"firmware requested: %s is cached\n",
+			card_fw[fw_index].data);
 		*fw_entry = chip->fw_cache[fw_index];
 		return 0;
 	}
 #endif
 
-	DE_ACT(("firmware requested: %s\n", card_fw[fw_index].data));
+	dev_dbg(chip->card->dev,
+		"firmware requested: %s\n", card_fw[fw_index].data);
 	snprintf(name, sizeof(name), "ea/%s", card_fw[fw_index].data);
 	err = request_firmware(fw_entry, name, pci_device(chip));
 	if (err < 0)
@@ -73,10 +76,10 @@ static void free_firmware(const struct firmware *fw_entry,
 			  struct echoaudio *chip)
 {
 #ifdef CONFIG_PM_SLEEP
-	DE_ACT(("firmware not released (kept in cache)\n"));
+	dev_dbg(chip->card->dev, "firmware not released (kept in cache)\n");
 #else
 	release_firmware(fw_entry);
-	DE_ACT(("firmware released\n"));
+	dev_dbg(chip->card->dev, "firmware released\n");
 #endif
 }
 
@@ -90,10 +93,10 @@ static void free_firmware_cache(struct echoaudio *chip)
 	for (i = 0; i < 8 ; i++)
 		if (chip->fw_cache[i]) {
 			release_firmware(chip->fw_cache[i]);
-			DE_ACT(("release_firmware(%d)\n", i));
+			dev_dbg(chip->card->dev, "release_firmware(%d)\n", i);
 		}
 
-	DE_ACT(("firmware_cache released\n"));
+	dev_dbg(chip->card->dev, "firmware_cache released\n");
 #endif
 }
 
@@ -287,7 +290,7 @@ static int pcm_open(struct snd_pcm_substream *substream,
 
 	/* Set up hw capabilities and contraints */
 	memcpy(&pipe->hw, &pcm_hardware_skel, sizeof(struct snd_pcm_hardware));
-	DE_HWP(("max_channels=%d\n", max_channels));
+	dev_dbg(chip->card->dev, "max_channels=%d\n", max_channels);
 	pipe->constr.list = channels_list;
 	pipe->constr.mask = 0;
 	for (i = 0; channels_list[i] <= max_channels; i++);
@@ -337,7 +340,7 @@ static int pcm_open(struct snd_pcm_substream *substream,
 	if ((err = snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV,
 				       snd_dma_pci_data(chip->pci),
 				       PAGE_SIZE, &pipe->sgpage)) < 0) {
-		DE_HWP(("s-g list allocation failed\n"));
+		dev_err(chip->card->dev, "s-g list allocation failed\n");
 		return err;
 	}
 
@@ -351,7 +354,7 @@ static int pcm_analog_in_open(struct snd_pcm_substream *substream)
 	struct echoaudio *chip = snd_pcm_substream_chip(substream);
 	int err;
 
-	DE_ACT(("pcm_analog_in_open\n"));
+	dev_dbg(chip->card->dev, "pcm_analog_in_open\n");
 	if ((err = pcm_open(substream, num_analog_busses_in(chip) -
 			    substream->number)) < 0)
 		return err;
@@ -368,9 +371,9 @@ static int pcm_analog_in_open(struct snd_pcm_substream *substream)
 	atomic_inc(&chip->opencount);
 	if (atomic_read(&chip->opencount) > 1 && chip->rate_set)
 		chip->can_set_rate=0;
-	DE_HWP(("pcm_analog_in_open  cs=%d  oc=%d  r=%d\n",
+	dev_dbg(chip->card->dev, "pcm_analog_in_open  cs=%d  oc=%d  r=%d\n",
 		chip->can_set_rate, atomic_read(&chip->opencount),
-		chip->sample_rate));
+		chip->sample_rate);
 	return 0;
 }
 
@@ -386,7 +389,7 @@ static int pcm_analog_out_open(struct snd_pcm_substream *substream)
 #else
 	max_channels = num_analog_busses_out(chip);
 #endif
-	DE_ACT(("pcm_analog_out_open\n"));
+	dev_dbg(chip->card->dev, "pcm_analog_out_open\n");
 	if ((err = pcm_open(substream, max_channels - substream->number)) < 0)
 		return err;
 	if ((err = snd_pcm_hw_rule_add(substream->runtime, 0,
@@ -404,9 +407,9 @@ static int pcm_analog_out_open(struct snd_pcm_substream *substream)
 	atomic_inc(&chip->opencount);
 	if (atomic_read(&chip->opencount) > 1 && chip->rate_set)
 		chip->can_set_rate=0;
-	DE_HWP(("pcm_analog_out_open  cs=%d  oc=%d  r=%d\n",
-		chip->can_set_rate, atomic_read(&chip->opencount),
-		chip->sample_rate));
+	dev_dbg(chip->card->dev, "pcm_analog_out_open  cs=%d  oc=%d  r=%d\n",
+		chip->can_set_rate, atomic_read(&chip->opencount),
+		chip->sample_rate);
 	return 0;
 }
 
@@ -419,7 +422,7 @@ static int pcm_digital_in_open(struct snd_pcm_substream *substream)
 	struct echoaudio *chip = snd_pcm_substream_chip(substream);
 	int err, max_channels;
 
-	DE_ACT(("pcm_digital_in_open\n"));
+	dev_dbg(chip->card->dev, "pcm_digital_in_open\n");
 	max_channels = num_digital_busses_in(chip) - substream->number;
 	mutex_lock(&chip->mode_mutex);
 	if (chip->digital_mode == DIGITAL_MODE_ADAT)
@@ -461,7 +464,7 @@ static int pcm_digital_out_open(struct snd_pcm_substream *substream)
 	struct echoaudio *chip = snd_pcm_substream_chip(substream);
 	int err, max_channels;
 
-	DE_ACT(("pcm_digital_out_open\n"));
+	dev_dbg(chip->card->dev, "pcm_digital_out_open\n");
 	max_channels = num_digital_busses_out(chip) - substream->number;
 	mutex_lock(&chip->mode_mutex);
 	if (chip->digital_mode == DIGITAL_MODE_ADAT)
@@ -508,18 +511,18 @@ static int pcm_close(struct snd_pcm_substream *substream)
 	/* Nothing to do here. Audio is already off and pipe will be
 	 * freed by its callback
 	 */
-	DE_ACT(("pcm_close\n"));
+	dev_dbg(chip->card->dev, "pcm_close\n");
 
 	atomic_dec(&chip->opencount);
 	oc = atomic_read(&chip->opencount);
-	DE_ACT(("pcm_close  oc=%d  cs=%d  rs=%d\n", oc,
-		chip->can_set_rate, chip->rate_set));
+	dev_dbg(chip->card->dev, "pcm_close  oc=%d  cs=%d  rs=%d\n", oc,
+		chip->can_set_rate, chip->rate_set);
 	if (oc < 2)
 		chip->can_set_rate = 1;
 	if (oc == 0)
 		chip->rate_set = 0;
-	DE_ACT(("pcm_close2 oc=%d  cs=%d  rs=%d\n", oc,
-		chip->can_set_rate,chip->rate_set));
+	dev_dbg(chip->card->dev, "pcm_close2 oc=%d  cs=%d  rs=%d\n", oc,
+		chip->can_set_rate, chip->rate_set);
 
 	return 0;
 }
@@ -543,7 +546,7 @@ static int init_engine(struct snd_pcm_substream *substream,
 	 */
 	spin_lock_irq(&chip->lock);
 	if (pipe->index >= 0) {
-		DE_HWP(("hwp_ie free(%d)\n", pipe->index));
+		dev_dbg(chip->card->dev, "hwp_ie free(%d)\n", pipe->index);
 		err = free_pipes(chip, pipe);
 		snd_BUG_ON(err);
 		chip->substream[pipe->index] = NULL;
@@ -552,16 +555,17 @@ static int init_engine(struct snd_pcm_substream *substream,
 	err = allocate_pipes(chip, pipe, pipe_index, interleave);
 	if (err < 0) {
 		spin_unlock_irq(&chip->lock);
-		DE_ACT((KERN_NOTICE "allocate_pipes(%d) err=%d\n",
-			pipe_index, err));
+		dev_err(chip->card->dev, "allocate_pipes(%d) err=%d\n",
+			pipe_index, err);
 		return err;
 	}
 	spin_unlock_irq(&chip->lock);
-	DE_ACT((KERN_NOTICE "allocate_pipes()=%d\n", pipe_index));
+	dev_notice(chip->card->dev, "allocate_pipes()=%d\n", pipe_index);
 
-	DE_HWP(("pcm_hw_params (bufsize=%dB periods=%d persize=%dB)\n",
-		params_buffer_bytes(hw_params), params_periods(hw_params),
-		params_period_bytes(hw_params)));
+	dev_dbg(chip->card->dev,
+		"pcm_hw_params (bufsize=%dB periods=%d persize=%dB)\n",
+		params_buffer_bytes(hw_params), params_periods(hw_params),
+		params_period_bytes(hw_params));
 	err = snd_pcm_lib_malloc_pages(substream,
 				       params_buffer_bytes(hw_params));
 	if (err < 0) {
@@ -616,7 +620,7 @@ static int init_engine(struct snd_pcm_substream *substream,
 	spin_lock_irq(&chip->lock);
 	set_sample_rate(chip, hw_params->rate_num / hw_params->rate_den);
 	spin_unlock_irq(&chip->lock);
-	DE_HWP(("pcm_hw_params ok\n"));
+	dev_dbg(chip->card->dev, "pcm_hw_params ok\n");
 	return 0;
 }
 
@@ -680,14 +684,14 @@ static int pcm_hw_free(struct snd_pcm_substream *substream)
 
 	spin_lock_irq(&chip->lock);
 	if (pipe->index >= 0) {
-		DE_HWP(("pcm_hw_free(%d)\n", pipe->index));
+		dev_dbg(chip->card->dev, "pcm_hw_free(%d)\n", pipe->index);
 		free_pipes(chip, pipe);
 		chip->substream[pipe->index] = NULL;
 		pipe->index = -1;
 	}
 	spin_unlock_irq(&chip->lock);
 
-	DE_HWP(("pcm_hw_freed\n"));
+	dev_dbg(chip->card->dev, "pcm_hw_freed\n");
 	snd_pcm_lib_free_pages(substream);
 	return 0;
 }
@@ -701,8 +705,8 @@ static int pcm_prepare(struct snd_pcm_substream *substream)
 	struct audioformat format;
 	int pipe_index = ((struct audiopipe *)runtime->private_data)->index;
 
-	DE_HWP(("Prepare rate=%d format=%d channels=%d\n",
-		runtime->rate, runtime->format, runtime->channels));
+	dev_dbg(chip->card->dev, "Prepare rate=%d format=%d channels=%d\n",
+		runtime->rate, runtime->format, runtime->channels);
 	format.interleave = runtime->channels;
 	format.data_are_bigendian = 0;
 	format.mono_to_stereo = 0;
@@ -722,8 +726,9 @@ static int pcm_prepare(struct snd_pcm_substream *substream)
 		format.bits_per_sample = 32;
 		break;
 	default:
-		DE_HWP(("Prepare error: unsupported format %d\n",
-			runtime->format));
+		dev_err(chip->card->dev,
+			"Prepare error: unsupported format %d\n",
+			runtime->format);
 		return -EINVAL;
 	}
 
@@ -758,10 +763,10 @@ static int pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	spin_lock(&chip->lock);
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_RESUME:
-		DE_ACT(("pcm_trigger resume\n"));
+		dev_dbg(chip->card->dev, "pcm_trigger resume\n");
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		DE_ACT(("pcm_trigger start\n"));
+		dev_dbg(chip->card->dev, "pcm_trigger start\n");
 		for (i = 0; i < DSP_MAXPIPES; i++) {
 			if (channelmask & (1 << i)) {
 				pipe = chip->substream[i]->runtime->private_data;
@@ -783,9 +788,9 @@ static int pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 				      chip->pipe_cyclic_mask);
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-		DE_ACT(("pcm_trigger suspend\n"));
+		dev_dbg(chip->card->dev, "pcm_trigger suspend\n");
 	case SNDRV_PCM_TRIGGER_STOP:
-		DE_ACT(("pcm_trigger stop\n"));
+		dev_dbg(chip->card->dev, "pcm_trigger stop\n");
 		for (i = 0; i < DSP_MAXPIPES; i++) {
 			if (channelmask & (1 << i)) {
 				pipe = chip->substream[i]->runtime->private_data;
@@ -795,7 +800,7 @@ static int pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 		err = stop_transport(chip, channelmask);
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		DE_ACT(("pcm_trigger pause\n"));
+		dev_dbg(chip->card->dev, "pcm_trigger pause\n");
 		for (i = 0; i < DSP_MAXPIPES; i++) {
 			if (channelmask & (1 << i)) {
 				pipe = chip->substream[i]->runtime->private_data;
@@ -932,7 +937,7 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &analog_capture_ops);
 	if ((err = snd_echo_preallocate_pages(pcm, snd_dma_pci_data(chip->pci))) < 0)
 		return err;
-	DE_INIT(("Analog PCM ok\n"));
+	dev_dbg(chip->card->dev, "Analog PCM ok\n");
 
 #ifdef ECHOCARD_HAS_DIGITAL_IO
 	/* PCM#1 Digital inputs, no outputs */
@@ -945,7 +950,7 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &digital_capture_ops);
 	if ((err = snd_echo_preallocate_pages(pcm, snd_dma_pci_data(chip->pci))) < 0)
 		return err;
-	DE_INIT(("Digital PCM ok\n"));
+	dev_dbg(chip->card->dev, "Digital PCM ok\n");
 #endif /* ECHOCARD_HAS_DIGITAL_IO */
 
 #else /* ECHOCARD_HAS_VMIXER */
@@ -967,7 +972,7 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &analog_capture_ops);
 	if ((err = snd_echo_preallocate_pages(pcm, snd_dma_pci_data(chip->pci))) < 0)
 		return err;
-	DE_INIT(("Analog PCM ok\n"));
+	dev_dbg(chip->card->dev, "Analog PCM ok\n");
 
 #ifdef ECHOCARD_HAS_DIGITAL_IO
 	/* PCM#1 Digital i/o */
@@ -982,7 +987,7 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &digital_capture_ops);
 	if ((err = snd_echo_preallocate_pages(pcm, snd_dma_pci_data(chip->pci))) < 0)
 		return err;
-	DE_INIT(("Digital PCM ok\n"));
+	dev_dbg(chip->card->dev, "Digital PCM ok\n");
 #endif /* ECHOCARD_HAS_DIGITAL_IO */
 
 #endif /* ECHOCARD_HAS_VMIXER */
@@ -1475,7 +1480,8 @@ static int snd_echo_digital_mode_put(struct snd_kcontrol *kcontrol,
 				snd_ctl_notify(chip->card,
 					       SNDRV_CTL_EVENT_MASK_VALUE,
 					       &chip->clock_src_ctl->id);
-				DE_ACT(("SDM() =%d\n", changed));
+				dev_dbg(chip->card->dev,
+					"SDM() =%d\n", changed);
 			}
 			if (changed >= 0)
 				changed = 1;	/* No errors */
@@ -1602,7 +1608,8 @@ static int snd_echo_clock_source_put(struct snd_kcontrol *kcontrol,
 	}
 
 	if (changed < 0)
-		DE_ACT(("seticlk val%d err 0x%x\n", dclock, changed));
+		dev_dbg(chip->card->dev,
+			"seticlk val%d err 0x%x\n", dclock, changed);
 
 	return changed;
 }
@@ -1859,7 +1866,7 @@ static irqreturn_t snd_echo_interrupt(int irq, void *dev_id)
 #ifdef ECHOCARD_HAS_MIDI
 	if (st > 0 && chip->midi_in) {
 		snd_rawmidi_receive(chip->midi_in, chip->midi_buffer, st);
-		DE_MID(("rawmidi_iread=%d\n", st));
+		dev_dbg(chip->card->dev, "rawmidi_iread=%d\n", st);
 	}
 #endif
 	return IRQ_HANDLED;
@@ -1874,10 +1881,10 @@ static irqreturn_t snd_echo_interrupt(int irq, void *dev_id)
 
 static int snd_echo_free(struct echoaudio *chip)
 {
-	DE_INIT(("Stop DSP...\n"));
+	dev_dbg(chip->card->dev, "Stop DSP...\n");
 	if (chip->comm_page)
 		rest_in_peace(chip);
-	DE_INIT(("Stopped.\n"));
+	dev_dbg(chip->card->dev, "Stopped.\n");
 
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
@@ -1891,14 +1898,14 @@ static int snd_echo_free(struct echoaudio *chip)
 	if (chip->iores)
 		release_and_free_resource(chip->iores);
 
-	DE_INIT(("MMIO freed.\n"));
+	dev_dbg(chip->card->dev, "MMIO freed.\n");
 
 	pci_disable_device(chip->pci);
 
 	/* release chip data */
 	free_firmware_cache(chip);
 	kfree(chip);
-	DE_INIT(("Chip freed.\n"));
+	dev_dbg(chip->card->dev, "Chip freed.\n");
 	return 0;
 }
 
@@ -1908,7 +1915,7 @@ static int snd_echo_dev_free(struct snd_device *device)
 {
 	struct echoaudio *chip = device->device_data;
 
-	DE_INIT(("snd_echo_dev_free()...\n"));
+	dev_dbg(chip->card->dev, "snd_echo_dev_free()...\n");
 	return snd_echo_free(chip);
 }
 
@@ -1941,7 +1948,7 @@ static int snd_echo_create(struct snd_card *card,
 			pci_disable_device(pci);
 			return -ENOMEM;
 		}
-		DE_INIT(("chip=%p\n", chip));
+		dev_dbg(card->dev, "chip=%p\n", chip);
 		spin_lock_init(&chip->lock);
 		chip->card = card;
 		chip->pci = pci;
@@ -1978,8 +1985,8 @@ static int snd_echo_create(struct snd_card *card,
 		return -EBUSY;
 	}
 	chip->irq = pci->irq;
-	DE_INIT(("pci=%p irq=%d subdev=%04x Init hardware...\n",
-		 chip->pci, chip->irq, chip->pci->subsystem_device));
+	dev_dbg(card->dev, "pci=%p irq=%d subdev=%04x Init hardware...\n",
+		chip->pci, chip->irq, chip->pci->subsystem_device);
 
 	/* Create the DSP comm page - this is the area of memory used for most
 	of the communication with the DSP, which accesses it via bus mastering */
@@ -1997,11 +2004,11 @@ static int snd_echo_create(struct snd_card *card,
 	if (err >= 0)
 		err = set_mixer_defaults(chip);
 	if (err < 0) {
-		DE_INIT(("init_hw err=%d\n", err));
+		dev_err(card->dev, "init_hw err=%d\n", err);
 		snd_echo_free(chip);
 		return err;
 	}
-	DE_INIT(("Card init OK\n"));
+	dev_dbg(card->dev, "Card init OK\n");
 
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
 		snd_echo_free(chip);
@@ -2031,7 +2038,7 @@ static int snd_echo_probe(struct pci_dev *pci,
 		return -ENOENT;
 	}
 
-	DE_INIT(("Echoaudio driver starting...\n"));
+	dev_dbg(&pci->dev, "Echoaudio driver starting...\n");
 	i = 0;
 	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   0, &card);
@@ -2184,7 +2191,7 @@ static int snd_echo_suspend(struct device *dev)
 	struct pci_dev *pci = to_pci_dev(dev);
 	struct echoaudio *chip = dev_get_drvdata(dev);
 
-	DE_INIT(("suspend start\n"));
+	dev_dbg(dev, "suspend start\n");
 	snd_pcm_suspend_all(chip->analog_pcm);
 	snd_pcm_suspend_all(chip->digital_pcm);
 
@@ -2211,7 +2218,7 @@ static int snd_echo_suspend(struct device *dev)
 	pci_save_state(pci);
 	pci_disable_device(pci);
 
-	DE_INIT(("suspend done\n"));
+	dev_dbg(dev, "suspend done\n");
 	return 0;
 }
 
@@ -2225,7 +2232,7 @@ static int snd_echo_resume(struct device *dev)
 	u32 pipe_alloc_mask;
 	int err;
 
-	DE_INIT(("resume start\n"));
+	dev_dbg(dev, "resume start\n");
 	pci_restore_state(pci);
 	commpage_bak = kmalloc(sizeof(struct echoaudio), GFP_KERNEL);
 	if (commpage_bak == NULL)
@@ -2236,11 +2243,11 @@ static int snd_echo_resume(struct device *dev)
 	err = init_hw(chip, chip->pci->device, chip->pci->subsystem_device);
 	if (err < 0) {
 		kfree(commpage_bak);
-		DE_INIT(("resume init_hw err=%d\n", err));
+		dev_err(dev, "resume init_hw err=%d\n", err);
 		snd_echo_free(chip);
 		return err;
 	}
-	DE_INIT(("resume init OK\n"));
+	dev_dbg(dev, "resume init OK\n");
 
 	/* Temporarily set chip->pipe_alloc_mask=0 otherwise
 	 * restore_dsp_settings() fails.
@@ -2253,7 +2260,7 @@ static int snd_echo_resume(struct device *dev)
 		kfree(commpage_bak);
 		return err;
 	}
-	DE_INIT(("resume restore OK\n"));
+	dev_dbg(dev, "resume restore OK\n");
 
 	memcpy(&commpage->audio_format, &commpage_bak->audio_format,
 		sizeof(commpage->audio_format));
@@ -2270,7 +2277,7 @@ static int snd_echo_resume(struct device *dev)
 		return -EBUSY;
 	}
 	chip->irq = pci->irq;
-	DE_INIT(("resume irq=%d\n", chip->irq));
+	dev_dbg(dev, "resume irq=%d\n", chip->irq);
 
 #ifdef ECHOCARD_HAS_MIDI
 	if (chip->midi_input_enabled)
@@ -2279,7 +2286,7 @@ static int snd_echo_resume(struct device *dev)
 		snd_echo_midi_output_trigger(chip->midi_out, 1);
 #endif
 
-	DE_INIT(("resume done\n"));
+	dev_dbg(dev, "resume done\n");
 	return 0;
 }
 
diff --git a/sound/pci/echoaudio/echoaudio.h b/sound/pci/echoaudio/echoaudio.h
index a4f112a..3251522 100644
--- a/sound/pci/echoaudio/echoaudio.h
+++ b/sound/pci/echoaudio/echoaudio.h
@@ -295,34 +295,6 @@
 #define PIPE_STATE_PENDING	3	/* Pipe has pending start */
 
 
-/* Debug initialization */
-#ifdef CONFIG_SND_DEBUG
-#define DE_INIT(x) snd_printk x
-#else
-#define DE_INIT(x)
-#endif
-
-/* Debug hw_params callbacks */
-#ifdef CONFIG_SND_DEBUG
-#define DE_HWP(x) snd_printk x
-#else
-#define DE_HWP(x)
-#endif
-
-/* Debug normal activity (open, start, stop...) */
-#ifdef CONFIG_SND_DEBUG
-#define DE_ACT(x) snd_printk x
-#else
-#define DE_ACT(x)
-#endif
-
-/* Debug midi activity */
-#ifdef CONFIG_SND_DEBUG
-#define DE_MID(x) snd_printk x
-#else
-#define DE_MID(x)
-#endif
-
 
 struct audiopipe {
 	volatile u32 *dma_counter;	/* Commpage register that contains
diff --git a/sound/pci/echoaudio/echoaudio_3g.c b/sound/pci/echoaudio/echoaudio_3g.c
index 658db44..50a2169 100644
--- a/sound/pci/echoaudio/echoaudio_3g.c
+++ b/sound/pci/echoaudio/echoaudio_3g.c
@@ -51,7 +51,7 @@ static int check_asic_status(struct echoaudio *chip)
 	}
 
 	box_status = le32_to_cpu(chip->comm_page->ext_box_status);
-	DE_INIT(("box_status=%x\n", box_status));
+	dev_dbg(chip->card->dev, "box_status=%x\n", box_status);
 	if (box_status == E3G_ASIC_NOT_LOADED)
 		return -ENODEV;
 
@@ -76,7 +76,8 @@ static int write_control_reg(struct echoaudio *chip, u32 ctl, u32 frq,
 	if (wait_handshake(chip))
 		return -EIO;
 
-	DE_ACT(("WriteControlReg: Setting 0x%x, 0x%x\n", ctl, frq));
+	dev_dbg(chip->card->dev,
+		"WriteControlReg: Setting 0x%x, 0x%x\n", ctl, frq);
 
 	ctl = cpu_to_le32(ctl);
 	frq = cpu_to_le32(frq);
@@ -89,7 +90,7 @@ static int write_control_reg(struct echoaudio *chip, u32 ctl, u32 frq,
 		return send_vector(chip, DSP_VC_WRITE_CONTROL_REG);
 	}
 
-	DE_ACT(("WriteControlReg: not written, no change\n"));
+	dev_dbg(chip->card->dev, "WriteControlReg: not written, no change\n");
 	return 0;
 }
 
@@ -258,8 +259,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	/* Only set the clock for internal mode. */
 	if (chip->input_clock != ECHO_CLOCK_INTERNAL) {
-		DE_ACT(("set_sample_rate: Cannot set sample rate - "
-			"clock not set to CLK_CLOCKININTERNAL\n"));
+		dev_warn(chip->card->dev,
+			 "Cannot set sample rate - clock not set to CLK_CLOCKININTERNAL\n");
 		/* Save the rate anyhow */
 		chip->comm_page->sample_rate = cpu_to_le32(rate);
 		chip->sample_rate = rate;
@@ -313,7 +314,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	chip->comm_page->sample_rate = cpu_to_le32(rate);	/* ignored by the DSP */
 	chip->sample_rate = rate;
-	DE_ACT(("SetSampleRate: %d clock %x\n", rate, control_reg));
+	dev_dbg(chip->card->dev,
+		"SetSampleRate: %d clock %x\n", rate, control_reg);
 
 	/* Tell the DSP about it - DSP reads both control reg & freq reg */
 	return write_control_reg(chip, control_reg, frq_reg, 0);
@@ -326,7 +328,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 {
 	u32 control_reg, clocks_from_dsp;
 
-	DE_ACT(("set_input_clock:\n"));
+	dev_dbg(chip->card->dev, "set_input_clock:\n");
 
 	/* Mask off the clock select bits */
 	control_reg = le32_to_cpu(chip->comm_page->control_register) &
@@ -335,13 +337,13 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
-		DE_ACT(("Set Echo3G clock to INTERNAL\n"));
+		dev_dbg(chip->card->dev, "Set Echo3G clock to INTERNAL\n");
 		chip->input_clock = ECHO_CLOCK_INTERNAL;
 		return set_sample_rate(chip, chip->sample_rate);
 	case ECHO_CLOCK_SPDIF:
 		if (chip->digital_mode == DIGITAL_MODE_ADAT)
 			return -EAGAIN;
-		DE_ACT(("Set Echo3G clock to SPDIF\n"));
+		dev_dbg(chip->card->dev, "Set Echo3G clock to SPDIF\n");
 		control_reg |= E3G_SPDIF_CLOCK;
 		if (clocks_from_dsp & E3G_CLOCK_DETECT_BIT_SPDIF96)
 			control_reg |= E3G_DOUBLE_SPEED_MODE;
@@ -351,12 +353,12 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 	case ECHO_CLOCK_ADAT:
 		if (chip->digital_mode != DIGITAL_MODE_ADAT)
 			return -EAGAIN;
-		DE_ACT(("Set Echo3G clock to ADAT\n"));
+		dev_dbg(chip->card->dev, "Set Echo3G clock to ADAT\n");
 		control_reg |= E3G_ADAT_CLOCK;
 		control_reg &= ~E3G_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_WORD:
-		DE_ACT(("Set Echo3G clock to WORD\n"));
+		dev_dbg(chip->card->dev, "Set Echo3G clock to WORD\n");
 		control_reg |= E3G_WORD_CLOCK;
 		if (clocks_from_dsp & E3G_CLOCK_DETECT_BIT_WORD96)
 			control_reg |= E3G_DOUBLE_SPEED_MODE;
@@ -364,7 +366,8 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 			control_reg &= ~E3G_DOUBLE_SPEED_MODE;
 		break;
 	default:
-		DE_ACT(("Input clock 0x%x not supported for Echo3G\n", clock));
+		dev_err(chip->card->dev,
+			"Input clock 0x%x not supported for Echo3G\n", clock);
 		return -EINVAL;
 	}
 
@@ -392,7 +395,8 @@ static int dsp_set_digital_mode(struct echoaudio *chip, u8 mode)
 			incompatible_clock = TRUE;
 		break;
 	default:
-		DE_ACT(("Digital mode not supported: %d\n", mode));
+		dev_err(chip->card->dev,
+			"Digital mode not supported: %d\n", mode);
 		return -EINVAL;
 	}
 
@@ -427,6 +431,6 @@ static int dsp_set_digital_mode(struct echoaudio *chip, u8 mode)
 		return err;
 	chip->digital_mode = mode;
 
-	DE_ACT(("set_digital_mode(%d)\n", chip->digital_mode));
+	dev_dbg(chip->card->dev, "set_digital_mode(%d)\n", chip->digital_mode);
 	return incompatible_clock;
 }
diff --git a/sound/pci/echoaudio/echoaudio_dsp.c b/sound/pci/echoaudio/echoaudio_dsp.c
index 977b2bd..c3763d4 100644
--- a/sound/pci/echoaudio/echoaudio_dsp.c
+++ b/sound/pci/echoaudio/echoaudio_dsp.c
@@ -80,7 +80,7 @@ static int send_vector(struct echoaudio *chip, u32 command)
 		udelay(1);
 	}
 
-	DE_ACT((KERN_ERR "timeout on send_vector\n"));
+	dev_err(chip->card->dev, "timeout on send_vector\n");
 	return -EBUSY;
 }
 
@@ -104,7 +104,7 @@ static int write_dsp(struct echoaudio *chip, u32 data)
 	}
 
 	chip->bad_board = TRUE;		/* Set TRUE until DSP re-loaded */
-	DE_ACT((KERN_ERR "write_dsp: Set bad_board to TRUE\n"));
+	dev_dbg(chip->card->dev, "write_dsp: Set bad_board to TRUE\n");
 	return -EIO;
 }
 
@@ -127,7 +127,7 @@ static int read_dsp(struct echoaudio *chip, u32 *data)
 	}
 
 	chip->bad_board = TRUE;		/* Set TRUE until DSP re-loaded */
-	DE_INIT((KERN_ERR "read_dsp: Set bad_board to TRUE\n"));
+	dev_err(chip->card->dev, "read_dsp: Set bad_board to TRUE\n");
 	return -EIO;
 }
 
@@ -154,8 +154,9 @@ static int read_sn(struct echoaudio *chip)
 			return -EIO;
 		}
 	}
-	DE_INIT(("Read serial number %08x %08x %08x %08x %08x\n",
-		 sn[0], sn[1], sn[2], sn[3], sn[4]));
+	dev_dbg(chip->card->dev,
+		"Read serial number %08x %08x %08x %08x %08x\n",
+		 sn[0], sn[1], sn[2], sn[3], sn[4]);
 	return 0;
 }
 
@@ -205,12 +206,12 @@ static int load_asic_generic(struct echoaudio *chip, u32 cmd, short asic)
 			goto la_error;
 	}
 
-	DE_INIT(("ASIC loaded\n"));
+	dev_dbg(chip->card->dev, "ASIC loaded\n");
 	free_firmware(fw, chip);
 	return 0;
 
 la_error:
-	DE_INIT(("failed on write_dsp\n"));
+	dev_err(chip->card->dev, "failed on write_dsp\n");
 	free_firmware(fw, chip);
 	return -EIO;
 }
@@ -241,8 +242,9 @@ static int install_resident_loader(struct echoaudio *chip)
 	loader is already installed, host flag 5 will be on. */
 	status = get_dsp_register(chip, CHI32_STATUS_REG);
 	if (status & CHI32_STATUS_REG_HF5) {
-		DE_INIT(("Resident loader already installed; status is 0x%x\n",
-			 status));
+		dev_dbg(chip->card->dev,
+			"Resident loader already installed; status is 0x%x\n",
+			 status);
 		return 0;
 	}
 
@@ -283,12 +285,14 @@ static int install_resident_loader(struct echoaudio *chip)
 
 	/* Write the count to the DSP */
 	if (write_dsp(chip, words)) {
-		DE_INIT(("install_resident_loader: Failed to write word count!\n"));
+		dev_err(chip->card->dev,
+			"install_resident_loader: Failed to write word count!\n");
 		goto irl_error;
 	}
 	/* Write the DSP address */
 	if (write_dsp(chip, address)) {
-		DE_INIT(("install_resident_loader: Failed to write DSP address!\n"));
+		dev_err(chip->card->dev,
+			"install_resident_loader: Failed to write DSP address!\n");
 		goto irl_error;
 	}
 	/* Write out this block of code to the DSP */
@@ -297,7 +301,8 @@ static int install_resident_loader(struct echoaudio *chip)
 
 		data = ((u32)code[index] << 16) + code[index + 1];
 		if (write_dsp(chip, data)) {
-			DE_INIT(("install_resident_loader: Failed to write DSP code\n"));
+			dev_err(chip->card->dev,
+				"install_resident_loader: Failed to write DSP code\n");
 			goto irl_error;
 		}
 		index += 2;
@@ -312,11 +317,11 @@ static int install_resident_loader(struct echoaudio *chip)
 	}
 
 	if (i == 200) {
-		DE_INIT(("Resident loader failed to set HF5\n"));
+		dev_err(chip->card->dev, "Resident loader failed to set HF5\n");
 		goto irl_error;
 	}
 
-	DE_INIT(("Resident loader successfully installed\n"));
+	dev_dbg(chip->card->dev, "Resident loader successfully installed\n");
 	free_firmware(fw, chip);
 	return 0;
 
@@ -334,14 +339,14 @@ static int load_dsp(struct echoaudio *chip, u16 *code)
 	int index, words, i;
 
 	if (chip->dsp_code == code) {
-		DE_INIT(("DSP is already loaded!\n"));
+		dev_warn(chip->card->dev, "DSP is already loaded!\n");
 		return 0;
 	}
 	chip->bad_board = TRUE;		/* Set TRUE until DSP loaded */
 	chip->dsp_code = NULL;		/* Current DSP code not loaded */
 	chip->asic_loaded = FALSE;	/* Loading the DSP code will reset the ASIC */
 
-	DE_INIT(("load_dsp: Set bad_board to TRUE\n"));
+	dev_dbg(chip->card->dev, "load_dsp: Set bad_board to TRUE\n");
 
 	/* If this board requires a resident loader, install it. */
 #ifdef DSP_56361
@@ -351,7 +356,8 @@ static int load_dsp(struct echoaudio *chip, u16 *code)
 
 	/* Send software reset command */
 	if (send_vector(chip, DSP_VC_RESET) < 0) {
-		DE_INIT(("LoadDsp: send_vector DSP_VC_RESET failed, Critical Failure\n"));
+		dev_err(chip->card->dev,
+			"LoadDsp: send_vector DSP_VC_RESET failed, Critical Failure\n");
 		return -EIO;
 	}
 	/* Delay 10us */
@@ -366,7 +372,8 @@ static int load_dsp(struct echoaudio *chip, u16 *code)
 	}
 
 	if (i == 1000) {
-		DE_INIT(("load_dsp: Timeout waiting for CHI32_STATUS_REG_HF3\n"));
+		dev_err(chip->card->dev,
+			"load_dsp: Timeout waiting for CHI32_STATUS_REG_HF3\n");
 		return -EIO;
 	}
 
@@ -403,29 +410,34 @@ static int load_dsp(struct echoaudio *chip, u16 *code)
 		index += 2;
 
 		if (write_dsp(chip, words) < 0) {
-			DE_INIT(("load_dsp: failed to write number of DSP words\n"));
+			dev_err(chip->card->dev,
+				"load_dsp: failed to write number of DSP words\n");
 			return -EIO;
 		}
 		if (write_dsp(chip, address) < 0) {
-			DE_INIT(("load_dsp: failed to write DSP address\n"));
+			dev_err(chip->card->dev,
+				"load_dsp: failed to write DSP address\n");
 			return -EIO;
 		}
 		if (write_dsp(chip, mem_type) < 0) {
-			DE_INIT(("load_dsp: failed to write DSP memory type\n"));
+			dev_err(chip->card->dev,
+				"load_dsp: failed to write DSP memory type\n");
 			return -EIO;
 		}
 		/* Code */
 		for (i = 0; i < words; i++, index+=2) {
 			data = ((u32)code[index] << 16) + code[index + 1];
 			if (write_dsp(chip, data) < 0) {
-				DE_INIT(("load_dsp: failed to write DSP data\n"));
+				dev_err(chip->card->dev,
+					"load_dsp: failed to write DSP data\n");
 				return -EIO;
 			}
 		}
 	}
 
 	if (write_dsp(chip, 0) < 0) {	/* We're done!!! */
-		DE_INIT(("load_dsp: Failed to write final zero\n"));
+		dev_err(chip->card->dev,
+			"load_dsp: Failed to write final zero\n");
 		return -EIO;
 	}
 	udelay(10);
@@ -438,12 +450,14 @@ static int load_dsp(struct echoaudio *chip, u16 *code)
 					 get_dsp_register(chip, CHI32_CONTROL_REG) & ~0x1b00);
 
 			if (write_dsp(chip, DSP_FNC_SET_COMMPAGE_ADDR) < 0) {
-				DE_INIT(("load_dsp: Failed to write DSP_FNC_SET_COMMPAGE_ADDR\n"));
+				dev_err(chip->card->dev,
+					"load_dsp: Failed to write DSP_FNC_SET_COMMPAGE_ADDR\n");
 				return -EIO;
 			}
 
 			if (write_dsp(chip, chip->comm_page_phys) < 0) {
-				DE_INIT(("load_dsp: Failed to write comm page address\n"));
+				dev_err(chip->card->dev,
+					"load_dsp: Failed to write comm page address\n");
 				return -EIO;
 			}
 
@@ -452,19 +466,21 @@ static int load_dsp(struct echoaudio *chip, u16 *code)
 			We don't actually use the serial number but we have to
 			get it as part of the DSP init voodoo. */
 			if (read_sn(chip) < 0) {
-				DE_INIT(("load_dsp: Failed to read serial number\n"));
+				dev_err(chip->card->dev,
+					"load_dsp: Failed to read serial number\n");
 				return -EIO;
 			}
 
 			chip->dsp_code = code;		/* Show which DSP code loaded */
 			chip->bad_board = FALSE;	/* DSP OK */
-			DE_INIT(("load_dsp: OK!\n"));
+			dev_dbg(chip->card->dev, "load_dsp: OK!\n");
 			return 0;
 		}
 		udelay(100);
 	}
 
-	DE_INIT(("load_dsp: DSP load timed out waiting for HF4\n"));
+	dev_err(chip->card->dev,
+		"load_dsp: DSP load timed out waiting for HF4\n");
 	return -EIO;
 }
 
@@ -658,7 +674,7 @@ static void get_audio_meters(struct echoaudio *chip, long *meters)
 static int restore_dsp_rettings(struct echoaudio *chip)
 {
 	int i, o, err;
-	DE_INIT(("restore_dsp_settings\n"));
+	dev_dbg(chip->card->dev, "restore_dsp_settings\n");
 
 	if ((err = check_asic_status(chip)) < 0)
 		return err;
@@ -755,7 +771,7 @@ static int restore_dsp_rettings(struct echoaudio *chip)
 	if (send_vector(chip, DSP_VC_UPDATE_FLAGS) < 0)
 		return -EIO;
 
-	DE_INIT(("restore_dsp_rettings done\n"));
+	dev_dbg(chip->card->dev, "restore_dsp_rettings done\n");
 	return 0;
 }
 
@@ -835,7 +851,8 @@ static void set_audio_format(struct echoaudio *chip, u16 pipe_index,
 			break;
 		}
 	}
-	DE_ACT(("set_audio_format[%d] = %x\n", pipe_index, dsp_format));
+	dev_dbg(chip->card->dev,
+		 "set_audio_format[%d] = %x\n", pipe_index, dsp_format);
 	chip->comm_page->audio_format[pipe_index] = cpu_to_le16(dsp_format);
 }
 
@@ -848,7 +865,7 @@ Same thing for pause_ and stop_ -trasport below. */
 static int start_transport(struct echoaudio *chip, u32 channel_mask,
 			   u32 cyclic_mask)
 {
-	DE_ACT(("start_transport %x\n", channel_mask));
+	dev_dbg(chip->card->dev, "start_transport %x\n", channel_mask);
 
 	if (wait_handshake(chip))
 		return -EIO;
@@ -866,7 +883,7 @@ static int start_transport(struct echoaudio *chip, u32 channel_mask,
 		return 0;
 	}
 
-	DE_ACT(("start_transport: No pipes to start!\n"));
+	dev_err(chip->card->dev, "start_transport: No pipes to start!\n");
 	return -EINVAL;
 }
 
@@ -874,7 +891,7 @@ static int start_transport(struct echoaudio *chip, u32 channel_mask,
 
 static int pause_transport(struct echoaudio *chip, u32 channel_mask)
 {
-	DE_ACT(("pause_transport %x\n", channel_mask));
+	dev_dbg(chip->card->dev, "pause_transport %x\n", channel_mask);
 
 	if (wait_handshake(chip))
 		return -EIO;
@@ -893,7 +910,7 @@ static int pause_transport(struct echoaudio *chip, u32 channel_mask)
 		return 0;
 	}
 
-	DE_ACT(("pause_transport: No pipes to stop!\n"));
+	dev_warn(chip->card->dev, "pause_transport: No pipes to stop!\n");
 	return 0;
 }
 
@@ -901,7 +918,7 @@ static int pause_transport(struct echoaudio *chip, u32 channel_mask)
 
 static int stop_transport(struct echoaudio *chip, u32 channel_mask)
 {
-	DE_ACT(("stop_transport %x\n", channel_mask));
+	dev_dbg(chip->card->dev, "stop_transport %x\n", channel_mask);
 
 	if (wait_handshake(chip))
 		return -EIO;
@@ -920,7 +937,7 @@ static int stop_transport(struct echoaudio *chip, u32 channel_mask)
 		return 0;
 	}
 
-	DE_ACT(("stop_transport: No pipes to stop!\n"));
+	dev_warn(chip->card->dev, "stop_transport: No pipes to stop!\n");
 	return 0;
 }
 
@@ -937,7 +954,8 @@ static inline int is_pipe_allocated(struct echoaudio *chip, u16 pipe_index)
 stopped and unallocated. */
 static int rest_in_peace(struct echoaudio *chip)
 {
-	DE_ACT(("rest_in_peace() open=%x\n", chip->pipe_alloc_mask));
+	dev_dbg(chip->card->dev,
+		"rest_in_peace() open=%x\n", chip->pipe_alloc_mask);
 
 	/* Stops all active pipes (just to be sure) */
 	stop_transport(chip, chip->active_mask);
@@ -965,7 +983,8 @@ static int init_dsp_comm_page(struct echoaudio *chip)
 {
 	/* Check if the compiler added extra padding inside the structure */
 	if (offsetof(struct comm_page, midi_output) != 0xbe0) {
-		DE_INIT(("init_dsp_comm_page() - Invalid struct comm_page structure\n"));
+		dev_err(chip->card->dev,
+			"init_dsp_comm_page() - Invalid struct comm_page structure\n");
 		return -EPERM;
 	}
 
@@ -999,7 +1018,7 @@ static int init_dsp_comm_page(struct echoaudio *chip)
  */
 static int init_line_levels(struct echoaudio *chip)
 {
-	DE_INIT(("init_line_levels\n"));
+	dev_dbg(chip->card->dev, "init_line_levels\n");
 	memset(chip->output_gain, ECHOGAIN_MUTED, sizeof(chip->output_gain));
 	memset(chip->input_gain, ECHOGAIN_MUTED, sizeof(chip->input_gain));
 	memset(chip->monitor_gain, ECHOGAIN_MUTED, sizeof(chip->monitor_gain));
@@ -1051,7 +1070,8 @@ static int allocate_pipes(struct echoaudio *chip, struct audiopipe *pipe,
 	u32 channel_mask;
 	char is_cyclic;
 
-	DE_ACT(("allocate_pipes: ch=%d int=%d\n", pipe_index, interleave));
+	dev_dbg(chip->card->dev,
+		"allocate_pipes: ch=%d int=%d\n", pipe_index, interleave);
 
 	if (chip->bad_board)
 		return -EIO;
@@ -1061,7 +1081,8 @@ static int allocate_pipes(struct echoaudio *chip, struct audiopipe *pipe,
 	for (channel_mask = i = 0; i < interleave; i++)
 		channel_mask |= 1 << (pipe_index + i);
 	if (chip->pipe_alloc_mask & channel_mask) {
-		DE_ACT(("allocate_pipes: channel already open\n"));
+		dev_err(chip->card->dev,
+			"allocate_pipes: channel already open\n");
 		return -EAGAIN;
 	}
 
@@ -1078,7 +1099,7 @@ static int allocate_pipes(struct echoaudio *chip, struct audiopipe *pipe,
 	it moves data. The DMA counter is in units of bytes, not samples. */
 	pipe->dma_counter = &chip->comm_page->position[pipe_index];
 	*pipe->dma_counter = 0;
-	DE_ACT(("allocate_pipes: ok\n"));
+	dev_dbg(chip->card->dev, "allocate_pipes: ok\n");
 	return pipe_index;
 }
 
@@ -1089,7 +1110,7 @@ static int free_pipes(struct echoaudio *chip, struct audiopipe *pipe)
 	u32 channel_mask;
 	int i;
 
-	DE_ACT(("free_pipes: Pipe %d\n", pipe->index));
+	dev_dbg(chip->card->dev, "free_pipes: Pipe %d\n", pipe->index);
 	if (snd_BUG_ON(!is_pipe_allocated(chip, pipe->index)))
 		return -EINVAL;
 	if (snd_BUG_ON(pipe->state != PIPE_STATE_STOPPED))
@@ -1131,7 +1152,7 @@ static int sglist_add_mapping(struct echoaudio *chip, struct audiopipe *pipe,
 		list[head].size = cpu_to_le32(length);
 		pipe->sglist_head++;
 	} else {
-		DE_ACT(("SGlist: too many fragments\n"));
+		dev_err(chip->card->dev, "SGlist: too many fragments\n");
 		return -ENOMEM;
 	}
 	return 0;
diff --git a/sound/pci/echoaudio/echoaudio_gml.c b/sound/pci/echoaudio/echoaudio_gml.c
index afa2733..64836fc 100644
--- a/sound/pci/echoaudio/echoaudio_gml.c
+++ b/sound/pci/echoaudio/echoaudio_gml.c
@@ -46,7 +46,8 @@ static int check_asic_status(struct echoaudio *chip)
 	/* The DSP will return a value to indicate whether or not the
 	   ASIC is currently loaded */
 	if (read_dsp(chip, &asic_status) < 0) {
-		DE_INIT(("check_asic_status: failed on read_dsp\n"));
+		dev_err(chip->card->dev,
+			"check_asic_status: failed on read_dsp\n");
 		chip->asic_loaded = FALSE;
 		return -EIO;
 	}
@@ -68,7 +69,7 @@ static int write_control_reg(struct echoaudio *chip, u32 value, char force)
 	else
 		value &= ~GML_DIGITAL_IN_AUTO_MUTE;
 
-	DE_ACT(("write_control_reg: 0x%x\n", value));
+	dev_dbg(chip->card->dev, "write_control_reg: 0x%x\n", value);
 
 	/* Write the control register */
 	value = cpu_to_le32(value);
@@ -91,7 +92,7 @@ If the auto-mute is disabled, the digital inputs are enabled regardless of
 what the input clock is set or what is connected. */
 static int set_input_auto_mute(struct echoaudio *chip, int automute)
 {
-	DE_ACT(("set_input_auto_mute %d\n", automute));
+	dev_dbg(chip->card->dev, "set_input_auto_mute %d\n", automute);
 
 	chip->digital_in_automute = automute;
 
@@ -194,7 +195,7 @@ static int set_professional_spdif(struct echoaudio *chip, char prof)
 	if ((err = write_control_reg(chip, control_reg, FALSE)))
 		return err;
 	chip->professional_spdif = prof;
-	DE_ACT(("set_professional_spdif to %s\n",
-		prof ? "Professional" : "Consumer"));
+	dev_dbg(chip->card->dev, "set_professional_spdif to %s\n",
+		prof ? "Professional" : "Consumer");
 	return 0;
 }
diff --git a/sound/pci/echoaudio/gina20_dsp.c b/sound/pci/echoaudio/gina20_dsp.c
index d1615a0..a959eae 100644
--- a/sound/pci/echoaudio/gina20_dsp.c
+++ b/sound/pci/echoaudio/gina20_dsp.c
@@ -37,12 +37,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Gina20\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Gina20\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != GINA20))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -62,7 +63,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -149,7 +150,7 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 static int set_input_clock(struct echoaudio *chip, u16 clock)
 {
-	DE_ACT(("set_input_clock:\n"));
+	dev_dbg(chip->card->dev, "set_input_clock:\n");
 
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
@@ -158,7 +159,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 		chip->spdif_status = GD_SPDIF_STATUS_UNDEF;
 		set_sample_rate(chip, chip->sample_rate);
 		chip->input_clock = clock;
-		DE_ACT(("Set Gina clock to INTERNAL\n"));
+		dev_dbg(chip->card->dev, "Set Gina clock to INTERNAL\n");
 		break;
 	case ECHO_CLOCK_SPDIF:
 		chip->comm_page->gd_clock_state = GD_CLOCK_SPDIFIN;
@@ -166,7 +167,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 		clear_handshake(chip);
 		send_vector(chip, DSP_VC_SET_GD_AUDIO_STATE);
 		chip->clock_state = GD_CLOCK_SPDIFIN;
-		DE_ACT(("Set Gina20 clock to SPDIF\n"));
+		dev_dbg(chip->card->dev, "Set Gina20 clock to SPDIF\n");
 		chip->input_clock = clock;
 		break;
 	default:
@@ -208,7 +209,7 @@ static int update_flags(struct echoaudio *chip)
 
 static int set_professional_spdif(struct echoaudio *chip, char prof)
 {
-	DE_ACT(("set_professional_spdif %d\n", prof));
+	dev_dbg(chip->card->dev, "set_professional_spdif %d\n", prof);
 	if (prof)
 		chip->comm_page->flags |=
 			cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
diff --git a/sound/pci/echoaudio/gina24_dsp.c b/sound/pci/echoaudio/gina24_dsp.c
index 98f7cfa..c8ea576 100644
--- a/sound/pci/echoaudio/gina24_dsp.c
+++ b/sound/pci/echoaudio/gina24_dsp.c
@@ -41,12 +41,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Gina24\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Gina24\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != GINA24))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -78,7 +79,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -155,7 +156,7 @@ static int load_asic(struct echoaudio *chip)
 		control_reg = GML_CONVERTER_ENABLE | GML_48KHZ;
 		err = write_control_reg(chip, control_reg, TRUE);
 	}
-	DE_INIT(("load_asic() done\n"));
+	dev_dbg(chip->card->dev, "load_asic() done\n");
 	return err;
 }
 
@@ -171,8 +172,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	/* Only set the clock for internal mode. */
 	if (chip->input_clock != ECHO_CLOCK_INTERNAL) {
-		DE_ACT(("set_sample_rate: Cannot set sample rate - "
-			"clock not set to CLK_CLOCKININTERNAL\n"));
+		dev_warn(chip->card->dev,
+			 "Cannot set sample rate - clock not set to CLK_CLOCKININTERNAL\n");
 		/* Save the rate anyhow */
 		chip->comm_page->sample_rate = cpu_to_le32(rate);
 		chip->sample_rate = rate;
@@ -217,7 +218,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 		clock = GML_8KHZ;
 		break;
 	default:
-		DE_ACT(("set_sample_rate: %d invalid!\n", rate));
+		dev_err(chip->card->dev,
+			"set_sample_rate: %d invalid!\n", rate);
 		return -EINVAL;
 	}
 
@@ -225,7 +227,7 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	chip->comm_page->sample_rate = cpu_to_le32(rate);	/* ignored by the DSP */
 	chip->sample_rate = rate;
-	DE_ACT(("set_sample_rate: %d clock %d\n", rate, clock));
+	dev_dbg(chip->card->dev, "set_sample_rate: %d clock %d\n", rate, clock);
 
 	return write_control_reg(chip, control_reg, FALSE);
 }
@@ -236,7 +238,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 {
 	u32 control_reg, clocks_from_dsp;
 
-	DE_ACT(("set_input_clock:\n"));
+	dev_dbg(chip->card->dev, "set_input_clock:\n");
 
 	/* Mask off the clock select bits */
 	control_reg = le32_to_cpu(chip->comm_page->control_register) &
@@ -245,13 +247,13 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
-		DE_ACT(("Set Gina24 clock to INTERNAL\n"));
+		dev_dbg(chip->card->dev, "Set Gina24 clock to INTERNAL\n");
 		chip->input_clock = ECHO_CLOCK_INTERNAL;
 		return set_sample_rate(chip, chip->sample_rate);
 	case ECHO_CLOCK_SPDIF:
 		if (chip->digital_mode == DIGITAL_MODE_ADAT)
 			return -EAGAIN;
-		DE_ACT(("Set Gina24 clock to SPDIF\n"));
+		dev_dbg(chip->card->dev, "Set Gina24 clock to SPDIF\n");
 		control_reg |= GML_SPDIF_CLOCK;
 		if (clocks_from_dsp & GML_CLOCK_DETECT_BIT_SPDIF96)
 			control_reg |= GML_DOUBLE_SPEED_MODE;
@@ -261,21 +263,22 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 	case ECHO_CLOCK_ADAT:
 		if (chip->digital_mode != DIGITAL_MODE_ADAT)
 			return -EAGAIN;
-		DE_ACT(("Set Gina24 clock to ADAT\n"));
+		dev_dbg(chip->card->dev, "Set Gina24 clock to ADAT\n");
 		control_reg |= GML_ADAT_CLOCK;
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_ESYNC:
-		DE_ACT(("Set Gina24 clock to ESYNC\n"));
+		dev_dbg(chip->card->dev, "Set Gina24 clock to ESYNC\n");
 		control_reg |= GML_ESYNC_CLOCK;
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_ESYNC96:
-		DE_ACT(("Set Gina24 clock to ESYNC96\n"));
+		dev_dbg(chip->card->dev, "Set Gina24 clock to ESYNC96\n");
 		control_reg |= GML_ESYNC_CLOCK | GML_DOUBLE_SPEED_MODE;
 		break;
 	default:
-		DE_ACT(("Input clock 0x%x not supported for Gina24\n", clock));
+		dev_err(chip->card->dev,
+			"Input clock 0x%x not supported for Gina24\n", clock);
 		return -EINVAL;
 	}
 
@@ -304,7 +307,8 @@ static int dsp_set_digital_mode(struct echoaudio *chip, u8 mode)
 			incompatible_clock = TRUE;
 		break;
 	default:
-		DE_ACT(("Digital mode not supported: %d\n", mode));
+		dev_err(chip->card->dev,
+			"Digital mode not supported: %d\n", mode);
 		return -EINVAL;
 	}
 
@@ -344,6 +348,7 @@ static int dsp_set_digital_mode(struct echoaudio *chip, u8 mode)
 		return err;
 	chip->digital_mode = mode;
 
-	DE_ACT(("set_digital_mode to %d\n", chip->digital_mode));
+	dev_dbg(chip->card->dev,
+		"set_digital_mode to %d\n", chip->digital_mode);
 	return incompatible_clock;
 }
diff --git a/sound/pci/echoaudio/indigo_dsp.c b/sound/pci/echoaudio/indigo_dsp.c
index 5e85f14..b73167b 100644
--- a/sound/pci/echoaudio/indigo_dsp.c
+++ b/sound/pci/echoaudio/indigo_dsp.c
@@ -38,12 +38,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Indigo\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Indigo\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -60,7 +61,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -109,7 +110,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 		control_reg = MIA_32000;
 		break;
 	default:
-		DE_ACT(("set_sample_rate: %d invalid!\n", rate));
+		dev_err(chip->card->dev,
+			"set_sample_rate: %d invalid!\n", rate);
 		return -EINVAL;
 	}
 
@@ -147,7 +149,8 @@ static int set_vmixer_gain(struct echoaudio *chip, u16 output, u16 pipe,
 	index = output * num_pipes_out(chip) + pipe;
 	chip->comm_page->vmixer[index] = gain;
 
-	DE_ACT(("set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain));
+	dev_dbg(chip->card->dev,
+		"set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain);
 	return 0;
 }
 
diff --git a/sound/pci/echoaudio/indigo_express_dsp.c b/sound/pci/echoaudio/indigo_express_dsp.c
index 2e4ab3e..ceda2d7 100644
--- a/sound/pci/echoaudio/indigo_express_dsp.c
+++ b/sound/pci/echoaudio/indigo_express_dsp.c
@@ -61,7 +61,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	control_reg |= clock;
 	if (control_reg != old_control_reg) {
-		DE_ACT(("set_sample_rate: %d clock %d\n", rate, clock));
+		dev_dbg(chip->card->dev,
+			"set_sample_rate: %d clock %d\n", rate, clock);
 		chip->comm_page->control_register = cpu_to_le32(control_reg);
 		chip->sample_rate = rate;
 		clear_handshake(chip);
@@ -89,7 +90,8 @@ static int set_vmixer_gain(struct echoaudio *chip, u16 output, u16 pipe,
 	index = output * num_pipes_out(chip) + pipe;
 	chip->comm_page->vmixer[index] = gain;
 
-	DE_ACT(("set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain));
+	dev_dbg(chip->card->dev,
+		"set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain);
 	return 0;
 }
 
diff --git a/sound/pci/echoaudio/indigodj_dsp.c b/sound/pci/echoaudio/indigodj_dsp.c
index 68f3c8c..133915c 100644
--- a/sound/pci/echoaudio/indigodj_dsp.c
+++ b/sound/pci/echoaudio/indigodj_dsp.c
@@ -38,12 +38,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Indigo DJ\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Indigo DJ\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO_DJ))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -60,7 +61,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -109,7 +110,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 		control_reg = MIA_32000;
 		break;
 	default:
-		DE_ACT(("set_sample_rate: %d invalid!\n", rate));
+		dev_err(chip->card->dev,
+			"set_sample_rate: %d invalid!\n", rate);
 		return -EINVAL;
 	}
 
@@ -147,7 +149,8 @@ static int set_vmixer_gain(struct echoaudio *chip, u16 output, u16 pipe,
 	index = output * num_pipes_out(chip) + pipe;
 	chip->comm_page->vmixer[index] = gain;
 
-	DE_ACT(("set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain));
+	dev_dbg(chip->card->dev,
+		"set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain);
 	return 0;
 }
 
diff --git a/sound/pci/echoaudio/indigodjx_dsp.c b/sound/pci/echoaudio/indigodjx_dsp.c
index bb9632c..26cdfcf 100644
--- a/sound/pci/echoaudio/indigodjx_dsp.c
+++ b/sound/pci/echoaudio/indigodjx_dsp.c
@@ -35,13 +35,14 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Indigo DJx\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Indigo DJx\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO_DJX))
 		return -ENODEV;
 
 	err = init_dsp_comm_page(chip);
 	if (err < 0) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -59,7 +60,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/indigoio_dsp.c b/sound/pci/echoaudio/indigoio_dsp.c
index beb9a5b..5e6df7c 100644
--- a/sound/pci/echoaudio/indigoio_dsp.c
+++ b/sound/pci/echoaudio/indigoio_dsp.c
@@ -38,12 +38,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Indigo IO\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Indigo IO\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO_IO))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -60,7 +61,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -118,7 +119,8 @@ static int set_vmixer_gain(struct echoaudio *chip, u16 output, u16 pipe,
 	index = output * num_pipes_out(chip) + pipe;
 	chip->comm_page->vmixer[index] = gain;
 
-	DE_ACT(("set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain));
+	dev_dbg(chip->card->dev,
+		"set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain);
 	return 0;
 }
 
diff --git a/sound/pci/echoaudio/indigoiox_dsp.c b/sound/pci/echoaudio/indigoiox_dsp.c
index 394c6e76..90cdd27 100644
--- a/sound/pci/echoaudio/indigoiox_dsp.c
+++ b/sound/pci/echoaudio/indigoiox_dsp.c
@@ -35,13 +35,14 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Indigo IOx\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Indigo IOx\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO_IOX))
 		return -ENODEV;
 
 	err = init_dsp_comm_page(chip);
 	if (err < 0) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -59,7 +60,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/layla20_dsp.c b/sound/pci/echoaudio/layla20_dsp.c
index 53ce946..7f0f6ea 100644
--- a/sound/pci/echoaudio/layla20_dsp.c
+++ b/sound/pci/echoaudio/layla20_dsp.c
@@ -40,12 +40,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Layla20\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Layla20\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != LAYLA20))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -64,7 +65,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -121,7 +122,8 @@ static int check_asic_status(struct echoaudio *chip)
 		/* The DSP will return a value to indicate whether or not
 		   the ASIC is currently loaded */
 		if (read_dsp(chip, &asic_status) < 0) {
-			DE_ACT(("check_asic_status: failed on read_dsp\n"));
+			dev_err(chip->card->dev,
+				"check_asic_status: failed on read_dsp\n");
 			return -EIO;
 		}
 
@@ -164,8 +166,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 	/* Only set the clock for internal mode. Do not return failure,
 	   simply treat it as a non-event. */
 	if (chip->input_clock != ECHO_CLOCK_INTERNAL) {
-		DE_ACT(("set_sample_rate: Cannot set sample rate - "
-			"clock not set to CLK_CLOCKININTERNAL\n"));
+		dev_warn(chip->card->dev,
+			 "Cannot set sample rate - clock not set to CLK_CLOCKININTERNAL\n");
 		chip->comm_page->sample_rate = cpu_to_le32(rate);
 		chip->sample_rate = rate;
 		return 0;
@@ -174,7 +176,7 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 	if (wait_handshake(chip))
 		return -EIO;
 
-	DE_ACT(("set_sample_rate(%d)\n", rate));
+	dev_dbg(chip->card->dev, "set_sample_rate(%d)\n", rate);
 	chip->sample_rate = rate;
 	chip->comm_page->sample_rate = cpu_to_le32(rate);
 	clear_handshake(chip);
@@ -188,29 +190,30 @@ static int set_input_clock(struct echoaudio *chip, u16 clock_source)
 	u16 clock;
 	u32 rate;
 
-	DE_ACT(("set_input_clock:\n"));
+	dev_dbg(chip->card->dev, "set_input_clock:\n");
 	rate = 0;
 	switch (clock_source) {
 	case ECHO_CLOCK_INTERNAL:
-		DE_ACT(("Set Layla20 clock to INTERNAL\n"));
+		dev_dbg(chip->card->dev, "Set Layla20 clock to INTERNAL\n");
 		rate = chip->sample_rate;
 		clock = LAYLA20_CLOCK_INTERNAL;
 		break;
 	case ECHO_CLOCK_SPDIF:
-		DE_ACT(("Set Layla20 clock to SPDIF\n"));
+		dev_dbg(chip->card->dev, "Set Layla20 clock to SPDIF\n");
 		clock = LAYLA20_CLOCK_SPDIF;
 		break;
 	case ECHO_CLOCK_WORD:
-		DE_ACT(("Set Layla20 clock to WORD\n"));
+		dev_dbg(chip->card->dev, "Set Layla20 clock to WORD\n");
 		clock = LAYLA20_CLOCK_WORD;
 		break;
 	case ECHO_CLOCK_SUPER:
-		DE_ACT(("Set Layla20 clock to SUPER\n"));
+		dev_dbg(chip->card->dev, "Set Layla20 clock to SUPER\n");
 		clock = LAYLA20_CLOCK_SUPER;
 		break;
 	default:
-		DE_ACT(("Input clock 0x%x not supported for Layla24\n",
-			clock_source));
+		dev_err(chip->card->dev,
+			"Input clock 0x%x not supported for Layla24\n",
+			clock_source);
 		return -EINVAL;
 	}
 	chip->input_clock = clock_source;
@@ -229,7 +232,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock_source)
 
 static int set_output_clock(struct echoaudio *chip, u16 clock)
 {
-	DE_ACT(("set_output_clock: %d\n", clock));
+	dev_dbg(chip->card->dev, "set_output_clock: %d\n", clock);
 	switch (clock) {
 	case ECHO_CLOCK_SUPER:
 		clock = LAYLA20_OUTPUT_CLOCK_SUPER;
@@ -238,7 +241,7 @@ static int set_output_clock(struct echoaudio *chip, u16 clock)
 		clock = LAYLA20_OUTPUT_CLOCK_WORD;
 		break;
 	default:
-		DE_ACT(("set_output_clock wrong clock\n"));
+		dev_err(chip->card->dev, "set_output_clock wrong clock\n");
 		return -EINVAL;
 	}
 
@@ -283,7 +286,7 @@ static int update_flags(struct echoaudio *chip)
 
 static int set_professional_spdif(struct echoaudio *chip, char prof)
 {
-	DE_ACT(("set_professional_spdif %d\n", prof));
+	dev_dbg(chip->card->dev, "set_professional_spdif %d\n", prof);
 	if (prof)
 		chip->comm_page->flags |=
 			cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
diff --git a/sound/pci/echoaudio/layla24_dsp.c b/sound/pci/echoaudio/layla24_dsp.c
index 8c04164..f6691c8 100644
--- a/sound/pci/echoaudio/layla24_dsp.c
+++ b/sound/pci/echoaudio/layla24_dsp.c
@@ -40,12 +40,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Layla24\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Layla24\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != LAYLA24))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -69,7 +70,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 	if ((err = init_line_levels(chip)) < 0)
 		return err;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -117,7 +118,7 @@ static int load_asic(struct echoaudio *chip)
 	if (chip->asic_loaded)
 		return 1;
 
-	DE_INIT(("load_asic\n"));
+	dev_dbg(chip->card->dev, "load_asic\n");
 
 	/* Give the DSP a few milliseconds to settle down */
 	mdelay(10);
@@ -151,7 +152,7 @@ static int load_asic(struct echoaudio *chip)
 		err = write_control_reg(chip, GML_CONVERTER_ENABLE | GML_48KHZ,
 					TRUE);
 	
-	DE_INIT(("load_asic() done\n"));
+	dev_dbg(chip->card->dev, "load_asic() done\n");
 	return err;
 }
 
@@ -167,8 +168,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	/* Only set the clock for internal mode. */
 	if (chip->input_clock != ECHO_CLOCK_INTERNAL) {
-		DE_ACT(("set_sample_rate: Cannot set sample rate - "
-			"clock not set to CLK_CLOCKININTERNAL\n"));
+		dev_warn(chip->card->dev,
+			 "Cannot set sample rate - clock not set to CLK_CLOCKININTERNAL\n");
 		/* Save the rate anyhow */
 		chip->comm_page->sample_rate = cpu_to_le32(rate);
 		chip->sample_rate = rate;
@@ -241,7 +242,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	chip->comm_page->sample_rate = cpu_to_le32(rate);	/* ignored by the DSP ? */
 	chip->sample_rate = rate;
-	DE_ACT(("set_sample_rate: %d clock %d\n", rate, control_reg));
+	dev_dbg(chip->card->dev,
+		"set_sample_rate: %d clock %d\n", rate, control_reg);
 
 	return write_control_reg(chip, control_reg, FALSE);
 }
@@ -260,7 +262,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 	/* Pick the new clock */
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
-		DE_ACT(("Set Layla24 clock to INTERNAL\n"));
+		dev_dbg(chip->card->dev, "Set Layla24 clock to INTERNAL\n");
 		chip->input_clock = ECHO_CLOCK_INTERNAL;
 		return set_sample_rate(chip, chip->sample_rate);
 	case ECHO_CLOCK_SPDIF:
@@ -269,7 +271,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 		control_reg |= GML_SPDIF_CLOCK;
 		/* Layla24 doesn't support 96KHz S/PDIF */
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
-		DE_ACT(("Set Layla24 clock to SPDIF\n"));
+		dev_dbg(chip->card->dev, "Set Layla24 clock to SPDIF\n");
 		break;
 	case ECHO_CLOCK_WORD:
 		control_reg |= GML_WORD_CLOCK;
@@ -277,17 +279,18 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 			control_reg |= GML_DOUBLE_SPEED_MODE;
 		else
 			control_reg &= ~GML_DOUBLE_SPEED_MODE;
-		DE_ACT(("Set Layla24 clock to WORD\n"));
+		dev_dbg(chip->card->dev, "Set Layla24 clock to WORD\n");
 		break;
 	case ECHO_CLOCK_ADAT:
 		if (chip->digital_mode != DIGITAL_MODE_ADAT)
 			return -EAGAIN;
 		control_reg |= GML_ADAT_CLOCK;
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
-		DE_ACT(("Set Layla24 clock to ADAT\n"));
+		dev_dbg(chip->card->dev, "Set Layla24 clock to ADAT\n");
 		break;
 	default:
-		DE_ACT(("Input clock 0x%x not supported for Layla24\n", clock));
+		dev_err(chip->card->dev,
+			"Input clock 0x%x not supported for Layla24\n", clock);
 		return -EINVAL;
 	}
 
@@ -353,7 +356,8 @@ static int dsp_set_digital_mode(struct echoaudio *chip, u8 mode)
 		asic = FW_LAYLA24_2A_ASIC;
 		break;
 	default:
-		DE_ACT(("Digital mode not supported: %d\n", mode));
+		dev_err(chip->card->dev,
+			"Digital mode not supported: %d\n", mode);
 		return -EINVAL;
 	}
 
@@ -393,6 +397,6 @@ static int dsp_set_digital_mode(struct echoaudio *chip, u8 mode)
 		return err;
 	chip->digital_mode = mode;
 
-	DE_ACT(("set_digital_mode to %d\n", mode));
+	dev_dbg(chip->card->dev, "set_digital_mode to %d\n", mode);
 	return incompatible_clock;
 }
diff --git a/sound/pci/echoaudio/mia_dsp.c b/sound/pci/echoaudio/mia_dsp.c
index 6ebfa6e..8626a1c 100644
--- a/sound/pci/echoaudio/mia_dsp.c
+++ b/sound/pci/echoaudio/mia_dsp.c
@@ -41,12 +41,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Mia\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Mia\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != MIA))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -66,7 +67,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -126,7 +127,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 		control_reg = MIA_32000;
 		break;
 	default:
-		DE_ACT(("set_sample_rate: %d invalid!\n", rate));
+		dev_err(chip->card->dev,
+			"set_sample_rate: %d invalid!\n", rate);
 		return -EINVAL;
 	}
 
@@ -153,7 +155,7 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 static int set_input_clock(struct echoaudio *chip, u16 clock)
 {
-	DE_ACT(("set_input_clock(%d)\n", clock));
+	dev_dbg(chip->card->dev, "set_input_clock(%d)\n", clock);
 	if (snd_BUG_ON(clock != ECHO_CLOCK_INTERNAL &&
 		       clock != ECHO_CLOCK_SPDIF))
 		return -EINVAL;
@@ -181,7 +183,8 @@ static int set_vmixer_gain(struct echoaudio *chip, u16 output, u16 pipe,
 	index = output * num_pipes_out(chip) + pipe;
 	chip->comm_page->vmixer[index] = gain;
 
-	DE_ACT(("set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain));
+	dev_dbg(chip->card->dev,
+		"set_vmixer_gain: pipe %d, out %d = %d\n", pipe, output, gain);
 	return 0;
 }
 
@@ -211,7 +214,7 @@ static int update_flags(struct echoaudio *chip)
 
 static int set_professional_spdif(struct echoaudio *chip, char prof)
 {
-	DE_ACT(("set_professional_spdif %d\n", prof));
+	dev_dbg(chip->card->dev, "set_professional_spdif %d\n", prof);
 	if (prof)
 		chip->comm_page->flags |=
 			cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
diff --git a/sound/pci/echoaudio/midi.c b/sound/pci/echoaudio/midi.c
index 7f4dfae..8d43c5a 100644
--- a/sound/pci/echoaudio/midi.c
+++ b/sound/pci/echoaudio/midi.c
@@ -36,7 +36,7 @@
 /* Start and stop Midi input */
 static int enable_midi_input(struct echoaudio *chip, char enable)
 {
-	DE_MID(("enable_midi_input(%d)\n", enable));
+	dev_dbg(chip->card->dev, "enable_midi_input(%d)\n", enable);
 
 	if (wait_handshake(chip))
 		return -EIO;
@@ -74,7 +74,7 @@ static int write_midi(struct echoaudio *chip, u8 *data, int bytes)
 	chip->comm_page->midi_out_free_count = 0;
 	clear_handshake(chip);
 	send_vector(chip, DSP_VC_MIDI_WRITE);
-	DE_MID(("write_midi: %d\n", bytes));
+	dev_dbg(chip->card->dev, "write_midi: %d\n", bytes);
 	return bytes;
 }
 
@@ -157,7 +157,7 @@ static int snd_echo_midi_input_open(struct snd_rawmidi_substream *substream)
 	struct echoaudio *chip = substream->rmidi->private_data;
 
 	chip->midi_in = substream;
-	DE_MID(("rawmidi_iopen\n"));
+	dev_dbg(chip->card->dev, "rawmidi_iopen\n");
 	return 0;
 }
 
@@ -183,7 +183,7 @@ static int snd_echo_midi_input_close(struct snd_rawmidi_substream *substream)
 	struct echoaudio *chip = substream->rmidi->private_data;
 
 	chip->midi_in = NULL;
-	DE_MID(("rawmidi_iclose\n"));
+	dev_dbg(chip->card->dev, "rawmidi_iclose\n");
 	return 0;
 }
 
@@ -196,7 +196,7 @@ static int snd_echo_midi_output_open(struct snd_rawmidi_substream *substream)
 	chip->tinuse = 0;
 	chip->midi_full = 0;
 	chip->midi_out = substream;
-	DE_MID(("rawmidi_oopen\n"));
+	dev_dbg(chip->card->dev, "rawmidi_open\n");
 	return 0;
 }
 
@@ -209,7 +209,7 @@ static void snd_echo_midi_output_write(unsigned long data)
 	int bytes, sent, time;
 	unsigned char buf[MIDI_OUT_BUFFER_SIZE - 1];
 
-	DE_MID(("snd_echo_midi_output_write\n"));
+	dev_dbg(chip->card->dev, "snd_echo_midi_output_write\n");
 	/* No interrupts are involved: we have to check at regular intervals
 	if the card's output buffer has room for new data. */
 	sent = bytes = 0;
@@ -218,7 +218,7 @@ static void snd_echo_midi_output_write(unsigned long data)
 	if (!snd_rawmidi_transmit_empty(chip->midi_out)) {
 		bytes = snd_rawmidi_transmit_peek(chip->midi_out, buf,
 						  MIDI_OUT_BUFFER_SIZE - 1);
-		DE_MID(("Try to send %d bytes...\n", bytes));
+		dev_dbg(chip->card->dev, "Try to send %d bytes...\n", bytes);
 		sent = write_midi(chip, buf, bytes);
 		if (sent < 0) {
 			dev_err(chip->card->dev,
@@ -227,12 +227,12 @@ static void snd_echo_midi_output_write(unsigned long data)
 			sent = 9000;
 			chip->midi_full = 1;
 		} else if (sent > 0) {
-			DE_MID(("%d bytes sent\n", sent));
+			dev_dbg(chip->card->dev, "%d bytes sent\n", sent);
 			snd_rawmidi_transmit_ack(chip->midi_out, sent);
 		} else {
 			/* Buffer is full. DSP's internal buffer is 64 (128 ?)
 			bytes long. Let's wait until half of them are sent */
-			DE_MID(("Full\n"));
+			dev_dbg(chip->card->dev, "Full\n");
 			sent = 32;
 			chip->midi_full = 1;
 		}
@@ -244,7 +244,8 @@ static void snd_echo_midi_output_write(unsigned long data)
 		   sent */
 		time = (sent << 3) / 25 + 1;	/* 8/25=0.32ms to send a byte */
 		mod_timer(&chip->timer, jiffies + (time * HZ + 999) / 1000);
-		DE_MID(("Timer armed(%d)\n", ((time * HZ + 999) / 1000)));
+		dev_dbg(chip->card->dev,
+			"Timer armed(%d)\n", ((time * HZ + 999) / 1000));
 	}
 	spin_unlock_irqrestore(&chip->lock, flags);
 }
@@ -256,7 +257,7 @@ static void snd_echo_midi_output_trigger(struct snd_rawmidi_substream *substream
 {
 	struct echoaudio *chip = substream->rmidi->private_data;
 
-	DE_MID(("snd_echo_midi_output_trigger(%d)\n", up));
+	dev_dbg(chip->card->dev, "snd_echo_midi_output_trigger(%d)\n", up);
 	spin_lock_irq(&chip->lock);
 	if (up) {
 		if (!chip->tinuse) {
@@ -270,7 +271,7 @@ static void snd_echo_midi_output_trigger(struct snd_rawmidi_substream *substream
 			chip->tinuse = 0;
 			spin_unlock_irq(&chip->lock);
 			del_timer_sync(&chip->timer);
-			DE_MID(("Timer removed\n"));
+			dev_dbg(chip->card->dev, "Timer removed\n");
 			return;
 		}
 	}
@@ -287,7 +288,7 @@ static int snd_echo_midi_output_close(struct snd_rawmidi_substream *substream)
 	struct echoaudio *chip = substream->rmidi->private_data;
 
 	chip->midi_out = NULL;
-	DE_MID(("rawmidi_oclose\n"));
+	dev_dbg(chip->card->dev, "rawmidi_oclose\n");
 	return 0;
 }
 
@@ -327,6 +328,6 @@ static int snd_echo_midi_create(struct snd_card *card,
 
 	chip->rmidi->info_flags |= SNDRV_RAWMIDI_INFO_OUTPUT |
 		SNDRV_RAWMIDI_INFO_INPUT | SNDRV_RAWMIDI_INFO_DUPLEX;
-	DE_INIT(("MIDI ok\n"));
+	dev_dbg(chip->card->dev, "MIDI ok\n");
 	return 0;
 }
diff --git a/sound/pci/echoaudio/mona_dsp.c b/sound/pci/echoaudio/mona_dsp.c
index 6e6a7eb..eeb9dee 100644
--- a/sound/pci/echoaudio/mona_dsp.c
+++ b/sound/pci/echoaudio/mona_dsp.c
@@ -41,12 +41,13 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	DE_INIT(("init_hw() - Mona\n"));
+	dev_dbg(chip->card->dev, "init_hw() - Mona\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != MONA))
 		return -ENODEV;
 
 	if ((err = init_dsp_comm_page(chip))) {
-		DE_INIT(("init_hw - could not initialize DSP comm page\n"));
+		dev_err(chip->card->dev,
+			"init_hw - could not initialize DSP comm page\n");
 		return err;
 	}
 
@@ -71,7 +72,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	DE_INIT(("init_hw done\n"));
+	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -202,8 +203,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	/* Only set the clock for internal mode. */
 	if (chip->input_clock != ECHO_CLOCK_INTERNAL) {
-		DE_ACT(("set_sample_rate: Cannot set sample rate - "
-			"clock not set to CLK_CLOCKININTERNAL\n"));
+		dev_dbg(chip->card->dev,
+			"Cannot set sample rate - clock not set to CLK_CLOCKININTERNAL\n");
 		/* Save the rate anyhow */
 		chip->comm_page->sample_rate = cpu_to_le32(rate);
 		chip->sample_rate = rate;
@@ -279,7 +280,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 		clock = GML_8KHZ;
 		break;
 	default:
-		DE_ACT(("set_sample_rate: %d invalid!\n", rate));
+		dev_err(chip->card->dev,
+			"set_sample_rate: %d invalid!\n", rate);
 		return -EINVAL;
 	}
 
@@ -287,7 +289,8 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 	chip->comm_page->sample_rate = cpu_to_le32(rate);	/* ignored by the DSP */
 	chip->sample_rate = rate;
-	DE_ACT(("set_sample_rate: %d clock %d\n", rate, clock));
+	dev_dbg(chip->card->dev,
+		"set_sample_rate: %d clock %d\n", rate, clock);
 
 	return write_control_reg(chip, control_reg, force_write);
 }
@@ -299,7 +302,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 	u32 control_reg, clocks_from_dsp;
 	int err;
 
-	DE_ACT(("set_input_clock:\n"));
+	dev_dbg(chip->card->dev, "set_input_clock:\n");
 
 	/* Prevent two simultaneous calls to switch_asic() */
 	if (atomic_read(&chip->opencount))
@@ -312,7 +315,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
-		DE_ACT(("Set Mona clock to INTERNAL\n"));
+		dev_dbg(chip->card->dev, "Set Mona clock to INTERNAL\n");
 		chip->input_clock = ECHO_CLOCK_INTERNAL;
 		return set_sample_rate(chip, chip->sample_rate);
 	case ECHO_CLOCK_SPDIF:
@@ -324,7 +327,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 		spin_lock_irq(&chip->lock);
 		if (err < 0)
 			return err;
-		DE_ACT(("Set Mona clock to SPDIF\n"));
+		dev_dbg(chip->card->dev, "Set Mona clock to SPDIF\n");
 		control_reg |= GML_SPDIF_CLOCK;
 		if (clocks_from_dsp & GML_CLOCK_DETECT_BIT_SPDIF96)
 			control_reg |= GML_DOUBLE_SPEED_MODE;
@@ -332,7 +335,7 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 			control_reg &= ~GML_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_WORD:
-		DE_ACT(("Set Mona clock to WORD\n"));
+		dev_dbg(chip->card->dev, "Set Mona clock to WORD\n");
 		spin_unlock_irq(&chip->lock);
 		err = switch_asic(chip, clocks_from_dsp &
 				  GML_CLOCK_DETECT_BIT_WORD96);
@@ -346,14 +349,15 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 			control_reg &= ~GML_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_ADAT:
-		DE_ACT(("Set Mona clock to ADAT\n"));
+		dev_dbg(chip->card->dev, "Set Mona clock to ADAT\n");
 		if (chip->digital_mode != DIGITAL_MODE_ADAT)
 			return -EAGAIN;
 		control_reg |= GML_ADAT_CLOCK;
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
 		break;
 	default:
-		DE_ACT(("Input clock 0x%x not supported for Mona\n", clock));
+		dev_err(chip->card->dev,
+			"Input clock 0x%x not supported for Mona\n", clock);
 		return -EINVAL;
 	}
 
@@ -381,7 +385,8 @@ static int dsp_set_digital_mode(struct echoaudio *chip, u8 mode)
 			incompatible_clock = TRUE;
 		break;
 	default:
-		DE_ACT(("Digital mode not supported: %d\n", mode));
+		dev_err(chip->card->dev,
+			"Digital mode not supported: %d\n", mode);
 		return -EINVAL;
 	}
 
@@ -422,6 +427,6 @@ static int dsp_set_digital_mode(struct echoaudio *chip, u8 mode)
 		return err;
 	chip->digital_mode = mode;
 
-	DE_ACT(("set_digital_mode to %d\n", mode));
+	dev_warn(chip->card->dev, "set_digital_mode to %d\n", mode);
 	return incompatible_clock;
 }
-- 
1.8.1.2

