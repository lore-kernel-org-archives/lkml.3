Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966613AbaFQVub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54381 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965647AbaFQVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 174/212] ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets
Date: Tue, 17 Jun 2014 14:44:28 -0700
Message-Id: <1403041506-13646-175-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 77f07800cb456bed6e5c345e6e4e83e8eda62437 upstream.

The recent Intel H97/Z97 chipsets need the similar setups like other
Intel chipsets for snooping, etc.  Especially without snooping, the
audio playback stutters or gets corrupted.  This fix patch just adds
the corresponding PCI ID entry with the proper flags.

Reported-and-tested-by: Arthur Borsboom <arthurborsboom@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 956871d..619d9a3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3987,6 +3987,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	/* Lynx Point */
 	{ PCI_DEVICE(0x8086, 0x8c20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	/* 9 Series */
+	{ PCI_DEVICE(0x8086, 0x8ca0),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Wellsburg */
 	{ PCI_DEVICE(0x8086, 0x8d20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
-- 
1.9.1

