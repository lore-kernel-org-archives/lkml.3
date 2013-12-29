Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3L2Cmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:42:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55345 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393Ab3L2CKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:31 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@linaro.org>,
        "Charles Keepax" <ckeepax@opensource.wolfsonmicro.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.67769133@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 089/185] ASoC: wm8990: Mark the register map as dirty
 when powering down
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 2ab2b74277a86afe0dd92976db695a2bb8b93366 upstream.

Otherwise we'll skip sync on resume.

Signed-off-by: Mark Brown <broonie@linaro.org>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8990.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -1266,6 +1266,8 @@ static int wm8990_set_bias_level(struct
 
 		/* disable POBCTRL, SOFT_ST and BUFDCOPEN */
 		snd_soc_write(codec, WM8990_ANTIPOP2, 0x0);
+
+		codec->cache_sync = 1;
 		break;
 	}
 

