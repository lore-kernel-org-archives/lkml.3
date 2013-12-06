Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161564Ab3LFXMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:12:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48459 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161416Ab3LFXMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 054/152] ALSA: hda - Force buffer alignment for Haswell HDMI controllers
Date: Fri,  6 Dec 2013 15:09:38 -0800
Message-Id: <1386371476-2477-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (no POWERWELL support) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index efe16d2..0614bf4 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -580,6 +580,10 @@ enum {
 #define AZX_DCAPS_INTEL_PCH \
 	(AZX_DCAPS_INTEL_PCH_NOPM | AZX_DCAPS_PM_RUNTIME)
 
+#define AZX_DCAPS_INTEL_HASWELL \
+	(AZX_DCAPS_SCH_SNOOP | AZX_DCAPS_ALIGN_BUFSIZE | \
+	 AZX_DCAPS_COUNT_LPIB_DELAY | AZX_DCAPS_PM_RUNTIME)
+
 /* quirks for ATI SB / AMD Hudson */
 #define AZX_DCAPS_PRESET_ATI_SB \
 	(AZX_DCAPS_ATI_SNOOP | AZX_DCAPS_NO_TCSEL | \
@@ -3620,11 +3624,11 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Haswell */
 	{ PCI_DEVICE(0x8086, 0x0a0c),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_HASWELL },
 	{ PCI_DEVICE(0x8086, 0x0c0c),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_HASWELL },
 	{ PCI_DEVICE(0x8086, 0x0d0c),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_HASWELL },
 	/* 5 Series/3400 */
 	{ PCI_DEVICE(0x8086, 0x3b56),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
-- 
1.8.3.2

