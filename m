Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbbAEJTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:19:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32455 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbbAEJSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:18:41 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ef-54aa56ef7280
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 8/8] ASoC: wm8804: Constify struct regmap_config and
 snd_soc_codec_driver
Date: Mon, 05 Jan 2015 10:18:28 +0100
Message-id: <1420449508-10701-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e/4Zd33YatCDBZ9ULe4cvEQk8XUh0/Y
	LF6/MLT4dqWDyeLyrjlsFsvf/mez6NzVz2rxcvMbJgcOjw2fm9g8ds66y+6xaVUnm8fLib/Z
	PPa9Xcbm0bdlFaPH5tPVHp83yQVwRHHZpKTmZJalFunbJXBlXJ77hb3gK3dF67XrLA2MXzm7
	GDk5JARMJI5OvsQGYYtJXLi3Hsjm4hASWMooMX3yNSYIp49JorPzHBNIFZuAscTm5UvAOkQE
	jjNKfHjmAWIzC0RI3FzygAXEFhaIlrh9chsjiM0ioCrx5HgXUJyDg1fAXWL90VSIZXISJ49N
	ZgWxOQU8JN7MnAo2UgiopGtSN8sERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUIC
	78sOxsXHrA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhHfdLaAQb0piZVVqUX58UWlOavEh
	RiYOTqkGxniXvXymvz+qGExxOe/6yrDf9G96zpxl9+vimvazS7rZCJhVhLjfD53/9eoyjYz6
	N0v2bI682Mmy/eqrJnWjveG3nnbvvRTu9sxGx/Fyyc1Lnt3z1FQMOuxmKc4q9N7ZcDHWT/GU
	xOwyxTdhhtE8K2/d/C5vzJgXmSi/onHZbN6dyQuuTNggqMRSnJFoqMVcVJwIAMAMyGUaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make struct
snd_soc_codec_driver (snd_soc_register_codec() accepts pointer to const)
and array of default register values const as well.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: patches@opensource.wolfsonmicro.com
---
 sound/soc/codecs/wm8995.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index c280f0a3a424..120228b6b596 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -44,7 +44,7 @@ static const char *wm8995_supply_names[WM8995_NUM_SUPPLIES] = {
 	"MICVDD"
 };
 
-static struct reg_default wm8995_reg_defaults[] = {
+static const struct reg_default wm8995_reg_defaults[] = {
 	{ 0, 0x8995 },
 	{ 5, 0x0100 },
 	{ 16, 0x000b },
@@ -2190,7 +2190,7 @@ static struct snd_soc_dai_driver wm8995_dai[] = {
 	}
 };
 
-static struct snd_soc_codec_driver soc_codec_dev_wm8995 = {
+static const struct snd_soc_codec_driver soc_codec_dev_wm8995 = {
 	.probe = wm8995_probe,
 	.remove = wm8995_remove,
 	.set_bias_level = wm8995_set_bias_level,
@@ -2204,7 +2204,7 @@ static struct snd_soc_codec_driver soc_codec_dev_wm8995 = {
 	.num_dapm_routes = ARRAY_SIZE(wm8995_intercon),
 };
 
-static struct regmap_config wm8995_regmap = {
+static const struct regmap_config wm8995_regmap = {
 	.reg_bits = 16,
 	.val_bits = 16,
 
-- 
1.9.1

