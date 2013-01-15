Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3AOWcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:42812 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab3AOWc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Patrick Lai <plai@codeaurora.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 130/221] ASoC: pcm: allow backend hardware to be freed in pause state
Date: Tue, 15 Jan 2013 10:50:57 -0800
Message-Id: <20130115185007.420814211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Lai <plai@codeaurora.org>

commit 08b27848da620f206a8b6d80f26184485dd7aa40 upstream.

When front-end PCM session is in paused state, back-end
PCM session will be put in paused state as well if given
front-end PCM session is the only client of given back-end.
Then, application closes front-end PCM session, DPCM
framework will not allow back-end enters HW_FREE state
so back-end will never get shutdown completely.

Signed-off-by: Patrick Lai <plai@codeaurora.org>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1240,6 +1240,7 @@ static int dpcm_be_dai_hw_free(struct sn
 		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PREPARE) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE) &&
+		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP))
 			continue;
 


