Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaKEOX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:23:57 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60889 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaKEOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:22:07 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2] ALSA: echoaudio: cleanup of unnecessary messages
Date: Wed,  5 Nov 2014 19:51:56 +0530
Message-Id: <1415197316-17548-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit "b5b4a41b392960010fccf1f9ccf8334d612bd450" was dereferencing
chip after it has been freed. This patch fixes that and at the same
time removes some debugging messages, which are unnecessary, as they
are just printing information about entry and exit from a function,
and which switch-case it is executing.    
we can easily get from ftrace the information about the entry and exit
from a function.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

change from v1: removing some more debug messages

 sound/pci/echoaudio/darla20_dsp.c   |  2 --
 sound/pci/echoaudio/darla24_dsp.c   |  2 --
 sound/pci/echoaudio/echo3g_dsp.c    |  2 --
 sound/pci/echoaudio/echoaudio.c     | 31 -------------------------------
 sound/pci/echoaudio/echoaudio_3g.c  |  5 -----
 sound/pci/echoaudio/echoaudio_dsp.c | 12 ------------
 sound/pci/echoaudio/gina20_dsp.c    |  6 ------
 sound/pci/echoaudio/gina24_dsp.c    |  9 ---------
 sound/pci/echoaudio/indigo_dsp.c    |  2 --
 sound/pci/echoaudio/indigodj_dsp.c  |  2 --
 sound/pci/echoaudio/indigodjx_dsp.c |  2 --
 sound/pci/echoaudio/indigoio_dsp.c  |  2 --
 sound/pci/echoaudio/indigoiox_dsp.c |  2 --
 sound/pci/echoaudio/layla20_dsp.c   |  9 ---------
 sound/pci/echoaudio/layla24_dsp.c   |  8 --------
 sound/pci/echoaudio/mia_dsp.c       |  2 --
 sound/pci/echoaudio/midi.c          |  6 ------
 sound/pci/echoaudio/mona_dsp.c      |  6 ------
 18 files changed, 110 deletions(-)

diff --git a/sound/pci/echoaudio/darla20_dsp.c b/sound/pci/echoaudio/darla20_dsp.c
index c94e92e..febee5b 100644
--- a/sound/pci/echoaudio/darla20_dsp.c
+++ b/sound/pci/echoaudio/darla20_dsp.c
@@ -33,7 +33,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Darla20\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != DARLA20))
 		return -ENODEV;
 
@@ -58,7 +57,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw: done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/darla24_dsp.c b/sound/pci/echoaudio/darla24_dsp.c
index b1272f88..7b4f6fd 100644
--- a/sound/pci/echoaudio/darla24_dsp.c
+++ b/sound/pci/echoaudio/darla24_dsp.c
@@ -33,7 +33,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Darla24\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != DARLA24))
 		return -ENODEV;
 
@@ -57,7 +56,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw: done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/echo3g_dsp.c b/sound/pci/echoaudio/echo3g_dsp.c
index bc37168..ae11ce1 100644
--- a/sound/pci/echoaudio/echo3g_dsp.c
+++ b/sound/pci/echoaudio/echo3g_dsp.c
@@ -46,7 +46,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 	int err;
 
 	local_irq_enable();
-	dev_dbg(chip->card->dev, "init_hw() - Echo3G\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != ECHO3G))
 		return -ENODEV;
 
@@ -99,7 +98,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 				ECHOCAPS_HAS_DIGITAL_MODE_SPDIF_OPTICAL |
 				ECHOCAPS_HAS_DIGITAL_MODE_ADAT;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 1ef29e5..60e4003 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -79,7 +79,6 @@ static void free_firmware(const struct firmware *fw_entry,
 	dev_dbg(chip->card->dev, "firmware not released (kept in cache)\n");
 #else
 	release_firmware(fw_entry);
-	dev_dbg(chip->card->dev, "firmware released\n");
 #endif
 }
 
@@ -96,7 +95,6 @@ static void free_firmware_cache(struct echoaudio *chip)
 			dev_dbg(chip->card->dev, "release_firmware(%d)\n", i);
 		}
 
-	dev_dbg(chip->card->dev, "firmware_cache released\n");
 #endif
 }
 
@@ -354,7 +352,6 @@ static int pcm_analog_in_open(struct snd_pcm_substream *substream)
 	struct echoaudio *chip = snd_pcm_substream_chip(substream);
 	int err;
 
-	dev_dbg(chip->card->dev, "pcm_analog_in_open\n");
 	if ((err = pcm_open(substream, num_analog_busses_in(chip) -
 			    substream->number)) < 0)
 		return err;
@@ -389,7 +386,6 @@ static int pcm_analog_out_open(struct snd_pcm_substream *substream)
 #else
 	max_channels = num_analog_busses_out(chip);
 #endif
-	dev_dbg(chip->card->dev, "pcm_analog_out_open\n");
 	if ((err = pcm_open(substream, max_channels - substream->number)) < 0)
 		return err;
 	if ((err = snd_pcm_hw_rule_add(substream->runtime, 0,
@@ -422,7 +418,6 @@ static int pcm_digital_in_open(struct snd_pcm_substream *substream)
 	struct echoaudio *chip = snd_pcm_substream_chip(substream);
 	int err, max_channels;
 
-	dev_dbg(chip->card->dev, "pcm_digital_in_open\n");
 	max_channels = num_digital_busses_in(chip) - substream->number;
 	mutex_lock(&chip->mode_mutex);
 	if (chip->digital_mode == DIGITAL_MODE_ADAT)
@@ -464,7 +459,6 @@ static int pcm_digital_out_open(struct snd_pcm_substream *substream)
 	struct echoaudio *chip = snd_pcm_substream_chip(substream);
 	int err, max_channels;
 
-	dev_dbg(chip->card->dev, "pcm_digital_out_open\n");
 	max_channels = num_digital_busses_out(chip) - substream->number;
 	mutex_lock(&chip->mode_mutex);
 	if (chip->digital_mode == DIGITAL_MODE_ADAT)
@@ -511,7 +505,6 @@ static int pcm_close(struct snd_pcm_substream *substream)
 	/* Nothing to do here. Audio is already off and pipe will be
 	 * freed by its callback
 	 */
-	dev_dbg(chip->card->dev, "pcm_close\n");
 
 	atomic_dec(&chip->opencount);
 	oc = atomic_read(&chip->opencount);
@@ -620,7 +613,6 @@ static int init_engine(struct snd_pcm_substream *substream,
 	spin_lock_irq(&chip->lock);
 	set_sample_rate(chip, hw_params->rate_num / hw_params->rate_den);
 	spin_unlock_irq(&chip->lock);
-	dev_dbg(chip->card->dev, "pcm_hw_params ok\n");
 	return 0;
 }
 
@@ -691,7 +683,6 @@ static int pcm_hw_free(struct snd_pcm_substream *substream)
 	}
 	spin_unlock_irq(&chip->lock);
 
-	dev_dbg(chip->card->dev, "pcm_hw_freed\n");
 	snd_pcm_lib_free_pages(substream);
 	return 0;
 }
@@ -763,10 +754,8 @@ static int pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	spin_lock(&chip->lock);
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_RESUME:
-		dev_dbg(chip->card->dev, "pcm_trigger resume\n");
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		dev_dbg(chip->card->dev, "pcm_trigger start\n");
 		for (i = 0; i < DSP_MAXPIPES; i++) {
 			if (channelmask & (1 << i)) {
 				pipe = chip->substream[i]->runtime->private_data;
@@ -788,9 +777,7 @@ static int pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 				      chip->pipe_cyclic_mask);
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-		dev_dbg(chip->card->dev, "pcm_trigger suspend\n");
 	case SNDRV_PCM_TRIGGER_STOP:
-		dev_dbg(chip->card->dev, "pcm_trigger stop\n");
 		for (i = 0; i < DSP_MAXPIPES; i++) {
 			if (channelmask & (1 << i)) {
 				pipe = chip->substream[i]->runtime->private_data;
@@ -800,7 +787,6 @@ static int pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 		err = stop_transport(chip, channelmask);
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		dev_dbg(chip->card->dev, "pcm_trigger pause\n");
 		for (i = 0; i < DSP_MAXPIPES; i++) {
 			if (channelmask & (1 << i)) {
 				pipe = chip->substream[i]->runtime->private_data;
@@ -937,7 +923,6 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &analog_capture_ops);
 	if ((err = snd_echo_preallocate_pages(pcm, snd_dma_pci_data(chip->pci))) < 0)
 		return err;
-	dev_dbg(chip->card->dev, "Analog PCM ok\n");
 
 #ifdef ECHOCARD_HAS_DIGITAL_IO
 	/* PCM#1 Digital inputs, no outputs */
@@ -950,7 +935,6 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &digital_capture_ops);
 	if ((err = snd_echo_preallocate_pages(pcm, snd_dma_pci_data(chip->pci))) < 0)
 		return err;
-	dev_dbg(chip->card->dev, "Digital PCM ok\n");
 #endif /* ECHOCARD_HAS_DIGITAL_IO */
 
 #else /* ECHOCARD_HAS_VMIXER */
@@ -972,7 +956,6 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &analog_capture_ops);
 	if ((err = snd_echo_preallocate_pages(pcm, snd_dma_pci_data(chip->pci))) < 0)
 		return err;
-	dev_dbg(chip->card->dev, "Analog PCM ok\n");
 
 #ifdef ECHOCARD_HAS_DIGITAL_IO
 	/* PCM#1 Digital i/o */
@@ -987,7 +970,6 @@ static int snd_echo_new_pcm(struct echoaudio *chip)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &digital_capture_ops);
 	if ((err = snd_echo_preallocate_pages(pcm, snd_dma_pci_data(chip->pci))) < 0)
 		return err;
-	dev_dbg(chip->card->dev, "Digital PCM ok\n");
 #endif /* ECHOCARD_HAS_DIGITAL_IO */
 
 #endif /* ECHOCARD_HAS_VMIXER */
@@ -1881,10 +1863,8 @@ static irqreturn_t snd_echo_interrupt(int irq, void *dev_id)
 
 static int snd_echo_free(struct echoaudio *chip)
 {
-	dev_dbg(chip->card->dev, "Stop DSP...\n");
 	if (chip->comm_page)
 		rest_in_peace(chip);
-	dev_dbg(chip->card->dev, "Stopped.\n");
 
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
@@ -1898,14 +1878,12 @@ static int snd_echo_free(struct echoaudio *chip)
 	if (chip->iores)
 		release_and_free_resource(chip->iores);
 
-	dev_dbg(chip->card->dev, "MMIO freed.\n");
 
 	pci_disable_device(chip->pci);
 
 	/* release chip data */
 	free_firmware_cache(chip);
 	kfree(chip);
-	dev_dbg(chip->card->dev, "Chip freed.\n");
 	return 0;
 }
 
@@ -1915,7 +1893,6 @@ static int snd_echo_dev_free(struct snd_device *device)
 {
 	struct echoaudio *chip = device->device_data;
 
-	dev_dbg(chip->card->dev, "snd_echo_dev_free()...\n");
 	return snd_echo_free(chip);
 }
 
@@ -2008,7 +1985,6 @@ static int snd_echo_create(struct snd_card *card,
 		snd_echo_free(chip);
 		return err;
 	}
-	dev_dbg(card->dev, "Card init OK\n");
 
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
 		snd_echo_free(chip);
@@ -2038,7 +2014,6 @@ static int snd_echo_probe(struct pci_dev *pci,
 		return -ENOENT;
 	}
 
-	dev_dbg(&pci->dev, "Echoaudio driver starting...\n");
 	i = 0;
 	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   0, &card);
@@ -2191,7 +2166,6 @@ static int snd_echo_suspend(struct device *dev)
 	struct pci_dev *pci = to_pci_dev(dev);
 	struct echoaudio *chip = dev_get_drvdata(dev);
 
-	dev_dbg(dev, "suspend start\n");
 	snd_pcm_suspend_all(chip->analog_pcm);
 	snd_pcm_suspend_all(chip->digital_pcm);
 
@@ -2218,7 +2192,6 @@ static int snd_echo_suspend(struct device *dev)
 	pci_save_state(pci);
 	pci_disable_device(pci);
 
-	dev_dbg(dev, "suspend done\n");
 	return 0;
 }
 
@@ -2232,7 +2205,6 @@ static int snd_echo_resume(struct device *dev)
 	u32 pipe_alloc_mask;
 	int err;
 
-	dev_dbg(dev, "resume start\n");
 	pci_restore_state(pci);
 	commpage_bak = kmalloc(sizeof(struct echoaudio), GFP_KERNEL);
 	if (commpage_bak == NULL)
@@ -2247,7 +2219,6 @@ static int snd_echo_resume(struct device *dev)
 		snd_echo_free(chip);
 		return err;
 	}
-	dev_dbg(dev, "resume init OK\n");
 
 	/* Temporarily set chip->pipe_alloc_mask=0 otherwise
 	 * restore_dsp_settings() fails.
@@ -2260,7 +2231,6 @@ static int snd_echo_resume(struct device *dev)
 		kfree(commpage_bak);
 		return err;
 	}
-	dev_dbg(dev, "resume restore OK\n");
 
 	memcpy(&commpage->audio_format, &commpage_bak->audio_format,
 		sizeof(commpage->audio_format));
@@ -2286,7 +2256,6 @@ static int snd_echo_resume(struct device *dev)
 		snd_echo_midi_output_trigger(chip->midi_out, 1);
 #endif
 
-	dev_dbg(dev, "resume done\n");
 	return 0;
 }
 
diff --git a/sound/pci/echoaudio/echoaudio_3g.c b/sound/pci/echoaudio/echoaudio_3g.c
index 50a2169..2fa66dc 100644
--- a/sound/pci/echoaudio/echoaudio_3g.c
+++ b/sound/pci/echoaudio/echoaudio_3g.c
@@ -328,7 +328,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 {
 	u32 control_reg, clocks_from_dsp;
 
-	dev_dbg(chip->card->dev, "set_input_clock:\n");
 
 	/* Mask off the clock select bits */
 	control_reg = le32_to_cpu(chip->comm_page->control_register) &
@@ -337,13 +336,11 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
-		dev_dbg(chip->card->dev, "Set Echo3G clock to INTERNAL\n");
 		chip->input_clock = ECHO_CLOCK_INTERNAL;
 		return set_sample_rate(chip, chip->sample_rate);
 	case ECHO_CLOCK_SPDIF:
 		if (chip->digital_mode == DIGITAL_MODE_ADAT)
 			return -EAGAIN;
-		dev_dbg(chip->card->dev, "Set Echo3G clock to SPDIF\n");
 		control_reg |= E3G_SPDIF_CLOCK;
 		if (clocks_from_dsp & E3G_CLOCK_DETECT_BIT_SPDIF96)
 			control_reg |= E3G_DOUBLE_SPEED_MODE;
@@ -353,12 +350,10 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 	case ECHO_CLOCK_ADAT:
 		if (chip->digital_mode != DIGITAL_MODE_ADAT)
 			return -EAGAIN;
-		dev_dbg(chip->card->dev, "Set Echo3G clock to ADAT\n");
 		control_reg |= E3G_ADAT_CLOCK;
 		control_reg &= ~E3G_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_WORD:
-		dev_dbg(chip->card->dev, "Set Echo3G clock to WORD\n");
 		control_reg |= E3G_WORD_CLOCK;
 		if (clocks_from_dsp & E3G_CLOCK_DETECT_BIT_WORD96)
 			control_reg |= E3G_DOUBLE_SPEED_MODE;
diff --git a/sound/pci/echoaudio/echoaudio_dsp.c b/sound/pci/echoaudio/echoaudio_dsp.c
index ba9d4f1..1a9427a 100644
--- a/sound/pci/echoaudio/echoaudio_dsp.c
+++ b/sound/pci/echoaudio/echoaudio_dsp.c
@@ -206,7 +206,6 @@ static int load_asic_generic(struct echoaudio *chip, u32 cmd, short asic)
 			goto la_error;
 	}
 
-	dev_dbg(chip->card->dev, "ASIC loaded\n");
 	free_firmware(fw, chip);
 	return 0;
 
@@ -473,7 +472,6 @@ static int load_dsp(struct echoaudio *chip, u16 *code)
 
 			chip->dsp_code = code;		/* Show which DSP code loaded */
 			chip->bad_board = FALSE;	/* DSP OK */
-			dev_dbg(chip->card->dev, "load_dsp: OK!\n");
 			return 0;
 		}
 		udelay(100);
@@ -674,7 +672,6 @@ static void get_audio_meters(struct echoaudio *chip, long *meters)
 static int restore_dsp_rettings(struct echoaudio *chip)
 {
 	int i, o, err;
-	dev_dbg(chip->card->dev, "restore_dsp_settings\n");
 
 	if ((err = check_asic_status(chip)) < 0)
 		return err;
@@ -771,7 +768,6 @@ static int restore_dsp_rettings(struct echoaudio *chip)
 	if (send_vector(chip, DSP_VC_UPDATE_FLAGS) < 0)
 		return -EIO;
 
-	dev_dbg(chip->card->dev, "restore_dsp_rettings done\n");
 	return 0;
 }
 
@@ -865,7 +861,6 @@ Same thing for pause_ and stop_ -trasport below. */
 static int start_transport(struct echoaudio *chip, u32 channel_mask,
 			   u32 cyclic_mask)
 {
-	dev_dbg(chip->card->dev, "start_transport %x\n", channel_mask);
 
 	if (wait_handshake(chip))
 		return -EIO;
@@ -891,7 +886,6 @@ static int start_transport(struct echoaudio *chip, u32 channel_mask,
 
 static int pause_transport(struct echoaudio *chip, u32 channel_mask)
 {
-	dev_dbg(chip->card->dev, "pause_transport %x\n", channel_mask);
 
 	if (wait_handshake(chip))
 		return -EIO;
@@ -918,7 +912,6 @@ static int pause_transport(struct echoaudio *chip, u32 channel_mask)
 
 static int stop_transport(struct echoaudio *chip, u32 channel_mask)
 {
-	dev_dbg(chip->card->dev, "stop_transport %x\n", channel_mask);
 
 	if (wait_handshake(chip))
 		return -EIO;
@@ -954,8 +947,6 @@ static inline int is_pipe_allocated(struct echoaudio *chip, u16 pipe_index)
 stopped and unallocated. */
 static int rest_in_peace(struct echoaudio *chip)
 {
-	dev_dbg(chip->card->dev,
-		"rest_in_peace() open=%x\n", chip->pipe_alloc_mask);
 
 	/* Stops all active pipes (just to be sure) */
 	stop_transport(chip, chip->active_mask);
@@ -1018,7 +1009,6 @@ static int init_dsp_comm_page(struct echoaudio *chip)
  */
 static int init_line_levels(struct echoaudio *chip)
 {
-	dev_dbg(chip->card->dev, "init_line_levels\n");
 	memset(chip->output_gain, ECHOGAIN_MUTED, sizeof(chip->output_gain));
 	memset(chip->input_gain, ECHOGAIN_MUTED, sizeof(chip->input_gain));
 	memset(chip->monitor_gain, ECHOGAIN_MUTED, sizeof(chip->monitor_gain));
@@ -1099,7 +1089,6 @@ static int allocate_pipes(struct echoaudio *chip, struct audiopipe *pipe,
 	it moves data. The DMA counter is in units of bytes, not samples. */
 	pipe->dma_counter = &chip->comm_page->position[pipe_index];
 	*pipe->dma_counter = 0;
-	dev_dbg(chip->card->dev, "allocate_pipes: ok\n");
 	return pipe_index;
 }
 
@@ -1110,7 +1099,6 @@ static int free_pipes(struct echoaudio *chip, struct audiopipe *pipe)
 	u32 channel_mask;
 	int i;
 
-	dev_dbg(chip->card->dev, "free_pipes: Pipe %d\n", pipe->index);
 	if (snd_BUG_ON(!is_pipe_allocated(chip, pipe->index)))
 		return -EINVAL;
 	if (snd_BUG_ON(pipe->state != PIPE_STATE_STOPPED))
diff --git a/sound/pci/echoaudio/gina20_dsp.c b/sound/pci/echoaudio/gina20_dsp.c
index a959eae..5dafe92 100644
--- a/sound/pci/echoaudio/gina20_dsp.c
+++ b/sound/pci/echoaudio/gina20_dsp.c
@@ -37,7 +37,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Gina20\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != GINA20))
 		return -ENODEV;
 
@@ -63,7 +62,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -150,7 +148,6 @@ static int set_sample_rate(struct echoaudio *chip, u32 rate)
 
 static int set_input_clock(struct echoaudio *chip, u16 clock)
 {
-	dev_dbg(chip->card->dev, "set_input_clock:\n");
 
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
@@ -159,7 +156,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 		chip->spdif_status = GD_SPDIF_STATUS_UNDEF;
 		set_sample_rate(chip, chip->sample_rate);
 		chip->input_clock = clock;
-		dev_dbg(chip->card->dev, "Set Gina clock to INTERNAL\n");
 		break;
 	case ECHO_CLOCK_SPDIF:
 		chip->comm_page->gd_clock_state = GD_CLOCK_SPDIFIN;
@@ -167,7 +163,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 		clear_handshake(chip);
 		send_vector(chip, DSP_VC_SET_GD_AUDIO_STATE);
 		chip->clock_state = GD_CLOCK_SPDIFIN;
-		dev_dbg(chip->card->dev, "Set Gina20 clock to SPDIF\n");
 		chip->input_clock = clock;
 		break;
 	default:
@@ -209,7 +204,6 @@ static int update_flags(struct echoaudio *chip)
 
 static int set_professional_spdif(struct echoaudio *chip, char prof)
 {
-	dev_dbg(chip->card->dev, "set_professional_spdif %d\n", prof);
 	if (prof)
 		chip->comm_page->flags |=
 			cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
diff --git a/sound/pci/echoaudio/gina24_dsp.c b/sound/pci/echoaudio/gina24_dsp.c
index c8ea576..6971766 100644
--- a/sound/pci/echoaudio/gina24_dsp.c
+++ b/sound/pci/echoaudio/gina24_dsp.c
@@ -41,7 +41,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Gina24\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != GINA24))
 		return -ENODEV;
 
@@ -79,7 +78,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -156,7 +154,6 @@ static int load_asic(struct echoaudio *chip)
 		control_reg = GML_CONVERTER_ENABLE | GML_48KHZ;
 		err = write_control_reg(chip, control_reg, TRUE);
 	}
-	dev_dbg(chip->card->dev, "load_asic() done\n");
 	return err;
 }
 
@@ -238,7 +235,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 {
 	u32 control_reg, clocks_from_dsp;
 
-	dev_dbg(chip->card->dev, "set_input_clock:\n");
 
 	/* Mask off the clock select bits */
 	control_reg = le32_to_cpu(chip->comm_page->control_register) &
@@ -247,13 +243,11 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
-		dev_dbg(chip->card->dev, "Set Gina24 clock to INTERNAL\n");
 		chip->input_clock = ECHO_CLOCK_INTERNAL;
 		return set_sample_rate(chip, chip->sample_rate);
 	case ECHO_CLOCK_SPDIF:
 		if (chip->digital_mode == DIGITAL_MODE_ADAT)
 			return -EAGAIN;
-		dev_dbg(chip->card->dev, "Set Gina24 clock to SPDIF\n");
 		control_reg |= GML_SPDIF_CLOCK;
 		if (clocks_from_dsp & GML_CLOCK_DETECT_BIT_SPDIF96)
 			control_reg |= GML_DOUBLE_SPEED_MODE;
@@ -263,17 +257,14 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 	case ECHO_CLOCK_ADAT:
 		if (chip->digital_mode != DIGITAL_MODE_ADAT)
 			return -EAGAIN;
-		dev_dbg(chip->card->dev, "Set Gina24 clock to ADAT\n");
 		control_reg |= GML_ADAT_CLOCK;
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_ESYNC:
-		dev_dbg(chip->card->dev, "Set Gina24 clock to ESYNC\n");
 		control_reg |= GML_ESYNC_CLOCK;
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_ESYNC96:
-		dev_dbg(chip->card->dev, "Set Gina24 clock to ESYNC96\n");
 		control_reg |= GML_ESYNC_CLOCK | GML_DOUBLE_SPEED_MODE;
 		break;
 	default:
diff --git a/sound/pci/echoaudio/indigo_dsp.c b/sound/pci/echoaudio/indigo_dsp.c
index cdeb073..54edd67 100644
--- a/sound/pci/echoaudio/indigo_dsp.c
+++ b/sound/pci/echoaudio/indigo_dsp.c
@@ -38,7 +38,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Indigo\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO))
 		return -ENODEV;
 
@@ -61,7 +60,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/indigodj_dsp.c b/sound/pci/echoaudio/indigodj_dsp.c
index 133915c..2cf5cc0 100644
--- a/sound/pci/echoaudio/indigodj_dsp.c
+++ b/sound/pci/echoaudio/indigodj_dsp.c
@@ -38,7 +38,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Indigo DJ\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO_DJ))
 		return -ENODEV;
 
@@ -61,7 +60,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/indigodjx_dsp.c b/sound/pci/echoaudio/indigodjx_dsp.c
index 26cdfcf..5252863 100644
--- a/sound/pci/echoaudio/indigodjx_dsp.c
+++ b/sound/pci/echoaudio/indigodjx_dsp.c
@@ -35,7 +35,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Indigo DJx\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO_DJX))
 		return -ENODEV;
 
@@ -60,7 +59,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/indigoio_dsp.c b/sound/pci/echoaudio/indigoio_dsp.c
index 5e6df7c..4e81787 100644
--- a/sound/pci/echoaudio/indigoio_dsp.c
+++ b/sound/pci/echoaudio/indigoio_dsp.c
@@ -38,7 +38,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Indigo IO\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO_IO))
 		return -ENODEV;
 
@@ -61,7 +60,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/indigoiox_dsp.c b/sound/pci/echoaudio/indigoiox_dsp.c
index 90cdd27..6de3f9b 100644
--- a/sound/pci/echoaudio/indigoiox_dsp.c
+++ b/sound/pci/echoaudio/indigoiox_dsp.c
@@ -35,7 +35,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Indigo IOx\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != INDIGO_IOX))
 		return -ENODEV;
 
@@ -60,7 +59,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/layla20_dsp.c b/sound/pci/echoaudio/layla20_dsp.c
index 7f0f6ea..f2024a3 100644
--- a/sound/pci/echoaudio/layla20_dsp.c
+++ b/sound/pci/echoaudio/layla20_dsp.c
@@ -40,7 +40,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Layla20\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != LAYLA20))
 		return -ENODEV;
 
@@ -65,7 +64,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -190,24 +188,19 @@ static int set_input_clock(struct echoaudio *chip, u16 clock_source)
 	u16 clock;
 	u32 rate;
 
-	dev_dbg(chip->card->dev, "set_input_clock:\n");
 	rate = 0;
 	switch (clock_source) {
 	case ECHO_CLOCK_INTERNAL:
-		dev_dbg(chip->card->dev, "Set Layla20 clock to INTERNAL\n");
 		rate = chip->sample_rate;
 		clock = LAYLA20_CLOCK_INTERNAL;
 		break;
 	case ECHO_CLOCK_SPDIF:
-		dev_dbg(chip->card->dev, "Set Layla20 clock to SPDIF\n");
 		clock = LAYLA20_CLOCK_SPDIF;
 		break;
 	case ECHO_CLOCK_WORD:
-		dev_dbg(chip->card->dev, "Set Layla20 clock to WORD\n");
 		clock = LAYLA20_CLOCK_WORD;
 		break;
 	case ECHO_CLOCK_SUPER:
-		dev_dbg(chip->card->dev, "Set Layla20 clock to SUPER\n");
 		clock = LAYLA20_CLOCK_SUPER;
 		break;
 	default:
@@ -232,7 +225,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock_source)
 
 static int set_output_clock(struct echoaudio *chip, u16 clock)
 {
-	dev_dbg(chip->card->dev, "set_output_clock: %d\n", clock);
 	switch (clock) {
 	case ECHO_CLOCK_SUPER:
 		clock = LAYLA20_OUTPUT_CLOCK_SUPER;
@@ -286,7 +278,6 @@ static int update_flags(struct echoaudio *chip)
 
 static int set_professional_spdif(struct echoaudio *chip, char prof)
 {
-	dev_dbg(chip->card->dev, "set_professional_spdif %d\n", prof);
 	if (prof)
 		chip->comm_page->flags |=
 			cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
diff --git a/sound/pci/echoaudio/layla24_dsp.c b/sound/pci/echoaudio/layla24_dsp.c
index eb8f218..4f11e81 100644
--- a/sound/pci/echoaudio/layla24_dsp.c
+++ b/sound/pci/echoaudio/layla24_dsp.c
@@ -40,7 +40,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Layla24\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != LAYLA24))
 		return -ENODEV;
 
@@ -70,7 +69,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 	if ((err = init_line_levels(chip)) < 0)
 		return err;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -118,7 +116,6 @@ static int load_asic(struct echoaudio *chip)
 	if (chip->asic_loaded)
 		return 1;
 
-	dev_dbg(chip->card->dev, "load_asic\n");
 
 	/* Give the DSP a few milliseconds to settle down */
 	mdelay(10);
@@ -152,7 +149,6 @@ static int load_asic(struct echoaudio *chip)
 		err = write_control_reg(chip, GML_CONVERTER_ENABLE | GML_48KHZ,
 					TRUE);
 	
-	dev_dbg(chip->card->dev, "load_asic() done\n");
 	return err;
 }
 
@@ -262,7 +258,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 	/* Pick the new clock */
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
-		dev_dbg(chip->card->dev, "Set Layla24 clock to INTERNAL\n");
 		chip->input_clock = ECHO_CLOCK_INTERNAL;
 		return set_sample_rate(chip, chip->sample_rate);
 	case ECHO_CLOCK_SPDIF:
@@ -271,7 +266,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 		control_reg |= GML_SPDIF_CLOCK;
 		/* Layla24 doesn't support 96KHz S/PDIF */
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
-		dev_dbg(chip->card->dev, "Set Layla24 clock to SPDIF\n");
 		break;
 	case ECHO_CLOCK_WORD:
 		control_reg |= GML_WORD_CLOCK;
@@ -279,14 +273,12 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 			control_reg |= GML_DOUBLE_SPEED_MODE;
 		else
 			control_reg &= ~GML_DOUBLE_SPEED_MODE;
-		dev_dbg(chip->card->dev, "Set Layla24 clock to WORD\n");
 		break;
 	case ECHO_CLOCK_ADAT:
 		if (chip->digital_mode != DIGITAL_MODE_ADAT)
 			return -EAGAIN;
 		control_reg |= GML_ADAT_CLOCK;
 		control_reg &= ~GML_DOUBLE_SPEED_MODE;
-		dev_dbg(chip->card->dev, "Set Layla24 clock to ADAT\n");
 		break;
 	default:
 		dev_err(chip->card->dev,
diff --git a/sound/pci/echoaudio/mia_dsp.c b/sound/pci/echoaudio/mia_dsp.c
index ed2f21d..fdad079 100644
--- a/sound/pci/echoaudio/mia_dsp.c
+++ b/sound/pci/echoaudio/mia_dsp.c
@@ -41,7 +41,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Mia\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != MIA))
 		return -ENODEV;
 
@@ -67,7 +66,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
diff --git a/sound/pci/echoaudio/midi.c b/sound/pci/echoaudio/midi.c
index 8d43c5a..d913749 100644
--- a/sound/pci/echoaudio/midi.c
+++ b/sound/pci/echoaudio/midi.c
@@ -157,7 +157,6 @@ static int snd_echo_midi_input_open(struct snd_rawmidi_substream *substream)
 	struct echoaudio *chip = substream->rmidi->private_data;
 
 	chip->midi_in = substream;
-	dev_dbg(chip->card->dev, "rawmidi_iopen\n");
 	return 0;
 }
 
@@ -183,7 +182,6 @@ static int snd_echo_midi_input_close(struct snd_rawmidi_substream *substream)
 	struct echoaudio *chip = substream->rmidi->private_data;
 
 	chip->midi_in = NULL;
-	dev_dbg(chip->card->dev, "rawmidi_iclose\n");
 	return 0;
 }
 
@@ -196,7 +194,6 @@ static int snd_echo_midi_output_open(struct snd_rawmidi_substream *substream)
 	chip->tinuse = 0;
 	chip->midi_full = 0;
 	chip->midi_out = substream;
-	dev_dbg(chip->card->dev, "rawmidi_open\n");
 	return 0;
 }
 
@@ -209,7 +206,6 @@ static void snd_echo_midi_output_write(unsigned long data)
 	int bytes, sent, time;
 	unsigned char buf[MIDI_OUT_BUFFER_SIZE - 1];
 
-	dev_dbg(chip->card->dev, "snd_echo_midi_output_write\n");
 	/* No interrupts are involved: we have to check at regular intervals
 	if the card's output buffer has room for new data. */
 	sent = bytes = 0;
@@ -288,7 +284,6 @@ static int snd_echo_midi_output_close(struct snd_rawmidi_substream *substream)
 	struct echoaudio *chip = substream->rmidi->private_data;
 
 	chip->midi_out = NULL;
-	dev_dbg(chip->card->dev, "rawmidi_oclose\n");
 	return 0;
 }
 
@@ -328,6 +323,5 @@ static int snd_echo_midi_create(struct snd_card *card,
 
 	chip->rmidi->info_flags |= SNDRV_RAWMIDI_INFO_OUTPUT |
 		SNDRV_RAWMIDI_INFO_INPUT | SNDRV_RAWMIDI_INFO_DUPLEX;
-	dev_dbg(chip->card->dev, "MIDI ok\n");
 	return 0;
 }
diff --git a/sound/pci/echoaudio/mona_dsp.c b/sound/pci/echoaudio/mona_dsp.c
index cc46a8c..843c7a5 100644
--- a/sound/pci/echoaudio/mona_dsp.c
+++ b/sound/pci/echoaudio/mona_dsp.c
@@ -41,7 +41,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 {
 	int err;
 
-	dev_dbg(chip->card->dev, "init_hw() - Mona\n");
 	if (snd_BUG_ON((subdevice_id & 0xfff0) != MONA))
 		return -ENODEV;
 
@@ -72,7 +71,6 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 		return err;
 	chip->bad_board = FALSE;
 
-	dev_dbg(chip->card->dev, "init_hw done\n");
 	return err;
 }
 
@@ -302,7 +300,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 	u32 control_reg, clocks_from_dsp;
 	int err;
 
-	dev_dbg(chip->card->dev, "set_input_clock:\n");
 
 	/* Prevent two simultaneous calls to switch_asic() */
 	if (atomic_read(&chip->opencount))
@@ -315,7 +312,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 
 	switch (clock) {
 	case ECHO_CLOCK_INTERNAL:
-		dev_dbg(chip->card->dev, "Set Mona clock to INTERNAL\n");
 		chip->input_clock = ECHO_CLOCK_INTERNAL;
 		return set_sample_rate(chip, chip->sample_rate);
 	case ECHO_CLOCK_SPDIF:
@@ -327,7 +323,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 		spin_lock_irq(&chip->lock);
 		if (err < 0)
 			return err;
-		dev_dbg(chip->card->dev, "Set Mona clock to SPDIF\n");
 		control_reg |= GML_SPDIF_CLOCK;
 		if (clocks_from_dsp & GML_CLOCK_DETECT_BIT_SPDIF96)
 			control_reg |= GML_DOUBLE_SPEED_MODE;
@@ -335,7 +330,6 @@ static int set_input_clock(struct echoaudio *chip, u16 clock)
 			control_reg &= ~GML_DOUBLE_SPEED_MODE;
 		break;
 	case ECHO_CLOCK_WORD:
-		dev_dbg(chip->card->dev, "Set Mona clock to WORD\n");
 		spin_unlock_irq(&chip->lock);
 		err = switch_asic(chip, clocks_from_dsp &
 				  GML_CLOCK_DETECT_BIT_WORD96);
-- 
1.8.1.2

