Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3FPWXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:23:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46350 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755628Ab3FPWIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.215221582@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [58/83] ALSA: usb-audio - Fix invalid volume resolution on
 Logitech HD webcam c270
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/mixer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -822,6 +822,7 @@ static void volume_control_quirks(struct
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
+	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
 	case USB_ID(0x046d, 0x0991):
 	/* Most audio usb devices lie about volume resolution.
 	 * Most Logitech webcams have res = 384.

