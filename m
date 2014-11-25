Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaKYLsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:48:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaKYKlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Libin Yang <libin.yang@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 060/254] ALSA: hda - add PCI IDs for Intel Braswell
Date: Tue, 25 Nov 2014 10:36:50 +0000
Message-Id: <1416912004-5928-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Libin Yang <libin.yang@intel.com>

commit f31b2ffcad2b8c57cee5ffc634928bcbc8c6a558 upstream.

Add HD Audio Device PCI ID for the Intel Braswell platform.
It is an HDA Intel PCH controller.

AZX_DCAPS_ALIGN_BUFSIZE is not necessary for this controller.

Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 83cd19017cf3..007849b443d9 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1806,6 +1806,9 @@ static const struct pci_device_id azx_ids[] = {
 	/* BayTrail */
 	{ PCI_DEVICE(0x8086, 0x0f04),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
+	/* Braswell */
+	{ PCI_DEVICE(0x8086, 0x2284),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* ICH */
 	{ PCI_DEVICE(0x8086, 0x2668),
 	  .driver_data = AZX_DRIVER_ICH | AZX_DCAPS_OLD_SSYNC |
-- 
2.1.0

