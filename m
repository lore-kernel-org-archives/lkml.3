Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3LJICx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:02:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3LJICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 24/62] ASoC: dapm: Use SND_SOC_DAPM_INIT_REG_VAL in SND_SOC_DAPM_MUX
Date: Tue, 10 Dec 2013 00:00:55 -0800
Message-Id: <20131210080059.121279723@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit faf6615bf05bc5cecc6e22013b9cb21c77784fd1 upstream.

SND_SOC_DAPM_MUX() doesn't currently initialize the .mask field. This
results in the mux never affecting HW, since no bits are ever set or
cleared. Fix SND_SOC_DAPM_MUX() to use SND_SOC_DAPM_INIT_REG_VAL() to
set up the reg, shift, on_val, and off_val fields like almost all other
SND_SOC_xxx() macros. It looks like this was a "typo" in the fixed
commit linked below.

This makes the speakers on the Toshiba AC100 (PAZ00) laptop work again.

Fixes: de9ba98b6d26 ("ASoC: dapm: Make widget power register settings more flexible")
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/soc-dapm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -104,7 +104,8 @@ struct device;
 	SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), \
 	.kcontrol_news = wcontrols, .num_kcontrols = 1}
 #define SND_SOC_DAPM_MUX(wname, wreg, wshift, winvert, wcontrols) \
-{	.id = snd_soc_dapm_mux, .name = wname, .reg = wreg, \
+{	.id = snd_soc_dapm_mux, .name = wname, \
+	SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), \
 	.kcontrol_news = wcontrols, .num_kcontrols = 1}
 #define SND_SOC_DAPM_VIRT_MUX(wname, wreg, wshift, winvert, wcontrols) \
 {	.id = snd_soc_dapm_virt_mux, .name = wname, \


