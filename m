Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbbAEJSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:18:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40650 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbbAEJSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:18:38 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-df-54aa56ec7c69
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/8] ASoC: alc5632: Constify struct regmap_config and
 snd_soc_codec_driver
Date: Mon, 05 Jan 2015 10:18:21 +0100
Message-id: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xy7pvwlaFGEzbqW5x5eIhJoupD5+w
	Wbx+YWjx7UoHk8XlXXPYLDp39bNavNz8hsmB3WPD5yY2j52z7rJ7bFrVyeax7+0yNo++LasY
	PTafrvb4vEkugD2KyyYlNSezLLVI3y6BK+PrxcksBTs5K24e28XawPibvYuRg0NCwESip5Gt
	i5ETyBSTuHBvPZDNxSEksJRRYtKVzYwQTh+TxKwLm9lBqtgEjCU2L18C1iEicJxR4sMzDxCb
	WcBQ4ue7P2A1wgIxErs+bmIFsVkEVCV6upaC2bwC7hIPjp5khtgmJ3Hy2GTWCYzcCxgZVjGK
	ppYmFxQnpeca6hUn5haX5qXrJefnbmKEBM2XHYyLj1kdYhTgYFTi4fU4sTJEiDWxrLgy9xCj
	BAezkgjvultAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyROQkmV/bL8d07LFO2mXPZmlnup1hf
	nLPd4x6uv9m7Qd3IPeLGqh0/6yIMqjU2BWtPMGt2nXfMNl4ulS2m8gL3tuPKic1iTYfb+17w
	z0kT43MWuz3jY2CJ3r6rzudfV0780D3bLD7y72rnF7mRy9l/3l8/c87mKpvsZ1MaF8p1CYb6
	eit9a1RiKc5INNRiLipOBAABD13I+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make struct
snd_soc_codec_driver const as well (snd_soc_register_codec() accepts
pointer to const).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 sound/soc/codecs/alc5632.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/alc5632.c b/sound/soc/codecs/alc5632.c
index d1fdbc266631..07630260e1ba 100644
--- a/sound/soc/codecs/alc5632.c
+++ b/sound/soc/codecs/alc5632.c
@@ -1066,7 +1066,7 @@ static int alc5632_probe(struct snd_soc_codec *codec)
 	return 0;
 }
 
-static struct snd_soc_codec_driver soc_codec_device_alc5632 = {
+static const struct snd_soc_codec_driver soc_codec_device_alc5632 = {
 	.probe = alc5632_probe,
 	.resume = alc5632_resume,
 	.set_bias_level = alc5632_set_bias_level,
@@ -1080,7 +1080,7 @@ static struct snd_soc_codec_driver soc_codec_device_alc5632 = {
 	.num_dapm_routes = ARRAY_SIZE(alc5632_dapm_routes),
 };
 
-static struct regmap_config alc5632_regmap = {
+static const struct regmap_config alc5632_regmap = {
 	.reg_bits = 8,
 	.val_bits = 16,
 
-- 
1.9.1

