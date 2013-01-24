Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3AXDnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:43:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3AXD2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 19/74] ASoC: wm2000: Fix sense of speech clarity enable
Date: Thu, 24 Jan 2013 01:26:31 -0200
Message-Id: <1358998046-613-20-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 267f8fa2e1eef0612b2007e1f1846bcbc35cc1fa upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/wm2000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index 45f2faf..baa9752 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -188,9 +188,9 @@ static int wm2000_power_up(struct i2c_client *i2c, int analogue)
 
 	ret = wm2000_read(i2c, WM2000_REG_SPEECH_CLARITY);
 	if (wm2000->speech_clarity)
-		ret &= ~WM2000_SPEECH_CLARITY;
-	else
 		ret |= WM2000_SPEECH_CLARITY;
+	else
+		ret &= ~WM2000_SPEECH_CLARITY;
 	wm2000_write(i2c, WM2000_REG_SPEECH_CLARITY, ret);
 
 	wm2000_write(i2c, WM2000_REG_SYS_START0, 0x33);
-- 
1.7.9.5

