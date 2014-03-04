Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbaCDUDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbaCDUDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 073/172] ALSA: usb-audio: work around KEF X300A firmware bug
Date: Tue,  4 Mar 2014 12:02:37 -0800
Message-Id: <20140304200302.070005831@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 624aef494f86ed0c58056361c06347ad62b26806 upstream.

When the driver tries to access Function Unit 10, the KEF X300A
speakers' firmware apparently locks up, making even PCM streaming
impossible.  Work around this by ignoring this FU.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_maps.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -322,6 +322,11 @@ static struct usbmix_name_map hercules_u
 	{ 0 }				/* terminator */
 };
 
+static const struct usbmix_name_map kef_x300a_map[] = {
+	{ 10, NULL }, /* firmware locks up (?) when we try to access this FU */
+	{ 0 }
+};
+
 /*
  * Control map entries
  */
@@ -409,6 +414,10 @@ static struct usbmix_ctl_map usbmix_ctl_
 		.id = USB_ID(0x200c, 0x1018),
 		.map = ebox44_map,
 	},
+	{
+		.id = USB_ID(0x27ac, 0x1000),
+		.map = kef_x300a_map,
+	},
 	{ 0 } /* terminator */
 };
 


