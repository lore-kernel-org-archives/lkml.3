Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbaICKD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:03:58 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57444 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932368AbaICJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 22/56] ALSA: virtuoso: add Xonar Essence STX II support
Date: Wed,  3 Sep 2014 11:26:41 +0200
Message-Id: <742b80d741430f4ec11112bfa9b2a9a36e94bbd3.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f42bb22243d2ae264d721b055f836059fe35321f upstream.

Just add the PCI ID for the STX II.  It appears to work the same as the
STX, except for the addition of the not-yet-supported daughterboard.

Tested-by: Mario <fugazzi99@gmail.com>
Tested-by: corubba <corubba@gmx.de>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Documentation/sound/alsa/ALSA-Configuration.txt |  4 ++--
 sound/pci/Kconfig                               |  4 ++--
 sound/pci/oxygen/virtuoso.c                     |  1 +
 sound/pci/oxygen/xonar_pcm179x.c                | 12 ++++++++++--
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index 95731a08f257..8f08b2a71791 100644
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
index cc9fd67a50df..be6277ce272b 100644
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
index 64b9fda5f04a..dbbbacfd535e 100644
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
index c8c7f2c9b355..e02605931669 100644
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
2.1.0

