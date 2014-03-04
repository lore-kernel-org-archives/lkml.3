Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbaCDVOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:14:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbaCDUDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 096/172] ASoC: wm8958-dsp: Fix firmware block loading
Date: Tue,  4 Mar 2014 12:03:00 -0800
Message-Id: <20140304200302.784030301@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 548da08fc1e245faf9b0d7c41ecd8e07984fc332 upstream.

The codec->control_data contains a pointer to the device's regmap struct. But
wm8994_bulk_write() expects a pointer to the parent wm8998 device.

The issue was introduced in commit d9a7666f ("ASoC: Remove ASoC-specific
WM8994 I/O code").

Fixes: d9a7666f ("ASoC: Remove ASoC-specific WM8994 I/O code")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8958-dsp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8958-dsp2.c
+++ b/sound/soc/codecs/wm8958-dsp2.c
@@ -153,7 +153,7 @@ static int wm8958_dsp2_fw(struct snd_soc
 
 			data32 &= 0xffffff;
 
-			wm8994_bulk_write(codec->control_data,
+			wm8994_bulk_write(wm8994->wm8994,
 					  data32 & 0xffffff,
 					  block_len / 2,
 					  (void *)(data + 8));


