Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162367Ab3LFNMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:12:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44741 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162103Ab3LFNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 249/272] ALSA: hda - Force buffer alignment for Haswell HDMI controllers
Date: Fri,  6 Dec 2013 12:58:58 +0000
Message-Id: <1386334761-25517-250-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_intel.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 9552da2..022c535 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -609,6 +609,11 @@ enum {
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
@@ -3933,14 +3938,11 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
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
-- 
1.8.3.2

