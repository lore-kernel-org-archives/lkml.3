Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab3K0B14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:27:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656Ab3K0A6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 047/116] ALSA: hda - Force buffer alignment for Haswell HDMI controllers
Date: Tue, 26 Nov 2013 16:57:00 -0800
Message-Id: <20131127005740.203464801@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 33499a15c2f7addc81695778753c2338b960eff7 upstream.

Haswell HDMI audio controllers seem to get stuck when unaligned buffer
size is used.  Let's enable the buffer alignment for the corresponding
entries.

Since AZX_DCAPS_INTEL_PCH contains AZX_DCAPS_BUFSIZE that disables the
buffer alignment forcibly, define AZX_DCAPS_INTEL_HASWELL and put the
necessary AZX_DCAPS bits there.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60769
Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -612,6 +612,11 @@ enum {
 #define AZX_DCAPS_INTEL_PCH \
 	(AZX_DCAPS_INTEL_PCH_NOPM | AZX_DCAPS_PM_RUNTIME)
 
+#define AZX_DCAPS_INTEL_HASWELL \
+	(AZX_DCAPS_SCH_SNOOP | AZX_DCAPS_ALIGN_BUFSIZE | \
+	 AZX_DCAPS_COUNT_LPIB_DELAY | AZX_DCAPS_PM_RUNTIME | \
+	 AZX_DCAPS_I915_POWERWELL)
+
 /* quirks for ATI SB / AMD Hudson */
 #define AZX_DCAPS_PRESET_ATI_SB \
 	(AZX_DCAPS_ATI_SNOOP | AZX_DCAPS_NO_TCSEL | \
@@ -3987,14 +3992,11 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids)
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Haswell */
 	{ PCI_DEVICE(0x8086, 0x0a0c),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH |
-	  AZX_DCAPS_I915_POWERWELL },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_HASWELL },
 	{ PCI_DEVICE(0x8086, 0x0c0c),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH |
-	  AZX_DCAPS_I915_POWERWELL },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_HASWELL },
 	{ PCI_DEVICE(0x8086, 0x0d0c),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH |
-	  AZX_DCAPS_I915_POWERWELL },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_HASWELL },
 	/* 5 Series/3400 */
 	{ PCI_DEVICE(0x8086, 0x3b56),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },


