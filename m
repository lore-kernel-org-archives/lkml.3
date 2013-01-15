Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3APALr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:11:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:42888 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab3AOWcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 137/221] ALSA: hda - Disable runtime D3 for Intel CPT & co
Date: Tue, 15 Jan 2013 10:51:04 -0800
Message-Id: <20130115185007.955826280@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d7dab4dbbb2d1b0c903378d6bade2e4ae161804e upstream.

We've got a few bug reports that the runtime D3 results in the dead
HD-audio controller.  It seems that the problem is in a deeper level
than the sound driver itself, so as a temporal solution, disable the
feature for these controllers again.

Reported-and-tested-by: Vincent Blut <vincent.debian@free.fr>
Reported-and-tested-by: Maurizio Avogadro <mavoga@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -559,9 +559,12 @@ enum {
 #define AZX_DCAPS_PM_RUNTIME	(1 << 26)	/* runtime PM support */
 
 /* quirks for Intel PCH */
-#define AZX_DCAPS_INTEL_PCH \
+#define AZX_DCAPS_INTEL_PCH_NOPM \
 	(AZX_DCAPS_SCH_SNOOP | AZX_DCAPS_BUFSIZE | \
-	 AZX_DCAPS_COUNT_LPIB_DELAY | AZX_DCAPS_PM_RUNTIME)
+	 AZX_DCAPS_COUNT_LPIB_DELAY)
+
+#define AZX_DCAPS_INTEL_PCH \
+	(AZX_DCAPS_INTEL_PCH_NOPM | AZX_DCAPS_PM_RUNTIME)
 
 /* quirks for ATI SB / AMD Hudson */
 #define AZX_DCAPS_PRESET_ATI_SB \
@@ -3448,13 +3451,13 @@ static void __devexit azx_remove(struct
 static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	/* CPT */
 	{ PCI_DEVICE(0x8086, 0x1c20),
-	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* PBG */
 	{ PCI_DEVICE(0x8086, 0x1d20),
-	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Panther Point */
 	{ PCI_DEVICE(0x8086, 0x1e20),
-	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Lynx Point */
 	{ PCI_DEVICE(0x8086, 0x8c20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },


