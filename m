Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaIOWNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522AbaIOWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 141/187] ALSA: virtuoso: add Xonar Essence STX II support
Date: Mon, 15 Sep 2014 15:09:11 -0700
Message-Id: <1410818997-9432-142-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit f42bb22243d2ae264d721b055f836059fe35321f upstream.

Just add the PCI ID for the STX II.  It appears to work the same as the
STX, except for the addition of the not-yet-supported daughterboard.

Tested-by: Mario <fugazzi99@gmail.com>
Tested-by: corubba <corubba@gmx.de>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/sound/alsa/ALSA-Configuration.txt |  4 ++--
 sound/pci/Kconfig                               |  4 ++--
 sound/pci/oxygen/virtuoso.c                     |  1 +
 sound/pci/oxygen/xonar_pcm179x.c                | 12 ++++++++++--
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index b8dd0df..0fd40b1 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -2026,8 +2026,8 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
   -------------------
 
     Module for sound cards based on the Asus AV66/AV100/AV200 chips,
-    i.e., Xonar D1, DX, D2, D2X, DS, Essence ST (Deluxe), Essence STX,
-    HDAV1.3 (Deluxe), and HDAV1.3 Slim.
+    i.e., Xonar D1, DX, D2, D2X, DS, DSX, Essence ST (Deluxe),
+    Essence STX (II), HDAV1.3 (Deluxe), and HDAV1.3 Slim.
 
     This module supports autoprobe and multiple cards.
 
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index cc9fd67..be6277c 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -858,8 +858,8 @@ config SND_VIRTUOSO
 	select SND_JACK if INPUT=y || INPUT=SND
 	help
 	  Say Y here to include support for sound cards based on the
-	  Asus AV66/AV100/AV200 chips, i.e., Xonar D1, DX, D2, D2X, DS,
-	  Essence ST (Deluxe), and Essence STX.
+	  Asus AV66/AV100/AV200 chips, i.e., Xonar D1, DX, D2, D2X, DS, DSX,
+	  Essence ST (Deluxe), and Essence STX (II).
 	  Support for the HDAV1.3 (Deluxe) and HDAV1.3 Slim is experimental;
 	  for the Xense, missing.
 
diff --git a/sound/pci/oxygen/virtuoso.c b/sound/pci/oxygen/virtuoso.c
index 64b9fda..dbbbacf 100644
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -53,6 +53,7 @@ static DEFINE_PCI_DEVICE_TABLE(xonar_ids) = {
 	{ OXYGEN_PCI_SUBID(0x1043, 0x835e) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x838e) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x8522) },
+	{ OXYGEN_PCI_SUBID(0x1043, 0x85f4) },
 	{ OXYGEN_PCI_SUBID_BROKEN_EEPROM },
 	{ }
 };
diff --git a/sound/pci/oxygen/xonar_pcm179x.c b/sound/pci/oxygen/xonar_pcm179x.c
index c8c7f2c..e026059 100644
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
@@ -1138,6 +1138,14 @@ int get_xonar_pcm179x_model(struct oxygen *chip,
 		chip->model.resume = xonar_stx_resume;
 		chip->model.set_dac_params = set_pcm1796_params;
 		break;
+	case 0x85f4:
+		chip->model = model_xonar_st;
+		/* TODO: daughterboard support */
+		chip->model.shortname = "Xonar STX II";
+		chip->model.init = xonar_stx_init;
+		chip->model.resume = xonar_stx_resume;
+		chip->model.set_dac_params = set_pcm1796_params;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.9.1

