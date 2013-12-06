Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162444Ab3LFXUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:20:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48982 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162428Ab3LFXUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 096/152] ALSA: msnd: Avoid duplicated driver name
Date: Fri,  6 Dec 2013 15:10:20 -0800
Message-Id: <1386371476-2477-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/isa/msnd/msnd_pinnacle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index ddabb40..3a7946e 100644
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
 
 static void set_default_audio_parameters(struct snd_msnd *chip)
@@ -1068,8 +1070,6 @@ static int snd_msnd_isa_remove(struct device *pdev, unsigned int dev)
 	return 0;
 }
 
-#define DEV_NAME "msnd-pinnacle"
-
 static struct isa_driver snd_msnd_driver = {
 	.match		= snd_msnd_isa_match,
 	.probe		= snd_msnd_isa_probe,
-- 
1.8.3.2

