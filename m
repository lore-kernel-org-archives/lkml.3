Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3BANL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:11:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:45059 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458Ab3BANL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:11:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 49/89] ASoC: arizona: Use actual rather than desired BCLK when calculating LRCLK
Date: Fri,  1 Feb 2013 14:08:04 +0100
Message-Id: <20130201130211.030785295@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit b59e0f82aa350e380142353fbd30706092ba6312 upstream.

Otherwise we'll get the wrong LRCLK if we need to pick a higher BCLK than
is required.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/arizona.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -648,7 +648,7 @@ static int arizona_hw_params(struct snd_
 	}
 	sr_val = i;
 
-	lrclk = snd_soc_params_to_bclk(params) / params_rate(params);
+	lrclk = rates[bclk] / params_rate(params);
 
 	arizona_aif_dbg(dai, "BCLK %dHz LRCLK %dHz\n",
 			rates[bclk], rates[bclk] / lrclk);


