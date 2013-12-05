Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab3LER5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:57:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3LERg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 27/90] ALSA: msnd: Avoid duplicated driver name
Date: Thu,  5 Dec 2013 17:35:09 +0000
Message-Id: <1386264972-5399-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 092f9cd16aac7d054af1755c945f37c1b33399e6 upstream.

msnd_pinnacle.c is used for both snd-msnd-pinnacle and
snd-msnd-classic drivers, and both should have different driver
names.  Using the same driver name results in the sysfs warning for
duplicated entries like
 kobject: 'msnd-pinnacle.7' (cec33408): kobject_release, parent   (null) (delayed)
 kobject: 'msnd-pinnacle' (cecd4980): kobject_release, parent cf3ad9b0 (delayed)
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:486 sysfs_warn_dup+0x7d/0xa0()
 sysfs: cannot create duplicate filename '/bus/isa/drivers/msnd-pinnacle'
 ......

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/isa/msnd/msnd_pinnacle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 29cc8e1..a7d6a52 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -73,9 +73,11 @@
 #ifdef MSND_CLASSIC
 #  include "msnd_classic.h"
 #  define LOGNAME			"msnd_classic"
+#  define DEV_NAME			"msnd-classic"
 #else
 #  include "msnd_pinnacle.h"
 #  define LOGNAME			"snd_msnd_pinnacle"
+#  define DEV_NAME			"msnd-pinnacle"
 #endif
 
 static void __devinit set_default_audio_parameters(struct snd_msnd *chip)
@@ -1068,8 +1070,6 @@ static int __devexit snd_msnd_isa_remove(struct device *pdev, unsigned int dev)
 	return 0;
 }
 
-#define DEV_NAME "msnd-pinnacle"
-
 static struct isa_driver snd_msnd_driver = {
 	.match		= snd_msnd_isa_match,
 	.probe		= snd_msnd_isa_probe,
-- 
1.8.3.2

