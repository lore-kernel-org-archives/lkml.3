Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3AOWcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:42693 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376Ab3AOWcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 124/221] ASoC: arizona: Do proper shift for setting AIF rate
Date: Tue, 15 Jan 2013 10:50:51 -0800
Message-Id: <20130115185006.981143990@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 7110a287ff2b1f3780905d1686a1a4edccb95133 upstream.

ARIZONA_AIF1_RATE_MASK is 0x7800 /* AIF1_RATE - [14:11] */
Thus we need left shift ARIZONA_AIF1_RATE_SHIFT when setting aif1 rate.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/arizona.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -677,7 +677,8 @@ static int arizona_hw_params(struct snd_
 		snd_soc_update_bits(codec, ARIZONA_ASYNC_SAMPLE_RATE_1,
 				    ARIZONA_ASYNC_SAMPLE_RATE_MASK, sr_val);
 		snd_soc_update_bits(codec, base + ARIZONA_AIF_RATE_CTRL,
-				    ARIZONA_AIF1_RATE_MASK, 8);
+				    ARIZONA_AIF1_RATE_MASK,
+				    8 << ARIZONA_AIF1_RATE_SHIFT);
 		break;
 	default:
 		arizona_aif_err(dai, "Invalid clock %d\n", dai_priv->clk);


