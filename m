Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3LBVfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:35:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3LBTGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:06:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.4 05/60] ASoC: ak4642: prevent un-necessary changes to SG_SL1
Date: Mon,  2 Dec 2013 11:05:46 -0800
Message-Id: <20131202190331.378588706@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Edworthy <phil.edworthy@renesas.com>

commit 7b5bfb82882b9b1c8423ce0ed6852ca3762d967a upstream.

If you record the sound during playback,
the playback sound becomes silent.
Modify so that the codec driver does not clear
SG_SL1::DACL bit which is controlled under widget

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/ak4642.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -262,7 +262,7 @@ static int ak4642_dai_startup(struct snd
 		 * This operation came from example code of
 		 * "ASAHI KASEI AK4642" (japanese) manual p94.
 		 */
-		snd_soc_write(codec, SG_SL1, PMMP | MGAIN0);
+		snd_soc_update_bits(codec, SG_SL1, PMMP | MGAIN0, PMMP | MGAIN0);
 		snd_soc_write(codec, TIMER, ZTM(0x3) | WTM(0x3));
 		snd_soc_write(codec, ALC_CTL1, ALC | LMTH0);
 		snd_soc_update_bits(codec, PW_MGMT1, PMADL, PMADL);


