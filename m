Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3CJRex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 13:34:53 -0400
Received: from mail.tpi.com ([70.99.223.143]:1839 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab3CJRew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 13:34:52 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        device-drivers-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: adau1373: adau1373_hw_params: Silence overflow warning
Date: Sun, 10 Mar 2013 11:34:38 -0600
Message-Id: <1362936878-84443-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADAU1373_BCLKDIV_SOURCE is defined as BIT(5) which uses UL constants. On
amd64 the result of the ones complement operator is then truncated to
unsigned int according to the prototype of snd_soc_update_bits(). I think
gcc is correctly warning that the upper 32 bits are lost.

sound/soc/codecs/adau1373.c: In function 'adau1373_hw_params':
sound/soc/codecs/adau1373.c:940:3: warning: large integer implicitly truncated to unsigned type [-Woverflow]

gcc version 4.6.3

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: device-drivers-devel@blackfin.uclinux.org
Cc: alsa-devel@alsa-project.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 sound/soc/codecs/adau1373.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
index 068b3ae..56ed788 100644
--- a/sound/soc/codecs/adau1373.c
+++ b/sound/soc/codecs/adau1373.c
@@ -132,7 +132,7 @@ struct adau1373 {
 #define ADAU1373_DAI_FORMAT_I2S		0x2
 #define ADAU1373_DAI_FORMAT_DSP		0x3
 
-#define ADAU1373_BCLKDIV_SOURCE		BIT(5)
+#define ADAU1373_BCLKDIV_SOURCE		(unsigned int)BIT(5)
 #define ADAU1373_BCLKDIV_32		0x03
 #define ADAU1373_BCLKDIV_64		0x02
 #define ADAU1373_BCLKDIV_128		0x01
-- 
1.7.9.5

