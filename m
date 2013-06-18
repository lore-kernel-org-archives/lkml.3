Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab3FRMAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:00:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3FRLoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 44/93] ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270
Date: Tue, 18 Jun 2013 12:42:52 +0100
Message-Id: <1371555821-12820-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 11e7064f35bb87da8f427d1aa4bbd8b7473a3993 upstream.

USB audio driver spews an error message when probing Logitech HD
webcam c270:
  ALSA mixer.c:1300 usb_audio: Warning! Unlikely big volume range (=6144), cval->res is probably wrong.
  ALSA mixer.c:1304 usb_audio: [5] FU [Mic Capture Volume] ch = 1, val = 1536/7680/1

Obviously the device needs a fixed volume resolution (cval->res = 384)
like other Logitech devices.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=821735

Reported-and-tested-by: Cristian Rodríguez <crrodriguez@opensuse.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 4d8ddc6..a3308e1 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -842,6 +842,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
+	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
 	case USB_ID(0x046d, 0x0991):
 	/* Most audio usb devices lie about volume resolution.
 	 * Most Logitech webcams have res = 384.
-- 
1.8.1.2

