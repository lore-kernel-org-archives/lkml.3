Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935342AbaBDVhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:37:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934562AbaBDVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 082/140] ASoC: tlv320aic32x4: Fix regmap range_min
Date: Tue,  4 Feb 2014 13:11:09 -0800
Message-Id: <20140204211039.309473709@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit e8e08c521dc101cf7e7e1caf4f487f9fe11a9a7a upstream.

range_min is the lowest address in the virtual register range. This is
the first register with address 0, not the first register of page 1.

Currently all writes to page 1 are mapped to page 0, so the codec fails
to operate.

Fixes: 4d208ca429ad (ASoC: tlv320aic32x4: Convert to direct regmap API usage)
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320aic32x4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -267,7 +267,7 @@ static const struct regmap_range_cfg aic
 		.selector_mask  = 0xff,
 		.window_start = 0,
 		.window_len = 128,
-		.range_min = AIC32X4_PAGE1,
+		.range_min = 0,
 		.range_max = AIC32X4_RMICPGAVOL,
 	},
 };


