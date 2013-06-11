Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3FKUeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:34:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab3FKUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 07/32] ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270
Date: Tue, 11 Jun 2013 13:03:06 -0700
Message-Id: <20130611200127.024269512@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


