Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbaCDVLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:11:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbaCDUDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 091/172] ASoC: wm8770: Fix wrong number of enum items
Date: Tue,  4 Mar 2014 12:02:55 -0800
Message-Id: <20140304200302.625757655@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 7a6c0a58dc824523966f212c76322d47c5b0e6fe upstream.

wm8770 codec driver defines ain_enum with a wrong number of items.

Use SOC_ENUM_DOUBLE_DECL() macro and it's automatically fixed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8770.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8770.c
+++ b/sound/soc/codecs/wm8770.c
@@ -196,8 +196,8 @@ static const char *ain_text[] = {
 	"AIN5", "AIN6", "AIN7", "AIN8"
 };
 
-static const struct soc_enum ain_enum =
-	SOC_ENUM_DOUBLE(WM8770_ADCMUX, 0, 4, 8, ain_text);
+static SOC_ENUM_DOUBLE_DECL(ain_enum,
+			    WM8770_ADCMUX, 0, 4, ain_text);
 
 static const struct snd_kcontrol_new ain_mux =
 	SOC_DAPM_ENUM("Capture Mux", ain_enum);


