Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3HRUoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:44:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3HRUfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maksim Boyko <maksim.a.boyko@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 23/45] ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam C525
Date: Sun, 18 Aug 2013 13:36:12 -0700
Message-Id: <20130818203622.616225812@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Maksim A. Boyko" <maksboyko@yandex.ru>

commit 140d37de62ffe8405282a1d6498f3b4099006384 upstream.

Add the volume control quirk for avoiding the kernel warning
for the Logitech HD Webcam C525
as in the similar commit 36691e1be6ec551eef4a5225f126a281f8c051c2
for the Logitech HD Webcam C310.

Reported-by: Maksim Boyko <maksim.a.boyko@gmail.com>
Tested-by: Maksim Boyko <maksim.a.boyko@gmail.com>
Signed-off-by: Maksim Boyko <maksim.a.boyko@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -888,6 +888,7 @@ static void volume_control_quirks(struct
 	case USB_ID(0x046d, 0x081b): /* HD Webcam c310 */
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
 	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
+	case USB_ID(0x046d, 0x0826): /* HD Webcam c525 */
 	case USB_ID(0x046d, 0x0991):
 	/* Most audio usb devices lie about volume resolution.
 	 * Most Logitech webcams have res = 384.


