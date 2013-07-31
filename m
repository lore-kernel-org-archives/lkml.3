Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3GaNge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:36:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47049 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759821Ab3GaN0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@linaro.org>,
        "Dylan Reid" <dgreid@chromium.org>,
        "Chih-Chung Chang" <chihchung@chromium.org>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.809740545@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [44/84] ASoC: max98088 - fix element type of the register cache.
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Chung Chang <chihchung@chromium.org>

commit cb6f66a2d278e57a6c9d8fb59bd9ebd8ab3965c2 upstream.

The registers of max98088 are 8 bits, not 16 bits. This bug causes the
contents of registers to be overwritten with bad values when the codec
is suspended and then resumed.

Signed-off-by: Chih-Chung Chang <chihchung@chromium.org>
Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/max98088.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1595,7 +1595,7 @@ static int max98088_dai2_digital_mute(st
 
 static void max98088_sync_cache(struct snd_soc_codec *codec)
 {
-       u16 *reg_cache = codec->reg_cache;
+       u8 *reg_cache = codec->reg_cache;
        int i;
 
        if (!codec->cache_sync)

