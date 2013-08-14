Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab3HNKih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:38:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34698 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3HNKiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sachin Kamat <sachin.kamat@linaro.org>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 65/75] ALSA: usb/6fire: Fix potential NULL pointer dereference in comm.c
Date: Wed, 14 Aug 2013 11:36:54 +0100
Message-Id: <1376476624-10011-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 27b2a22c714303d1920e269a8322ff23107694ee upstream.

'rt' was dereferenced before the NULL check.
Moved the code after the check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/6fire/comm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/6fire/comm.c b/sound/usb/6fire/comm.c
index 6c3d531..1a75c36 100644
--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -129,12 +129,13 @@ int __devinit usb6fire_comm_init(struct sfire_chip *chip)
 {
 	struct comm_runtime *rt = kzalloc(sizeof(struct comm_runtime),
 			GFP_KERNEL);
-	struct urb *urb = &rt->receiver;
+	struct urb *urb;
 	int ret;
 
 	if (!rt)
 		return -ENOMEM;
 
+	urb = &rt->receiver;
 	rt->serial = 1;
 	rt->chip = chip;
 	usb_init_urb(urb);
-- 
1.8.3.2

