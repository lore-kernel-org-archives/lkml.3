Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab3K0Bvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:51:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab3K0A5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 34/80] ALSA: msnd: Avoid duplicated driver name
Date: Tue, 26 Nov 2013 16:57:03 -0800
Message-Id: <20131127005643.293924823@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/isa/msnd/msnd_pinnacle.c |    4 ++--
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
 
 static void set_default_audio_parameters(struct snd_msnd *chip)
@@ -1068,8 +1070,6 @@ static int snd_msnd_isa_remove(struct de
 	return 0;
 }
 
-#define DEV_NAME "msnd-pinnacle"
-
 static struct isa_driver snd_msnd_driver = {
 	.match		= snd_msnd_isa_match,
 	.probe		= snd_msnd_isa_probe,


