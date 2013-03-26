Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934855Ab3CZPpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:45:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964913Ab3CZPXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 087/150] ALSA: hda - Fix typo in checking IEC958 emphasis bit
Date: Tue, 26 Mar 2013 15:19:46 +0000
Message-Id: <1364311249-14454-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a686fd141e20244ad75f80ad54706da07d7bb90a upstream.

There is a typo in convert_to_spdif_status() about checking the
emphasis IEC958 status bit.  It should check the given value instead
of the resultant value.

Reported-by: Martin Weishart <martin.weishart@telosalliance.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b1b6238..2c6a785 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2961,7 +2961,7 @@ static unsigned int convert_to_spdif_status(unsigned short val)
 	if (val & AC_DIG1_PROFESSIONAL)
 		sbits |= IEC958_AES0_PROFESSIONAL;
 	if (sbits & IEC958_AES0_PROFESSIONAL) {
-		if (sbits & AC_DIG1_EMPHASIS)
+		if (val & AC_DIG1_EMPHASIS)
 			sbits |= IEC958_AES0_PRO_EMPHASIS_5015;
 	} else {
 		if (val & AC_DIG1_EMPHASIS)
-- 
1.8.1.2

