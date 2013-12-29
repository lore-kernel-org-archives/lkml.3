Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab3L2CZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:25:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55584 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab3L2CLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:04 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Fengguang Wu" <fengguang.wu@intel.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.346980705@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 053/185] ALSA: msnd: Avoid duplicated driver name
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/isa/msnd/msnd_pinnacle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
@@ -1068,8 +1070,6 @@ static int __devexit snd_msnd_isa_remove
 	return 0;
 }
 
-#define DEV_NAME "msnd-pinnacle"
-
 static struct isa_driver snd_msnd_driver = {
 	.match		= snd_msnd_isa_match,
 	.probe		= snd_msnd_isa_probe,

