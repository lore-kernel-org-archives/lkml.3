Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbbACJqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 04:46:44 -0500
Received: from [42.120.134.194] ([42.120.134.194]:12633 "EHLO
	out1134-194.mail.aliyun.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbbACJqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 04:46:42 -0500
X-Greylist: delayed 155885 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jan 2015 04:46:41 EST
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.283534|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r41g03009;MF=gang.chen@sunrus.com.cn;PH=DS;RN=6;RT=6;SR=0;
Message-ID: <54A7BA55.3020607@sunrus.com.cn>
Date: Sat, 03 Jan 2015 17:45:57 +0800
From: Chen Gang <gang.chen@sunrus.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sound: soc: soc-pcm: Remove useless varialbe 'i'
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'i' is useless in soc_pcm_set_msb(), so remove it, the related warning
(with allmodconfig under s390):

    CC [M]  sound/soc/soc-pcm.o
  sound/soc/soc-pcm.c: In function 'soc_pcm_set_msb':
  sound/soc/soc-pcm.c:307:11: warning: unused variable 'i' [-Wunused-variable]
    int ret, i;
             ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 sound/soc/soc-pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index d6e8d6b..6b0136e 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -304,7 +304,7 @@ static bool soc_pcm_has_symmetry(struct snd_pcm_substream *substream)
 static void soc_pcm_set_msb(struct snd_pcm_substream *substream, int bits)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	int ret, i;
+	int ret;
 
 	if (!bits)
 		return;
-- 
1.7.9.5
