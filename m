Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab3AOXnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:43:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:46082 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235Ab3AOWuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 072/171] ASoC: wm2200: Fix setting dai format in wm2200_set_fmt
Date: Tue, 15 Jan 2013 14:43:57 -0800
Message-Id: <20130115224318.582060055@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 2a5f431592343b78896013b055582f94c12a5049 upstream.

According to the defines in wm2200.h:
/*
 * R1284 (0x504) - Audio IF 1_5
 */

We should not left shift 1 bit for fmt_val when setting dai format.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -1440,7 +1440,7 @@ static int wm2200_set_fmt(struct snd_soc
 			    WM2200_AIF1TX_LRCLK_MSTR | WM2200_AIF1TX_LRCLK_INV,
 			    lrclk);
 	snd_soc_update_bits(codec, WM2200_AUDIO_IF_1_5,
-			    WM2200_AIF1_FMT_MASK << 1, fmt_val << 1);
+			    WM2200_AIF1_FMT_MASK, fmt_val);
 
 	return 0;
 }


