Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbbAEJTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:19:30 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33449 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbbAEJSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:18:41 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ec-54aa56f0d369
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 6/8] ASoC: wm8804: Constify struct regmap_config and
 snd_soc_codec_driver
Date: Mon, 05 Jan 2015 10:18:26 +0100
Message-id: <1420449508-10701-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e/4Zd0PYatCDOY85La4cvEQk8XUh0/Y
	LF6/MLT4dqWDyeLyrjlsFsvf/mez6NzVz2rxcvMbJgcOjw2fm9g8ds66y+6xaVUnm8fLib/Z
	PPa9Xcbm0bdlFaPH5tPVHp83yQVwRHHZpKTmZJalFunbJXBlnJ+4nLXgNGdF486DLA2MnRxd
	jJwcEgImEivm/WeEsMUkLtxbz9bFyMUhJLCUUeLE7PUsEE4fk8T+VcdYQarYBIwlNi9fwgZi
	iwgcZ5T48MwDxGYWiJC4ueQBC4gtLBAt8f3LXjCbRUBV4tLe2WC9vALuEq9a5rNAbJOTOHls
	MlicU8BD4s3MqWAzhYBquiZ1s0xg5F3AyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyT0
	vu5gXHrM6hCjAAejEg+vx4mVIUKsiWXFlbmHGCU4mJVEeNfdAgrxpiRWVqUW5ccXleakFh9i
	ZOLglGpgvL3tz81b1062897O91knwZ0u+3mflFrqnBTLOoFJH/y7V0vnCq46Lz2zbO0CH9sH
	/lG3l0wNO3xx1/e048y/ixqf1j1as7FyV+T26xMaHxtdDmRR3mZW/L1/wucbFprdzLaLDrhz
	OipfecWtHpd+TewVG+8LgVXtSzXP2248lcHkmD09Ua/1hxJLcUaioRZzUXEiAAoFatYbAgAA
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
 sound/soc/codecs/wm8804.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
index 1315f7642503..b2b0e68f707e 100644
--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -648,7 +648,7 @@ static struct snd_soc_dai_driver wm8804_dai = {
 	.symmetric_rates = 1
 };
 
-static struct snd_soc_codec_driver soc_codec_dev_wm8804 = {
+static const struct snd_soc_codec_driver soc_codec_dev_wm8804 = {
 	.probe = wm8804_probe,
 	.remove = wm8804_remove,
 	.set_bias_level = wm8804_set_bias_level,
@@ -664,7 +664,7 @@ static const struct of_device_id wm8804_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, wm8804_of_match);
 
-static struct regmap_config wm8804_regmap_config = {
+static const struct regmap_config wm8804_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-- 
1.9.1

