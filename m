Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaKAWlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:41:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60325 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbaKAWjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.940278377@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 020/102] ALSA: hda - Fix COEF setups for ALC1150 codec
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit acf08081adb5e8fe0519eb97bb49797ef52614d6 upstream.

ALC1150 codec seems to need the COEF- and PLL-setups just like its
compatible ALC882 codec.  Some machines (e.g. SunMicro X10SAT) show
the problem like too low output volumes unless the COEF setup is
applied.

Reported-and-tested-by: Dana Goyette <danagoyette@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -789,6 +789,7 @@ static void alc_auto_init_amp(struct hda
 		case 0x10ec0885:
 		case 0x10ec0887:
 		/*case 0x10ec0889:*/ /* this causes an SPDIF problem */
+		case 0x10ec0900:
 			alc889_coef_init(codec);
 			break;
 		case 0x10ec0888:
@@ -4343,6 +4344,7 @@ static int patch_alc882(struct hda_codec
 	switch (codec->vendor_id) {
 	case 0x10ec0882:
 	case 0x10ec0885:
+	case 0x10ec0900:
 		break;
 	default:
 		/* ALC883 and variants */

