Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935838AbaBDWr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:47:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933355AbaBDVCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 063/104] ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks
Date: Tue,  4 Feb 2014 13:02:06 -0800
Message-Id: <20140204210224.499722882@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 80ab8eae70e51d578ebbeb228e0f7a562471b8b7 upstream.

The PCI devices with DMA masks smaller than 32bit should enable
CONFIG_ZONE_DMA.  Since the recent change of page allocator, page
allocations via dma_alloc_coherent() with the limited DMA mask bits
may fail more frequently, ended up with no available buffers, when
CONFIG_ZONE_DMA isn't enabled.  With CONFIG_ZONE_DMA, the system has
much more chance to obtain such pages.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=68221
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/Kconfig |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -30,6 +30,7 @@ config SND_ALS300
 	select SND_PCM
 	select SND_AC97_CODEC
 	select SND_OPL3_LIB
+	select ZONE_DMA
 	help
 	  Say 'Y' or 'M' to include support for Avance Logic ALS300/ALS300+
 
@@ -54,6 +55,7 @@ config SND_ALI5451
 	tristate "ALi M5451 PCI Audio Controller"
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for the integrated AC97 sound
 	  device on motherboards using the ALi M5451 Audio Controller
@@ -158,6 +160,7 @@ config SND_AZT3328
 	select SND_PCM
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for Aztech AZF3328 (PCI168)
 	  soundcards.
@@ -463,6 +466,7 @@ config SND_EMU10K1
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y to include support for Sound Blaster PCI 512, Live!,
 	  Audigy and E-mu APS (partially supported) soundcards.
@@ -478,6 +482,7 @@ config SND_EMU10K1X
 	tristate "Emu10k1X (Dell OEM Version)"
 	select SND_AC97_CODEC
 	select SND_RAWMIDI
+	select ZONE_DMA
 	help
 	  Say Y here to include support for the Dell OEM version of the
 	  Sound Blaster Live!.
@@ -511,6 +516,7 @@ config SND_ES1938
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Solo-1
 	  (ES1938, ES1946, ES1969) chips.
@@ -522,6 +528,7 @@ config SND_ES1968
 	tristate "ESS ES1968/1978 (Maestro-1/2/2E)"
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Maestro
 	  1/2/2E chips.
@@ -603,6 +610,7 @@ config SND_ICE1712
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	select BITREVERSE
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on the
 	  ICE1712 (Envy24) chip.
@@ -690,6 +698,7 @@ config SND_LX6464ES
 config SND_MAESTRO3
 	tristate "ESS Allegro/Maestro3"
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Maestro 3
 	  (Allegro) chips.
@@ -786,6 +795,7 @@ config SND_SIS7019
 	tristate "SiS 7019 Audio Accelerator"
 	depends on X86 && !X86_64
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for the SiS 7019 Audio Accelerator.
 
@@ -797,6 +807,7 @@ config SND_SONICVIBES
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on the S3
 	  SonicVibes chip.
@@ -808,6 +819,7 @@ config SND_TRIDENT
 	tristate "Trident 4D-Wave DX/NX; SiS 7018"
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
+	select ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on Trident
 	  4D-Wave DX/NX or SiS 7018 chips.


