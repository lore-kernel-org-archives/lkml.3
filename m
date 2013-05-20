Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3ETKwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55979 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3ETKwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dylan Reid <dgreid@chromium.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 015/115] ASoC: max98088: Fix logging of hardware revision.
Date: Mon, 20 May 2013 11:50:15 +0100
Message-Id: <1369047116-9378-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit 98682063549bedd6e2d2b6b7222f150c6fbce68c upstream.

The hardware revision of the codec is based at 0x40.  Subtract that
before convering to ASCII.  The same as it is done for 98095.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/max98088.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index af7324b..4790568 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -2006,7 +2006,7 @@ static int max98088_probe(struct snd_soc_codec *codec)
                        ret);
                goto err_access;
        }
-       dev_info(codec->dev, "revision %c\n", ret + 'A');
+       dev_info(codec->dev, "revision %c\n", ret - 0x40 + 'A');
 
        snd_soc_write(codec, M98088_REG_51_PWR_SYS, M98088_PWRSV);
 
-- 
1.8.1.2

