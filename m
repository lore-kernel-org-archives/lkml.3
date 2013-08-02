Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3HBKWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:22:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3HBKWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:22:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chih-Chung Chang <chihchung@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Mark Brown <broonie@linaro.org>
Subject: [ 02/23] ASoC: max98088 - fix element type of the register cache.
Date: Fri,  2 Aug 2013 18:23:15 +0800
Message-Id: <20130802102036.544933493@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802102036.180660415@linuxfoundation.org>
References: <20130802102036.180660415@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Chung Chang <chihchung@chromium.org>

commit cb6f66a2d278e57a6c9d8fb59bd9ebd8ab3965c2 upstream.

The registers of max98088 are 8 bits, not 16 bits. This bug causes the
contents of registers to be overwritten with bad values when the codec
is suspended and then resumed.

Signed-off-by: Chih-Chung Chang <chihchung@chromium.org>
Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98088.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1598,7 +1598,7 @@ static int max98088_dai2_digital_mute(st
 
 static void max98088_sync_cache(struct snd_soc_codec *codec)
 {
-       u16 *reg_cache = codec->reg_cache;
+       u8 *reg_cache = codec->reg_cache;
        int i;
 
        if (!codec->cache_sync)


