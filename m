Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab3GCSoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:44:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab3GCSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:10 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=L4Hd8AoES0QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=KU5Rxz9A1qQA:10 a=1nSz6Ew-AAAA:8 a=KSb9T-wMAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=0kPLrQdw3YYA:10 a=dQ-OxBcGOlMA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184056.983685952@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [074/141] ALSA: usb-audio - Fix invalid volume resolution on Logitech HD
 webcam c270
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0074-ALSA-usb-audio-Fix-invalid-volume-resolution-on-Logi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 11e7064f35bb87da8f427d1aa4bbd8b7473a3993 ]

USB audio driver spews an error message when probing Logitech HD
webcam c270:
  ALSA mixer.c:1300 usb_audio: Warning! Unlikely big volume range (=6144), cval->res is probably wrong.
  ALSA mixer.c:1304 usb_audio: [5] FU [Mic Capture Volume] ch = 1, val = 1536/7680/1

Obviously the device needs a fixed volume resolution (cval->res = 384)
like other Logitech devices.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=821735

Reported-and-tested-by: Cristian Rodríguez <crrodriguez@opensuse.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/mixer.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 900bf42..9a9da0a 100644
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
1.7.10.4


