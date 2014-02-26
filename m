Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaBZOyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:54:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34191 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbaBZOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:54:14 -0500
Date: Wed, 26 Feb 2014 14:54:08 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: vinod.koul@intel.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, broonie@linaro.org
Subject: [PATCH 1/1] ALSA: compress: no need to set metadata before next
	track
Message-ID: <20140226145408.GA2672@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The metadata is mainly for MP3 gapless playback, since
the MP3 audio stream does not contain enough information
to enable gapless. Other audio formats do not necessarily
require any additional metadata so we should allow next_track
to be called without any metadata.

Signed-off-by: Zhao Weijia <weijia.zhao@capelabs.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 sound/core/compress_offload.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 7a20897..5a351c7 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -744,12 +744,6 @@ static int snd_compr_next_track(struct snd_compr_stream *stream)
 	if (stream->runtime->state != SNDRV_PCM_STATE_RUNNING)
 		return -EPERM;
 
-	/* you can signal next track isf this is intended to be a gapless stream
-	 * and current track metadata is set
-	 */
-	if (stream->metadata_set == false)
-		return -EPERM;
-
 	retval = stream->ops->trigger(stream, SND_COMPR_TRIGGER_NEXT_TRACK);
 	if (retval != 0)
 		return retval;
-- 
1.7.2.5

