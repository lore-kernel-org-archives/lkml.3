Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbbAEJSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:18:43 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32455 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbbAEJSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:18:39 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e3-54aa56ee6373
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>
Subject: [PATCH 2/8] ASoC: cs35l32: Constify struct regmap_config and
 snd_soc_codec_driver
Date: Mon, 05 Jan 2015 10:18:22 +0100
Message-id: <1420449508-10701-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Zd13YatCDB60SFtcuXiIyaLv+Hxm
	i6kPn7BZvH5haPHtSgeTxeVdc9gs+hb+ZrLo3NXPavFy8xsmB06PDZ+b2Dx6J95i8dg56y67
	x6ZVnWwe+94uY/Po27KK0WPz6WqPz5vkAjiiuGxSUnMyy1KL9O0SuDKOvHvOXtDPVbH08A+2
	BsYjHF2MnBwSAiYSJyZeZoWwxSQu3FvP1sXIxSEksJRR4tLVVmYIp49J4uzMT2BVbALGEpuX
	L2EDsUUEjjNKfHjmAVLELNDJKHF6x1WwImGBGInemTtZQGwWAVWJ1lkfmUBsXgF3ic1LLzBD
	rJOTOHlsMlg9p4CHxJuZU8GGCgHVdE3qZpnAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5y
	fu4mRkgYft3BuPSY1SFGAQ5GJR5ejxMrQ4RYE8uKK3MPMUpwMCuJ8K67BRTiTUmsrEotyo8v
	Ks1JLT7EyMTBKdXAeHHRpIwXicwa21y+LJv4xe+wYpHTiolnHVkY58h9DeMtbXly+fGsXay2
	GcUlsoueh3qkfGjlP5c6s/rAFtW2qwvyFt1l6xCZe7MtRU5W8vPxGI6Kl08TivjFGmqTeaKu
	ZeonPKhqOKOnvrFC+/PmxczMa1MXtzjxfnbO4Z8S+JRLm/W59eswJZbijERDLeai4kQASnZK
	fiECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make struct
snd_soc_codec_driver const as well (snd_soc_register_codec() accepts
pointer to const).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Brian Austin <brian.austin@cirrus.com>
Cc: Paul Handrigan <Paul.Handrigan@cirrus.com>
---
 sound/soc/codecs/cs35l32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs35l32.c b/sound/soc/codecs/cs35l32.c
index ec55c590afd0..f2b8aad21274 100644
--- a/sound/soc/codecs/cs35l32.c
+++ b/sound/soc/codecs/cs35l32.c
@@ -264,7 +264,7 @@ static int cs35l32_codec_set_sysclk(struct snd_soc_codec *codec,
 			CS35L32_MCLK_DIV2_MASK | CS35L32_MCLK_RATIO_MASK, val);
 }
 
-static struct snd_soc_codec_driver soc_codec_dev_cs35l32 = {
+static const struct snd_soc_codec_driver soc_codec_dev_cs35l32 = {
 	.set_sysclk = cs35l32_codec_set_sysclk,
 
 	.dapm_widgets = cs35l32_dapm_widgets,
@@ -288,7 +288,7 @@ static const struct reg_default cs35l32_monitor_patch[] = {
 	{ 0x00, 0x00 },
 };
 
-static struct regmap_config cs35l32_regmap = {
+static const struct regmap_config cs35l32_regmap = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-- 
1.9.1

