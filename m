Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbbAEJV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:21:58 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32946 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbbAEJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:18:40 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e8-54aa56ee9347
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>
Subject: [PATCH 5/8] ASoC: cs42l73: Constify struct regmap_config and
 snd_soc_codec_driver
Date: Mon, 05 Jan 2015 10:18:25 +0100
Message-id: <1420449508-10701-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Zd13YatCDGa8krS4cvEQk0Xf8fnM
	FlMfPmGzeP3C0OLblQ4mi8u75rBZ9C38zWTRuauf1eLl5jdMDpweGz43sXn0TrzF4rFz1l12
	j02rOtk89r1dxubRt2UVo8fm09UenzfJBXBEcdmkpOZklqUW6dslcGVM2d7OVtDJVfH453P2
	BsaDHF2MnBwSAiYSP5f3s0LYYhIX7q1n62Lk4hASWMooceDhURYIp49JYv+qY2BVbALGEpuX
	L2EDsUUEjjNKfHjmAVLELNDJKHF6x1WgIg4OYYEYid69oSA1LAKqEpd+z2AHsXkF3CX+/L7B
	DLFNTuLksclgMzkFPCTezJwKNlMIqKZrUjfLBEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1
	kvNzNzFCgvDLDsbFx6wOMQpwMCrx8HqcWBkixJpYVlyZe4hRgoNZSYR33S2gEG9KYmVValF+
	fFFpTmrxIUYmDk6pBsY0Dgb5LcJvyk49fc95rSN3elzXlaUs5ksqjBV5D2zoF5UXfDl746so
	3u/+r78+0H1sLHGp9e3aoyLtj89vcnS5dFftC6vByvnsKY0/lb2tFsza/WzCNN6QLPGKt969
	P51Csg5vyNZwUD/73bisfMr6ky5mbzrvbihbGbdU/QnjTOZJstnSEy2VWIozEg21mIuKEwGo
	qY2wIAIAAA==
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
 sound/soc/codecs/cs42l73.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l73.c b/sound/soc/codecs/cs42l73.c
index 7c55537c69cf..8ecedba79606 100644
--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -1347,7 +1347,7 @@ static int cs42l73_probe(struct snd_soc_codec *codec)
 	return 0;
 }
 
-static struct snd_soc_codec_driver soc_codec_dev_cs42l73 = {
+static const struct snd_soc_codec_driver soc_codec_dev_cs42l73 = {
 	.probe = cs42l73_probe,
 	.set_bias_level = cs42l73_set_bias_level,
 	.suspend_bias_off = true,
@@ -1361,7 +1361,7 @@ static struct snd_soc_codec_driver soc_codec_dev_cs42l73 = {
 	.num_controls = ARRAY_SIZE(cs42l73_snd_controls),
 };
 
-static struct regmap_config cs42l73_regmap = {
+static const struct regmap_config cs42l73_regmap = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-- 
1.9.1

