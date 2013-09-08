Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab3IHDUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756276Ab3IHDSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.743555284@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [020/121] ALSA: ak4xx-adda: info leak in ak4xxx_capture_source_info()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bd5fe738e388ceaa32e5171481e0d3ec59f0ccfe upstream.

"idx" is controled by the user and can be a negative offset into the
input_names[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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

