Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3I3KLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:11:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3I3KLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 007/104] ALSA: ak4xx-adda: info leak in ak4xxx_capture_source_info()
Date: Mon, 30 Sep 2013 11:09:44 +0100
Message-Id: <1380535881-9239-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bd5fe738e388ceaa32e5171481e0d3ec59f0ccfe upstream.

"idx" is controled by the user and can be a negative offset into the
input_names[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/i2c/other/ak4xxx-adda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/i2c/other/ak4xxx-adda.c b/sound/i2c/other/ak4xxx-adda.c
index cef813d..ed726d1 100644
--- a/sound/i2c/other/ak4xxx-adda.c
+++ b/sound/i2c/other/ak4xxx-adda.c
@@ -571,7 +571,7 @@ static int ak4xxx_capture_source_info(struct snd_kcontrol *kcontrol,
 	struct snd_akm4xxx *ak = snd_kcontrol_chip(kcontrol);
 	int mixer_ch = AK_GET_SHIFT(kcontrol->private_value);
 	const char **input_names;
-	int  num_names, idx;
+	unsigned int num_names, idx;
 
 	num_names = ak4xxx_capture_num_inputs(ak, mixer_ch);
 	if (!num_names)
-- 
1.8.3.2

