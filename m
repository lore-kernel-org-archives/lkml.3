Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaFXPzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:55:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbaFXPzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:55:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 51/68] ASoC: tlv320aci3x: Fix custom snd_soc_dapm_put_volsw_aic3x() function
Date: Tue, 24 Jun 2014 11:51:10 -0400
Message-Id: <20140624154726.261782760@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit e6c111fac4464e3f4bf7b3802b517dafc80f8e0f upstream.

For some unknown reason the parameters for snd_soc_test_bits() were in wrong
order:
It was:
snd_soc_test_bits(codec, val, mask, reg); /* WRONG!!! */
while it should be:
snd_soc_test_bits(codec, reg, mask, val);

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320aic3x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -169,7 +169,7 @@ static int snd_soc_dapm_put_volsw_aic3x(
 	mask <<= shift;
 	val <<= shift;
 
-	change = snd_soc_test_bits(codec, val, mask, reg);
+	change = snd_soc_test_bits(codec, reg, mask, val);
 	if (change) {
 		update.kcontrol = kcontrol;
 		update.reg = reg;


