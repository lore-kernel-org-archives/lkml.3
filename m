Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3BCPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:25:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34083 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab3BCOyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:50 -0500
Message-Id: <20130203144645.531819359@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 017/128] ASoC: wm2000: Fix sense of speech clarity enable
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 267f8fa2e1eef0612b2007e1f1846bcbc35cc1fa upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm2000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index 1cbe88f..12bcae6 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -209,9 +209,9 @@ static int wm2000_power_up(struct i2c_client *i2c, int analogue)
 
 	ret = wm2000_read(i2c, WM2000_REG_SPEECH_CLARITY);
 	if (wm2000->speech_clarity)
-		ret &= ~WM2000_SPEECH_CLARITY;
-	else
 		ret |= WM2000_SPEECH_CLARITY;
+	else
+		ret &= ~WM2000_SPEECH_CLARITY;
 	wm2000_write(i2c, WM2000_REG_SPEECH_CLARITY, ret);
 
 	wm2000_write(i2c, WM2000_REG_SYS_START0, 0x33);


