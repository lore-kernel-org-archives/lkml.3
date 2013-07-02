Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3GBLIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36141 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab3GBLHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:07:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 03/50] ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310
Date: Tue,  2 Jul 2013 12:06:51 +0100
Message-Id: <1372763258-20664-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 36691e1be6ec551eef4a5225f126a281f8c051c2 upstream.

Just like the previous fix for LogitechHD Webcam c270 in commit
11e7064f35bb87da8f427d1aa4bbd8b7473a3993, c310 model also requires the
same workaround for avoiding the kernel warning.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=59741
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index a3308e1..3e513a8 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -841,6 +841,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
+	case USB_ID(0x046d, 0x081b): /* HD Webcam c310 */
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
 	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
 	case USB_ID(0x046d, 0x0991):
-- 
1.8.1.2

