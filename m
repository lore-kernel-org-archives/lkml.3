Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab3BLHui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 02:50:38 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:50883 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3BLHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 02:50:37 -0500
Message-ID: <1360655386.13766.4.camel@nexus.lab.ntt.co.jp>
Subject: [PATCH 2/3] ALSA: hda - update documentation for no-primary-hp fixup
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 16:49:46 +0900
In-Reply-To: <1360655264.13766.2.camel@nexus.lab.ntt.co.jp>
References: <1360655264.13766.2.camel@nexus.lab.ntt.co.jp>
Organization: NTT Open Source Software Center
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem addressed by this fixup is not specific to Vaio Z, affecting
some Vaio all-in-one desktop PCs too. Update the code comments accordingly.

Cc: stable@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.7.6-orig/Documentation/sound/alsa/HD-Audio-Models.txt linux-3.7.6/Documentation/sound/alsa/HD-Audio-Models.txt
--- linux-3.7.6-orig/Documentation/sound/alsa/HD-Audio-Models.txt	2012-12-11 12:30:57.000000000 +0900
+++ linux-3.7.6/Documentation/sound/alsa/HD-Audio-Models.txt	2013-02-09 22:44:28.614772054 +0900
@@ -53,7 +53,7 @@ ALC882/883/885/888/889
   acer-aspire-8930g	Acer Aspire 8330G/6935G
   acer-aspire		Acer Aspire others
   inv-dmic	Inverted internal mic workaround
-  no-primary-hp		VAIO Z workaround (for fixed speaker DAC)
+  no-primary-hp		VAIO Z/VGC-LN51JGB workaround (for fixed speaker DAC)
 
 ALC861/660
 ==========
diff -urNp linux-3.7.6-orig/sound/pci/hda/patch_realtek.c linux-3.7.6/sound/pci/hda/patch_realtek.c
--- linux-3.7.6-orig/sound/pci/hda/patch_realtek.c	2013-02-09 22:39:11.745202168 +0900
+++ linux-3.7.6/sound/pci/hda/patch_realtek.c	2013-02-09 22:50:10.924470402 +0900
@@ -5153,7 +5153,8 @@ static void alc889_fixup_imac91_vref(str
 }
 
 /* Don't take HP output as primary
- * strangely, the speaker output doesn't work on VAIO Z through DAC 0x05
+ * Strangely, the speaker output doesn't work on Vaio Z and some Vaio
+ * all-in-one desktop PCs (for example VGC-LN51JGB) through DAC 0x05
  */
 static void alc882_fixup_no_primary_hp(struct hda_codec *codec,
 				       const struct alc_fixup *fix, int action)


