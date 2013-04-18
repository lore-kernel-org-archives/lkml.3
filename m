Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3DRJ02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:26:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab3DRJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alban Bedel <alban.bedel@avionic-design.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 50/72] ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running
Date: Thu, 18 Apr 2013 10:16:35 +0100
Message-Id: <1366276617-3553-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@avionic-design.de>

commit f1ca493b0b5e8f42d3b2dc8877860db2983f47b6 upstream.

The Charge Pump needs the DSP clock to work properly, without it the
bypass to HP/LINEOUT is not working properly. This requirement is not
mentioned in the datasheet but has been confirmed by Mark Brown from
Wolfson.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm8903.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 86b8a29..8ddfc19 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1082,6 +1082,8 @@ static const struct snd_soc_dapm_route wm8903_intercon[] = {
 	{ "ROP", NULL, "Right Speaker PGA" },
 	{ "RON", NULL, "Right Speaker PGA" },
 
+	{ "Charge Pump", NULL, "CLK_DSP" },
+
 	{ "Left Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Right Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Left Line Output PGA", NULL, "Charge Pump" },
-- 
1.8.1.2

