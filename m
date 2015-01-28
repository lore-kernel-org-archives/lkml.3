Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbbA1FCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:02:00 -0500
Received: from mail.kernel.org ([198.145.29.136]:39129 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbbA1EUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:09 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Catoi <vladcatoi@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 069/177] ALSA: usb-audio: Add support for Steinberg UR22 USB interface
Date: Wed, 28 Jan 2015 12:08:24 +0800
Message-Id: <1422418236-12852-137-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Catoi <vladcatoi@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit f0b127fbfdc8756eba7437ab668f3169280bd358 upstream.

Adding support for Steinberg UR22 USB interface via quirks table patch

See Ubuntu bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1317244
Also see threads:
http://linux-audio.4202.n7.nabble.com/Support-for-Steinberg-UR22-Yamaha-USB-chipset-0499-1509-tc82888.html#a82917
http://www.steinberg.net/forums/viewtopic.php?t=62290

Tested by at least 4 people judging by the threads.
Did not test MIDI interface, but audio output and capture both are
functional. Built 3.17 kernel with this driver on Ubuntu 14.04 & tested with mpg123
Patch applied to 3.13 Ubuntu kernel works well enough for daily use.

Signed-off-by: Vlad Catoi <vladcatoi@gmail.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/usb/quirks-table.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 915bc2c..5ef3579 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -301,6 +301,36 @@ YAMAHA_DEVICE(0x105d, NULL),
 		}
 	}
 },
+{
+	USB_DEVICE(0x0499, 0x1509),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		/* .vendor_name = "Yamaha", */
+		/* .product_name = "Steinberg UR22", */
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			{
+				.ifnum = 3,
+				.type = QUIRK_MIDI_YAMAHA
+			},
+			{
+				.ifnum = 4,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 YAMAHA_DEVICE(0x2000, "DGP-7"),
 YAMAHA_DEVICE(0x2001, "DGP-5"),
 YAMAHA_DEVICE(0x2002, NULL),
-- 
1.9.1

