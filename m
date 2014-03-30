Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaC3Xvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:51:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703AbaC3Xno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@linaro.org>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.98126324@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 146/200] ASoC: sta32x: Fix wrong enum for limiter2
 release rate
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b3619b288b621e63f66908045f48495869a996a6 upstream.

There is a typo in the Limiter2 Release Rate control, a wrong enum for
Limiter1 is assigned.  It must point to Limiter2.
Spotted by a compile warning:

In file included from sound/soc/codecs/sta32x.c:34:0:
sound/soc/codecs/sta32x.c:223:29: warning: ‘sta32x_limiter2_release_rate_enum’ defined but not used [-Wunused-variable]
 static SOC_ENUM_SINGLE_DECL(sta32x_limiter2_release_rate_enum,
                             ^
include/sound/soc.h:275:18: note: in definition of macro ‘SOC_ENUM_DOUBLE_DECL’
  struct soc_enum name = SOC_ENUM_DOUBLE(xreg, xshift_l, xshift_r, \
                  ^
sound/soc/codecs/sta32x.c:223:8: note: in expansion of macro ‘SOC_ENUM_SINGLE_DECL’
 static SOC_ENUM_SINGLE_DECL(sta32x_limiter2_release_rate_enum,
        ^

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/sta32x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -350,7 +350,7 @@ SOC_SINGLE_TLV("Treble Tone Control", ST
 SOC_ENUM("Limiter1 Attack Rate (dB/ms)", sta32x_limiter1_attack_rate_enum),
 SOC_ENUM("Limiter2 Attack Rate (dB/ms)", sta32x_limiter2_attack_rate_enum),
 SOC_ENUM("Limiter1 Release Rate (dB/ms)", sta32x_limiter1_release_rate_enum),
-SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter1_release_rate_enum),
+SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter2_release_rate_enum),
 
 /* depending on mode, the attack/release thresholds have
  * two different enum definitions; provide both

