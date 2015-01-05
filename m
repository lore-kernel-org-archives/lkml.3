Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbbAEJU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:20:58 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32455 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbbAEJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:18:40 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ef-54aa56f03d2c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 7/8] ASoC: wm8988: Constify struct regmap_config and
 snd_soc_codec_driver
Date: Mon, 05 Jan 2015 10:18:27 +0100
Message-id: <1420449508-10701-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4Zd0PYatCDG6+ULG4cvEQk8XUh0/Y
	LF6/MLT4dqWDyeLyrjlsFsvf/mez6NzVz2rxcvMbJgcOjw2fm9g8ds66y+6xaVUnm8fLib/Z
	PPa9Xcbm0bdlFaPH5tPVHp83yQVwRHHZpKTmZJalFunbJXBlTJz7m6ngGGfFqVe5DYytHF2M
	nBwSAiYSrdtnM0HYYhIX7q1n62Lk4BASWMoo8QgozAVk9jFJdHaeA6thEzCW2Lx8CRuILSJw
	nFHiwzMPEJtZIELi5pIHLCC2sEC0xI9pPSwgc1gEVCV2/wkEMXkF3CUOrmGD2CQncfLYZFYQ
	m1PAQ+LNzKlgcSGgkq5J3SwTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJuK87
	GJceszrEKMDBqMTD63FiZYgQa2JZcWXuIUYJDmYlEd51t4BCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGHevS1Iss3oe/e3ISaNDpk+db/VJHVLYejj9A+eCK7umGq3xMA/y5ylnCm0u+7Ga01il
	YWrGn0h77zDRn//OzVrfvGZe8quVtTysbhu9Zl/NerVUf7+d2rIiB+PObjat/6WmFyfO2jpp
	rsvls399HYp7/FI9Uu9yT62vuWz25ZaS895u3Qluu5VYijMSDbWYi4oTAYom7qcWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make struct
snd_soc_codec_driver const as well (snd_soc_register_codec() accepts
pointer to const).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: patches@opensource.wolfsonmicro.com
---
 sound/soc/codecs/wm8988.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index e418199155a8..d320c5251856 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -813,7 +813,7 @@ static int wm8988_probe(struct snd_soc_codec *codec)
 	return 0;
 }
 
-static struct snd_soc_codec_driver soc_codec_dev_wm8988 = {
+static const struct snd_soc_codec_driver soc_codec_dev_wm8988 = {
 	.probe =	wm8988_probe,
 	.set_bias_level = wm8988_set_bias_level,
 	.suspend_bias_off = true,
@@ -826,7 +826,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8988 = {
 	.num_dapm_routes = ARRAY_SIZE(wm8988_dapm_routes),
 };
 
-static struct regmap_config wm8988_regmap = {
+static const struct regmap_config wm8988_regmap = {
 	.reg_bits = 7,
 	.val_bits = 9,
 
-- 
1.9.1

