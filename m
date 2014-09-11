Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaIKMmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:42:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51650 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mario" <fugazzi99@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>, "corubba" <corubba@gmx.de>,
        "Clemens Ladisch" <clemens@ladisch.de>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.639722099@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 048/131] ALSA: virtuoso: add Xonar Essence STX II support
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit f42bb22243d2ae264d721b055f836059fe35321f upstream.

Just add the PCI ID for the STX II.  It appears to work the same as the
STX, except for the addition of the not-yet-supported daughterboard.

Tested-by: Mario <fugazzi99@gmail.com>
Tested-by: corubba <corubba@gmx.de>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/sound/alsa/ALSA-Configuration.txt |  4 ++--
 sound/pci/Kconfig                               |  4 ++--
 sound/pci/oxygen/virtuoso.c                     |  1 +
 sound/pci/oxygen/xonar_pcm179x.c                | 12 ++++++++++--
 4 files changed, 15 insertions(+), 6 deletions(-)

--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -2018,8 +2018,8 @@ Prior to version 0.9.0rc4 options had a
   -------------------
 
     Module for sound cards based on the Asus AV66/AV100/AV200 chips,
-    i.e., Xonar D1, DX, D2, D2X, DS, Essence ST (Deluxe), Essence STX,
-    HDAV1.3 (Deluxe), and HDAV1.3 Slim.
+    i.e., Xonar D1, DX, D2, D2X, DS, DSX, Essence ST (Deluxe),
+    Essence STX (II), HDAV1.3 (Deluxe), and HDAV1.3 Slim.
 
     This module supports autoprobe and multiple cards.
 
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -852,8 +852,8 @@ config SND_VIRTUOSO
 	select SND_JACK if INPUT=y || INPUT=SND
 	help
 	  Say Y here to include support for sound cards based on the
-	  Asus AV66/AV100/AV200 chips, i.e., Xonar D1, DX, D2, D2X, DS,
-	  Essence ST (Deluxe), and Essence STX.
+	  Asus AV66/AV100/AV200 chips, i.e., Xonar D1, DX, D2, D2X, DS, DSX,
+	  Essence ST (Deluxe), and Essence STX (II).
 	  Support for the HDAV1.3 (Deluxe) and HDAV1.3 Slim is experimental;
 	  for the Xense, missing.
 
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -53,6 +53,7 @@ static DEFINE_PCI_DEVICE_TABLE(xonar_ids
 	{ OXYGEN_PCI_SUBID(0x1043, 0x835e) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x838e) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x8522) },
+	{ OXYGEN_PCI_SUBID(0x1043, 0x85f4) },
 	{ OXYGEN_PCI_SUBID_BROKEN_EEPROM },
 	{ }
 };
--- a/sound/pci/oxygen/xonar_pcm179x.c
+++ b/sound/pci/oxygen/xonar_pcm179x.c
@@ -100,8 +100,8 @@
  */
 
 /*
- * Xonar Essence ST (Deluxe)/STX
- * -----------------------------
+ * Xonar Essence ST (Deluxe)/STX (II)
+ * ----------------------------------
  *
  * CMI8788:
  *
@@ -1137,6 +1137,14 @@ int __devinit get_xonar_pcm179x_model(st
 		chip->model.init = xonar_stx_init;
 		chip->model.resume = xonar_stx_resume;
 		chip->model.set_dac_params = set_pcm1796_params;
+		break;
+	case 0x85f4:
+		chip->model = model_xonar_st;
+		/* TODO: daughterboard support */
+		chip->model.shortname = "Xonar STX II";
+		chip->model.init = xonar_stx_init;
+		chip->model.resume = xonar_stx_resume;
+		chip->model.set_dac_params = set_pcm1796_params;
 		break;
 	default:
 		return -EINVAL;

