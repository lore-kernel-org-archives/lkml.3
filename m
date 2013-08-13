Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3HMP6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3HMP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:25 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_dOt6VOgu6UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=e33bTIgZCH0A:10 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155823.857245829@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:56:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [01/88] ALSA: usb-audio: Fix invalid volume resolution for Logitech HD
 Webcam c310
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0001-ALSA-usb-audio-Fix-invalid-volume-resolution-for-Log.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 36691e1be6ec551eef4a5225f126a281f8c051c2 ]

Just like the previous fix for LogitechHD Webcam c270 in commit
11e7064f35bb87da8f427d1aa4bbd8b7473a3993, c310 model also requires the
same workaround for avoiding the kernel warning.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=59741
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/mixer.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 9a9da0a..5285480 100644
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
1.7.10.4


