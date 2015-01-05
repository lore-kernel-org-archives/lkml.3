Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbbAEJW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:22:58 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33449 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbbAEJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:18:40 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e7-54aa56efb4cb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>
Subject: [PATCH 4/8] ASoC: cs42l56: Constify struct regmap_config and
 snd_soc_codec_driver
Date: Mon, 05 Jan 2015 10:18:24 +0100
Message-id: <1420449508-10701-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Zd33YatCDJrmiVhcuXiIyaLv+Hxm
	i6kPn7BZvH5haPHtSgeTxeVdc9gs+hb+ZrLo3NXPavFy8xsmB06PDZ+b2Dx6J95i8dg56y67
	x6ZVnWwe+94uY/Po27KK0WPz6WqPz5vkAjiiuGxSUnMyy1KL9O0SuDLWb//GUtDFVbFz8nzG
	BsZDHF2MnBwSAiYSbY96mSFsMYkL99azgdhCAksZJQ6d9u9i5AKy+5gkzs78xAqSYBMwlti8
	fAlYkYjAcUaJD888QIqYBToZJU7vuApWJCwQI7Hzy36gIg4OFgFViS/Tg0HCvALuEvNeToZa
	Jidx8thksHJOAQ+JNzOnQi12l+ia1M0ygZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95Pzc
	TYyQEPy6g3HpMatDjAIcjEo8vB4nVoYIsSaWFVfmHmKU4GBWEuFddwsoxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgZGj0zJOjnP5jjWfzdf+PbQzxqB/budCjrW1PVPSF+XtPHra8kXyRfe7Kd/T
	tp0LOr6g6/jiM5+m5Np9bmAw69kfxrZvzsXDm/JSxXL+uX2T+LQuc/aBd3KZcaabk+eHiWzd
	O8n+dXipYuwtOzVH35COfYVlW3+X2DQZXn2Y5eGUo2zOwBS8dJUSS3FGoqEWc1FxIgBLYvuL
	HwIAAA==
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
 sound/soc/codecs/cs42l56.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 2ddc7ac10ad7..cbc654fe48c7 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -1164,7 +1164,7 @@ static int cs42l56_remove(struct snd_soc_codec *codec)
 	return 0;
 }
 
-static struct snd_soc_codec_driver soc_codec_dev_cs42l56 = {
+static const struct snd_soc_codec_driver soc_codec_dev_cs42l56 = {
 	.probe = cs42l56_probe,
 	.remove = cs42l56_remove,
 	.set_bias_level = cs42l56_set_bias_level,
@@ -1179,7 +1179,7 @@ static struct snd_soc_codec_driver soc_codec_dev_cs42l56 = {
 	.num_controls = ARRAY_SIZE(cs42l56_snd_controls),
 };
 
-static struct regmap_config cs42l56_regmap = {
+static const struct regmap_config cs42l56_regmap = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-- 
1.9.1

