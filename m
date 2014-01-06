Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbaAGADX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:03:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaAFWip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 014/144] ASoC: wm8904: fix DSP mode B configuration
Date: Mon,  6 Jan 2014 14:36:15 -0800
Message-Id: <20140106223745.736315041@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Shen <voice.shen@atmel.com>

commit f0199bc5e3a3ec13f9bc938556517ec430b36437 upstream.

When wm8904 work in DSP mode B, we still need to configure it to
work in DSP mode. Or else, it will work in Right Justified mode.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8904.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -1443,7 +1443,7 @@ static int wm8904_set_fmt(struct snd_soc
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_DSP_B:
-		aif1 |= WM8904_AIF_LRCLK_INV;
+		aif1 |= 0x3 | WM8904_AIF_LRCLK_INV;
 	case SND_SOC_DAIFMT_DSP_A:
 		aif1 |= 0x3;
 		break;


