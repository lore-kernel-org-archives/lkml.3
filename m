Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaGEMkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:40:10 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52319 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaGEMkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:40:09 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jyri Sarha <jsarha@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: omap2: dss: hdmi5_core.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:41:24 +0200
Message-Id: <1404564084-21109-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/omap2/dss/hdmi5_core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/omap2/dss/hdmi5_core.c b/drivers/video/fbdev/omap2/dss/hdmi5_core.c
index 7528c7a..3975e83 100644
--- a/drivers/video/fbdev/omap2/dss/hdmi5_core.c
+++ b/drivers/video/fbdev/omap2/dss/hdmi5_core.c
@@ -142,7 +142,6 @@ static int hdmi_core_ddc_edid(struct hdmi_core_data *core, u8 *pedid, u8 ext)
 {
 	void __iomem *base = core->base;
 	u8 cur_addr;
-	char checksum = 0;
 	const int retries = 1000;
 	u8 seg_ptr = ext / 2;
 	u8 edidbase = ((ext % 2) * 0x80);
@@ -191,7 +190,6 @@ static int hdmi_core_ddc_edid(struct hdmi_core_data *core, u8 *pedid, u8 ext)
 		}
 
 		pedid[cur_addr] = REG_GET(base, HDMI_CORE_I2CM_DATAI, 7, 0);
-		checksum += pedid[cur_addr];
 	}
 
 	return 0;
@@ -810,7 +808,7 @@ int hdmi5_audio_config(struct hdmi_core_data *core, struct hdmi_wp_data *wp,
 	struct hdmi_audio_format audio_format;
 	struct hdmi_audio_dma audio_dma;
 	struct hdmi_core_audio_config core_cfg;
-	int err, n, cts, channel_count;
+	int n, cts, channel_count;
 	unsigned int fs_nr;
 	bool word_length_16b = false;
 
@@ -853,7 +851,7 @@ int hdmi5_audio_config(struct hdmi_core_data *core, struct hdmi_wp_data *wp,
 		return -EINVAL;
 	}
 
-	err = hdmi_compute_acr(pclk, fs_nr, &n, &cts);
+	hdmi_compute_acr(pclk, fs_nr, &n, &cts);
 	core_cfg.n = n;
 	core_cfg.cts = cts;
 
-- 
1.7.10.4

