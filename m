Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3FQRfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:35:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50643 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3FQRfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 48/84] ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270
Date: Mon, 17 Jun 2013 10:30:52 -0700
Message-Id: <1371490288-23167-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 64a564d..0a1e869 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -885,6 +885,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
+	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
 	case USB_ID(0x046d, 0x0991):
 	/* Most audio usb devices lie about volume resolution.
 	 * Most Logitech webcams have res = 384.
-- 
1.8.1.2

