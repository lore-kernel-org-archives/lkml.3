Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233Ab3DRDNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:13:02 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51523 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965101Ab3DRDNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:13:00 -0400
MIME-Version: 1.0
Date: Thu, 18 Apr 2013 11:12:59 +0800
Message-ID: <CAPgLHd-rk5P19xq8RgPALbQP7Wkf6FkmLm=koKW1d_1ejpF4Zg@mail.gmail.com>
Subject: [PATCH -next] ALSA: hda - fix error return code in patch_alc662()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: perex@perex.cz, tiwai@suse.de, david.henningsson@canonical.com,
        kailang@realtek.com
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/pci/hda/patch_realtek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f15c36b..a3965b0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3787,7 +3787,8 @@ static int patch_alc662(struct hda_codec *codec)
 	if ((alc_get_coef0(codec) & (1 << 14)) &&
 	    codec->bus->pci->subsystem_vendor == 0x1025 &&
 	    spec->cdefine.platform_type == 1) {
-		if (alc_codec_rename(codec, "ALC272X") < 0)
+		err = alc_codec_rename(codec, "ALC272X");
+		if (err < 0)
 			goto error;
 	}
 

