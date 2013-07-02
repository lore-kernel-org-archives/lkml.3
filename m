Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab3GBJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:26:24 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:35912 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab3GBJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:26:23 -0400
MIME-Version: 1.0
Date: Tue, 2 Jul 2013 17:26:21 +0800
Message-ID: <CAPgLHd-VN4BiM=cEkFF4EgbL7iqR1XrhEzBiKyoJBVnzKspHJg@mail.gmail.com>
Subject: [PATCH] ASoC: brownstone: add .owner to struct snd_soc_card
From: Wei Yongjun <weiyj.lk@gmail.com>
To: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add missing .owner of struct snd_soc_card. This prevents the
module from being removed from underneath its users.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/pxa/brownstone.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/pxa/brownstone.c b/sound/soc/pxa/brownstone.c
index 4ad7609..e582c05 100644
--- a/sound/soc/pxa/brownstone.c
+++ b/sound/soc/pxa/brownstone.c
@@ -129,6 +129,7 @@ static struct snd_soc_dai_link brownstone_wm8994_dai[] = {
 /* audio machine driver */
 static struct snd_soc_card brownstone = {
 	.name         = "brownstone",
+	.owner        = THIS_MODULE,
 	.dai_link     = brownstone_wm8994_dai,
 	.num_links    = ARRAY_SIZE(brownstone_wm8994_dai),
 

