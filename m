Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbaIOUZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:25:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbaIOThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Qiao Zhou <zhouqiao@marvell.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 052/114] ASoC: pcm: fix dpcm_path_put in dpcm runtime update
Date: Mon, 15 Sep 2014 12:25:52 -0700
Message-Id: <20140915192643.069520855@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiao Zhou <zhouqiao@marvell.com>

commit 7ed9de76ff342cbd717a9cf897044b99272cb8f8 upstream.

we need to release dapm widget list after dpcm_path_get in
soc_dpcm_runtime_update. otherwise, there will be potential memory
leak. add dpcm_path_put to fix it.

Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2011,6 +2011,7 @@ int soc_dpcm_runtime_update(struct snd_s
 			dpcm_be_disconnect(fe, SNDRV_PCM_STREAM_PLAYBACK);
 		}
 
+		dpcm_path_put(&list);
 capture:
 		/* skip if FE doesn't have capture capability */
 		if (!fe->cpu_dai->driver->capture.channels_min)


