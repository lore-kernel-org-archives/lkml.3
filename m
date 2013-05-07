Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab3EGLiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:38:55 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:48975 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab3EGLiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:38:54 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 19:38:52 +0800
Message-ID: <CAPgLHd-5rAbUnijs_dfeXuk9LhsSKihOBYeicLWDvZECfP0LmA@mail.gmail.com>
Subject: [PATCH] ASoC: wm0010: fix error return code in wm0010_boot()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: broonie@opensource.wolfsonmicro.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the memory malloc of 'out' and 'img_swap' error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/codecs/wm0010.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm0010.c b/sound/soc/codecs/wm0010.c
index 8df2b6e..370af0c 100644
--- a/sound/soc/codecs/wm0010.c
+++ b/sound/soc/codecs/wm0010.c
@@ -667,6 +667,7 @@ static int wm0010_boot(struct snd_soc_codec *codec)
 		/* On wm0010 only the CLKCTRL1 value is used */
 		pll_rec.clkctrl1 = wm0010->pll_clkctrl1;
 
+		ret = -ENOMEM;
 		len = pll_rec.length + 8;
 		out = kzalloc(len, GFP_KERNEL);
 		if (!out) {

