Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3LBTRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:17:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3LBTQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 019/212] ASoC: ak4642: prevent un-necessary changes to SG_SL1
Date: Mon,  2 Dec 2013 11:13:30 -0800
Message-Id: <20131202191250.832802261@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -257,7 +257,7 @@ static int ak4642_dai_startup(struct snd
 		 * This operation came from example code of
 		 * "ASAHI KASEI AK4642" (japanese) manual p94.
 		 */
-		snd_soc_write(codec, SG_SL1, PMMP | MGAIN0);
+		snd_soc_update_bits(codec, SG_SL1, PMMP | MGAIN0, PMMP | MGAIN0);
 		snd_soc_write(codec, TIMER, ZTM(0x3) | WTM(0x3));
 		snd_soc_write(codec, ALC_CTL1, ALC | LMTH0);
 		snd_soc_update_bits(codec, PW_MGMT1, PMADL, PMADL);


