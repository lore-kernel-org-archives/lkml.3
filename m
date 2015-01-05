Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbbAEJW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:22:59 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40650 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbbAEJSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:18:39 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e6-54aa56eedf70
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>
Subject: [PATCH 3/8] ASoC: cs42l52: Constify struct regmap_config and
 snd_soc_codec_driver
Date: Mon, 05 Jan 2015 10:18:23 +0100
Message-id: <1420449508-10701-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Zd13YatCDD5uN7W4cvEQk0Xf8fnM
	FlMfPmGzeP3C0OLblQ4mi8u75rBZ9C38zWTRuauf1eLl5jdMDpweGz43sXn0TrzF4rFz1l12
	j02rOtk89r1dxubRt2UVo8fm09UenzfJBXBEcdmkpOZklqUW6dslcGVcOLCIqeAmZ0XLzh62
	BsbJHF2MnBwSAiYSy3e2MUHYYhIX7q1n62Lk4hASWMooseTcSiinj0ni7MxPrCBVbALGEpuX
	L2EDsUUEjjNKfHjmAVLELNDJKHF6x1WwImGBGIk3U+eD2SwCqhI3l7wFs3kF3CXeLFoMtU5O
	4uSxyWBxTgEPiTczp4INFQKq6ZrUzTKBkXcBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxN
	jJAw/LqDcekxq0OMAhyMSjy8HidWhgixJpYVV+YeYpTgYFYS4V13CyjEm5JYWZValB9fVJqT
	WnyIkYmDU6qB0TXA88eShBvMgb+EjqRNu8Ac92mjVEA8T96Vxv69GmeUGrY+01rulWnyrlOO
	f4eNWNIZo9qcJj7lfze8JbwsHeKUz/T8Z5jDeH3jv84LuvNd5OQc3ZL/M51zq5PofNm08eFm
	RSsVNrbJ9y+Hszbre000eHSoitF4V6f3/OUWhzmUby0TfNqlxFKckWioxVxUnAgAqgxhICEC	AAA=
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
 sound/soc/codecs/cs42l52.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 35fbef743fbe..1589e7a881d8 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -1103,7 +1103,7 @@ static int cs42l52_remove(struct snd_soc_codec *codec)
 	return 0;
 }
 
-static struct snd_soc_codec_driver soc_codec_dev_cs42l52 = {
+static const struct snd_soc_codec_driver soc_codec_dev_cs42l52 = {
 	.probe = cs42l52_probe,
 	.remove = cs42l52_remove,
 	.set_bias_level = cs42l52_set_bias_level,
@@ -1130,7 +1130,7 @@ static const struct reg_default cs42l52_threshold_patch[] = {
 
 };
 
-static struct regmap_config cs42l52_regmap = {
+static const struct regmap_config cs42l52_regmap = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-- 
1.9.1

