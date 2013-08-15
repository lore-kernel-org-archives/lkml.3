Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3HOUtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:49:03 -0400
Received: from titanium.nobletdesign.com ([64.34.172.148]:53441 "EHLO
	titanium.nobletdesign.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3HOUtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:49:00 -0400
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Aug 2013 16:49:00 EDT
Message-ID: <520D399B.6020607@gnat.ca>
Date: Thu, 15 Aug 2013 14:27:07 -0600
From: "Nathanael D. Noblet" <nathanael@gnat.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: RealTek Inverted Mic Patch
Content-Type: multipart/mixed;
 boundary="------------080508000103060603000502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080508000103060603000502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

   I have hardware that suffers from an internal phase inverted mic that 
isn't properly detected. Below is a patch that fixes the issue for my 
particular hardware.

Pre patch alsa-info:

http://www.alsa-project.org/db/?f=a922c77ddf473a8f478ec334fa9dca684f213b59

Post patch alsa-info:
http://www.alsa-project.org/db/?f=14cd25b323d3bbb02fabbac78e62851569893c3f

Incase you care. The patch is small. I don't know if you need any kind 
of signed off/written by etc for something so small. In any case there 
is no intellectual property in this at all. Feel free to do as you wish 
with it. However including it in the kernel would make my life easier.

Thanks,
-- 
Nathanael d. Noblet
t 403.875.4613

--------------080508000103060603000502
Content-Type: text/x-patch;
 name="alsa-realtek-inverted-mic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-realtek-inverted-mic.patch"

--- a/sound/pci/hda/patch_realtek.c.org	2013-08-15 13:17:49.804492932 -0600
+++ b/sound/pci/hda/patch_realtek.c	2013-08-15 13:18:40.582364931 -0600
@@ -4208,6 +4208,7 @@
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x19da, 0xa130, "Zotac Z68", ALC662_FIXUP_ZOTAC_Z68),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
+    SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
 
 #if 0
 	/* Below is a quirk table taken from the old code.

--------------080508000103060603000502--
