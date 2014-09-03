Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbaICXgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:36:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135AbaICWIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul S McSpadden <fisch602@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 13/88] ALSA: usb-audio: Adjust Gamecom 780 volume level
Date: Wed,  3 Sep 2014 15:04:47 -0700
Message-Id: <20140903220516.347384094@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul S McSpadden <fisch602@gmail.com>

commit 542baf94ec3c5526955b4c9fd899c7f30fae4ebe upstream.

Original patch fixed the original problem, but the sound was far too low
for most users. This patch references a compare matrix to allow the
volume levels to act normally. I personally tested this patch myself,
and volume levels returned to normal. Please see this discussion for
more details: https://bugzilla.kernel.org/show_bug.cgi?id=65251

Signed-off-by: Paul S McSpadden <fisch602@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -666,7 +666,7 @@ static int snd_usb_gamecon780_boot_quirk
 	/* set the initial volume and don't change; other values are either
 	 * too loud or silent due to firmware bug (bko#65251)
 	 */
-	u8 buf[2] = { 0x74, 0xdc };
+	u8 buf[2] = { 0x74, 0xe3 };
 	return snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), UAC_SET_CUR,
 			USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_OUT,
 			UAC_FU_VOLUME << 8, 9 << 8, buf, 2);


