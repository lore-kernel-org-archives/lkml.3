Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbbADNO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:14:58 -0500
Received: from mout.web.de ([212.227.15.3]:59724 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbADNO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:14:56 -0500
Message-ID: <54A93CBD.7090905@users.sourceforge.net>
Date: Sun, 04 Jan 2015 14:14:37 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 8/13] ASoC: Intel: Delete an unnecessary check before the
 function call "release_firmware"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:29sOIITjqwS++VcWGcmcZxIzPP9xpTNHct/e++oAAQpodHjxhfZ
 VP7+zUioQa4jNH0+RT5kUopnexZ1MUaWDuVHbZt9EXKZEoYM2XbiNQ+7KYIh/YTqIgcEnMo
 shwyK97gvVWYvvOoBzNczcdDqaDHkdl1P3PsLSNUA6W6hzIGN/VoLmgLgLSk5nccTxxfzZr
 FpKzMLv1WFXm7uWvY220Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 3 Jan 2015 19:49:37 +0100

The release_firmware() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/soc/intel/sst/sst_loader.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/intel/sst/sst_loader.c b/sound/soc/intel/sst/sst_loader.c
index b580f96..7888cd7 100644
--- a/sound/soc/intel/sst/sst_loader.c
+++ b/sound/soc/intel/sst/sst_loader.c
@@ -324,8 +324,7 @@ void sst_firmware_load_cb(const struct firmware *fw, void *context)
 
 	if (ctx->sst_state != SST_RESET ||
 			ctx->fw_in_mem != NULL) {
-		if (fw != NULL)
-			release_firmware(fw);
+		release_firmware(fw);
 		mutex_unlock(&ctx->sst_lock);
 		return;
 	}
-- 
2.2.1

