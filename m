Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355AbaBDVhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:37:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934559AbaBDVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 081/140] ASoC: codec: tlv320aic32x4: Fix regmap range config
Date: Tue,  4 Feb 2014 13:11:08 -0800
Message-Id: <20140204211039.280588127@linuxfoundation.org>
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

commit 6d0d5103bdc45242b8d02e4130fbe5a3ea9f668a upstream.

This codec driver fails to probe because it has a higher regmap
range_max value than max_register. This patch sets the range_max to the
max_register value as described in the for struct regmap_range_cfg:
"@range_max: Address of the highest register in virtual range."

Fixes: 4d208ca429ad (ASoC: tlv320aic32x4: Convert to direct regmap API usage)
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320aic32x4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -268,7 +268,7 @@ static const struct regmap_range_cfg aic
 		.window_start = 0,
 		.window_len = 128,
 		.range_min = AIC32X4_PAGE1,
-		.range_max = AIC32X4_PAGE1 + 127,
+		.range_max = AIC32X4_RMICPGAVOL,
 	},
 };
 


