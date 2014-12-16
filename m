Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaLPIsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:48:11 -0500
Received: from sender1.zohomail.com ([74.201.84.156]:37442 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaLPIsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:48:10 -0500
X-Greylist: delayed 986 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2014 03:48:10 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=from:to:cc:subject:date:message-id; 
  b=W/OH1AOKx3apKPzP9O90mXHvZP1Roa1SL/40OUduMcwsax/1dWL53NIS+L3EKIerAXDPlghaqdEO
    f19jNB/UOLcl3Ry4QF6X3bRMDmPx0qjW5jvyuXgfft1B9fcM6Vkh  
From: Rastislav Barlik <barlik@zoho.com>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Rastislav Barlik <barlik@zoho.com>
Subject: [PATCH] ASoC: Intel: Use proper print format for unsigned integers
Date: Tue, 16 Dec 2014 09:48:01 +0100
Message-Id: <1418719681-4557-1-git-send-email-barlik@zoho.com>
X-Mailer: git-send-email 2.1.3
X-ZohoMail: Ss  SS_10 UW UB UW UB  ZSF-HLOLL_2 SF_TD_EXT  SGR3_1_09124_41
X-ZohoMail-Owner: <1418719681-4557-1-git-send-email-barlik@zoho.com>+zmo_0_<barlik@zoho.com>
X-ZohoMail-Sender: 85.163.199.236
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %u instead of %d format for printing unsigned integers. Also use
unsigned integer for count and pages variables.

Signed-off-by: Rastislav Barlik <barlik@zoho.com>

---
 sound/soc/intel/sst-haswell-dsp.c | 11 ++++++-----
 sound/soc/intel/sst-haswell-ipc.c | 30 +++++++++++++++---------------
 sound/soc/intel/sst-haswell-pcm.c | 21 +++++++++++----------
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/sound/soc/intel/sst-haswell-dsp.c b/sound/soc/intel/sst-haswell-dsp.c
index 4b6c163..96c7201 100644
--- a/sound/soc/intel/sst-haswell-dsp.c
+++ b/sound/soc/intel/sst-haswell-dsp.c
@@ -88,7 +88,7 @@ static int hsw_parse_module(struct sst_dsp *dsp, struct sst_fw *fw,
 	struct sst_module *mod;
 	struct sst_module_data block_data;
 	struct sst_module_template template;
-	int count;
+	u32 count;
 	void __iomem *ram;
 
 	/* TODO: allowed module types need to be configurable */
@@ -127,7 +127,7 @@ static int hsw_parse_module(struct sst_dsp *dsp, struct sst_fw *fw,
 
 		if (block->size <= 0) {
 			dev_err(dsp->dev,
-				"error: block %d size invalid\n", count);
+				"error: block %u size invalid\n", count);
 			sst_module_free(mod);
 			return -EINVAL;
 		}
@@ -156,7 +156,7 @@ static int hsw_parse_module(struct sst_dsp *dsp, struct sst_fw *fw,
 		block_data.data = (void *)block + sizeof(*block);
 		block_data.data_offset = block_data.data - fw->dma_buf;
 
-		dev_dbg(dsp->dev, "copy firmware block %d type 0x%x "
+		dev_dbg(dsp->dev, "copy firmware block %u type 0x%x "
 			"size 0x%x ==> ram %p offset 0x%x\n",
 			count, block->type, block->size, ram,
 			block->ram_offset);
@@ -175,7 +175,8 @@ static int hsw_parse_fw_image(struct sst_fw *sst_fw)
 	struct fw_module_header *module;
 	struct sst_dsp *dsp = sst_fw->dsp;
 	struct sst_hsw *hsw = sst_fw->private;
-	int ret, count;
+	int ret;
+	u32 count;
 
 	/* Read the header information from the data pointer */
 	header = (struct fw_header *)sst_fw->dma_buf;
@@ -198,7 +199,7 @@ static int hsw_parse_fw_image(struct sst_fw *sst_fw)
 		/* module */
 		ret = hsw_parse_module(dsp, sst_fw, module);
 		if (ret < 0) {
-			dev_err(dsp->dev, "error: invalid module %d\n", count);
+			dev_err(dsp->dev, "error: invalid module %u\n", count);
 			return ret;
 		}
 		module = (void *)module + sizeof(*module) + module->mod_size;
diff --git a/sound/soc/intel/sst-haswell-ipc.c b/sound/soc/intel/sst-haswell-ipc.c
index b629151..440cadd 100644
--- a/sound/soc/intel/sst-haswell-ipc.c
+++ b/sound/soc/intel/sst-haswell-ipc.c
@@ -577,7 +577,7 @@ static void hsw_fw_ready(struct sst_hsw *hsw, u32 header)
 
 	offset = (header & 0x1FFFFFFF) << 3;
 
-	dev_dbg(hsw->dev, "ipc: DSP is ready 0x%8.8x offset %d\n",
+	dev_dbg(hsw->dev, "ipc: DSP is ready 0x%8.8x offset %u\n",
 		header, offset);
 
 	/* copy data from the DSP FW ready offset */
@@ -626,7 +626,7 @@ static void hsw_notification_work(struct work_struct *work)
 			stream->reply.stream_hw_id);
 		sst_dsp_inbox_read(hsw->dsp, glitch, sizeof(*glitch));
 
-		dev_err(hsw->dev, "glitch %d pos 0x%x write pos 0x%x\n",
+		dev_err(hsw->dev, "glitch %u pos 0x%x write pos 0x%x\n",
 			glitch->glitch_type, glitch->present_pos,
 			glitch->write_pos);
 		break;
@@ -878,7 +878,7 @@ static int hsw_process_notification(struct sst_hsw *hsw)
 	case IPC_GLB_MAX_IPC_MESSAGE_TYPE:
 	case IPC_GLB_RESTORE_CONTEXT:
 	case IPC_GLB_SHORT_REPLY:
-		dev_err(hsw->dev, "error: message type %d header 0x%x\n",
+		dev_err(hsw->dev, "error: message type %u header 0x%x\n",
 			type, header);
 		break;
 	case IPC_GLB_STREAM_MESSAGE:
@@ -888,7 +888,7 @@ static int hsw_process_notification(struct sst_hsw *hsw)
 		handled = hsw_log_message(hsw, header);
 		break;
 	default:
-		dev_err(hsw->dev, "error: unexpected type %d hdr 0x%8.8x\n",
+		dev_err(hsw->dev, "error: unexpected type %u hdr 0x%8.8x\n",
 			type, header);
 		break;
 	}
@@ -977,7 +977,7 @@ int sst_hsw_stream_mute(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
 
 	ret = sst_hsw_stream_set_volume(hsw, stream, stage_id, channel, 0);
 	if (ret < 0) {
-		dev_err(hsw->dev, "error: can't unmute stream %d channel %d\n",
+		dev_err(hsw->dev, "error: can't unmute stream %u channel %u\n",
 			stream->reply.stream_hw_id, channel);
 		return ret;
 	}
@@ -996,7 +996,7 @@ int sst_hsw_stream_unmute(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
 	ret = sst_hsw_stream_set_volume(hsw, stream, stage_id, channel,
 		stream->mute_volume[channel]);
 	if (ret < 0) {
-		dev_err(hsw->dev, "error: can't unmute stream %d channel %d\n",
+		dev_err(hsw->dev, "error: can't unmute stream %u channel %u\n",
 			stream->reply.stream_hw_id, channel);
 		return ret;
 	}
@@ -1076,7 +1076,7 @@ int sst_hsw_mixer_mute(struct sst_hsw *hsw, u32 stage_id, u32 channel)
 
 	ret = sst_hsw_mixer_set_volume(hsw, stage_id, channel, 0);
 	if (ret < 0) {
-		dev_err(hsw->dev, "error: failed to unmute mixer channel %d\n",
+		dev_err(hsw->dev, "error: failed to unmute mixer channel %u\n",
 			channel);
 		return ret;
 	}
@@ -1092,7 +1092,7 @@ int sst_hsw_mixer_unmute(struct sst_hsw *hsw, u32 stage_id, u32 channel)
 	ret = sst_hsw_mixer_set_volume(hsw, stage_id, channel,
 		hsw->mixer_info.volume_register_address[channel]);
 	if (ret < 0) {
-		dev_err(hsw->dev, "error: failed to unmute mixer channel %d\n",
+		dev_err(hsw->dev, "error: failed to unmute mixer channel %u\n",
 			channel);
 		return ret;
 	}
@@ -1219,7 +1219,7 @@ int sst_hsw_stream_free(struct sst_hsw *hsw, struct sst_hsw_stream *stream)
 	ret = ipc_tx_message_wait(hsw, header, &stream->free_req,
 		sizeof(stream->free_req), NULL, 0);
 	if (ret < 0) {
-		dev_err(hsw->dev, "error: free stream %d failed\n",
+		dev_err(hsw->dev, "error: free stream %u failed\n",
 			stream->free_req.stream_id);
 		return -EAGAIN;
 	}
@@ -1517,7 +1517,7 @@ int sst_hsw_stream_pause(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
 	ret = sst_hsw_stream_operations(hsw, IPC_STR_PAUSE,
 		stream->reply.stream_hw_id, wait);
 	if (ret < 0)
-		dev_err(hsw->dev, "error: failed to pause stream %d\n",
+		dev_err(hsw->dev, "error: failed to pause stream %u\n",
 			stream->reply.stream_hw_id);
 
 	return ret;
@@ -1533,7 +1533,7 @@ int sst_hsw_stream_resume(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
 	ret = sst_hsw_stream_operations(hsw, IPC_STR_RESUME,
 		stream->reply.stream_hw_id, wait);
 	if (ret < 0)
-		dev_err(hsw->dev, "error: failed to resume stream %d\n",
+		dev_err(hsw->dev, "error: failed to resume stream %u\n",
 			stream->reply.stream_hw_id);
 
 	return ret;
@@ -1551,7 +1551,7 @@ int sst_hsw_stream_reset(struct sst_hsw *hsw, struct sst_hsw_stream *stream)
 	while (stream->running && tries--)
 		msleep(1);
 	if (!tries) {
-		dev_err(hsw->dev, "error: reset stream %d still running\n",
+		dev_err(hsw->dev, "error: reset stream %u still running\n",
 			stream->reply.stream_hw_id);
 		return -EINVAL;
 	}
@@ -1561,7 +1561,7 @@ int sst_hsw_stream_reset(struct sst_hsw *hsw, struct sst_hsw_stream *stream)
 	ret = sst_hsw_stream_operations(hsw, IPC_STR_RESET,
 		stream->reply.stream_hw_id, 1);
 	if (ret < 0)
-		dev_err(hsw->dev, "error: failed to reset stream %d\n",
+		dev_err(hsw->dev, "error: failed to reset stream %u\n",
 			stream->reply.stream_hw_id);
 	return ret;
 }
@@ -1609,7 +1609,7 @@ int sst_hsw_stream_set_write_position(struct sst_hsw *hsw,
 	ret = ipc_tx_message_nowait(hsw, header, &stream->wpos,
 		sizeof(stream->wpos));
 	if (ret < 0)
-		dev_err(hsw->dev, "error: stream %d set position %d failed\n",
+		dev_err(hsw->dev, "error: stream %u set position %u failed\n",
 			stream->reply.stream_hw_id, position);
 
 	return ret;
@@ -1670,7 +1670,7 @@ int sst_hsw_dx_set_state(struct sst_hsw *hsw,
 			dx->mem_info[item].size,
 			dx->mem_info[item].source);
 	}
-	dev_dbg(hsw->dev, "ipc: got %d entry numbers for state %d\n",
+	dev_dbg(hsw->dev, "ipc: got %u entry numbers for state %d\n",
 		dx->entries_no, state);
 
 	memcpy(&hsw->dx, dx, sizeof(*dx));
diff --git a/sound/soc/intel/sst-haswell-pcm.c b/sound/soc/intel/sst-haswell-pcm.c
index 4df867c..7367326 100644
--- a/sound/soc/intel/sst-haswell-pcm.c
+++ b/sound/soc/intel/sst-haswell-pcm.c
@@ -278,11 +278,12 @@ static int create_adsp_page_table(struct snd_pcm_substream *substream,
 	unsigned char *dma_area, size_t size, int pcm)
 {
 	struct snd_dma_buffer *dmab = snd_pcm_get_dma_buf(substream);
-	int i, pages, stream = substream->stream;
+	int stream = substream->stream;
+	unsigned int i, pages;
 
 	pages = snd_sgbuf_aligned_pages(size);
 
-	dev_dbg(rtd->dev, "generating page table for %p size 0x%zu pages %d\n",
+	dev_dbg(rtd->dev, "generating page table for %p size 0x%zu pages %u\n",
 		dma_area, size, pages);
 
 	for (i = 0; i < pages; i++) {
@@ -290,7 +291,7 @@ static int create_adsp_page_table(struct snd_pcm_substream *substream,
 		u32 pfn = snd_sgbuf_get_addr(dmab, i * PAGE_SIZE) >> PAGE_SHIFT;
 		u32 *pg_table;
 
-		dev_dbg(rtd->dev, "pfn i %i idx %d pfn %x\n", i, idx, pfn);
+		dev_dbg(rtd->dev, "pfn i %u idx %u pfn %x\n", i, idx, pfn);
 
 		pg_table = (u32 *)(pdata->dmab[pcm][stream].area + idx);
 
@@ -388,7 +389,7 @@ static int hsw_pcm_hw_params(struct snd_pcm_substream *substream,
 	rate = params_rate(params);
 	ret = sst_hsw_stream_set_rate(hsw, pcm_data->stream, rate);
 	if (ret < 0) {
-		dev_err(rtd->dev, "error: could not set rate %d\n", rate);
+		dev_err(rtd->dev, "error: could not set rate %u\n", rate);
 		return ret;
 	}
 
@@ -417,14 +418,14 @@ static int hsw_pcm_hw_params(struct snd_pcm_substream *substream,
 
 	ret = sst_hsw_stream_set_bits(hsw, pcm_data->stream, bits);
 	if (ret < 0) {
-		dev_err(rtd->dev, "error: could not set bits %d\n", bits);
+		dev_err(rtd->dev, "error: could not set bits %u\n", bits);
 		return ret;
 	}
 
 	/* we only support stereo atm */
 	channels = params_channels(params);
 	if (channels != 2) {
-		dev_err(rtd->dev, "error: invalid channels %d\n", channels);
+		dev_err(rtd->dev, "error: invalid channels %u\n", channels);
 		return -EINVAL;
 	}
 
@@ -434,14 +435,14 @@ static int hsw_pcm_hw_params(struct snd_pcm_substream *substream,
 
 	ret = sst_hsw_stream_set_channels(hsw, pcm_data->stream, channels);
 	if (ret < 0) {
-		dev_err(rtd->dev, "error: could not set channels %d\n",
+		dev_err(rtd->dev, "error: could not set channels %u\n",
 			channels);
 		return ret;
 	}
 
 	ret = snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(params));
 	if (ret < 0) {
-		dev_err(rtd->dev, "error: could not allocate %d bytes for PCM %d\n",
+		dev_err(rtd->dev, "error: could not allocate %u bytes for PCM %d\n",
 			params_buffer_bytes(params), ret);
 		return ret;
 	}
@@ -558,7 +559,7 @@ static u32 hsw_notify_pointer(struct sst_hsw_stream *stream, void *data)
 	pos = frames_to_bytes(runtime,
 		(runtime->control->appl_ptr % runtime->buffer_size));
 
-	dev_dbg(rtd->dev, "PCM: App pointer %d bytes\n", pos);
+	dev_dbg(rtd->dev, "PCM: App pointer %u bytes\n", pos);
 
 	/* let alsa know we have play a period */
 	snd_pcm_period_elapsed(substream);
@@ -580,7 +581,7 @@ static snd_pcm_uframes_t hsw_pcm_pointer(struct snd_pcm_substream *substream)
 	offset = bytes_to_frames(runtime, position);
 	ppos = sst_hsw_get_dsp_presentation_position(hsw, pcm_data->stream);
 
-	dev_dbg(rtd->dev, "PCM: DMA pointer %du bytes, pos %llu\n",
+	dev_dbg(rtd->dev, "PCM: DMA pointer %u bytes, pos %llu\n",
 		position, ppos);
 	return offset;
 }
-- 
2.1.3


