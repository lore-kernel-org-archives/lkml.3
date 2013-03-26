Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab3CZXSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:18:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3CZWwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Weishart <martin.weishart@telosalliance.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 32/72] ALSA: hda - Fix typo in checking IEC958 emphasis bit
Date: Tue, 26 Mar 2013 15:51:15 -0700
Message-Id: <20130326224923.002914272@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a686fd141e20244ad75f80ad54706da07d7bb90a upstream.

There is a typo in convert_to_spdif_status() about checking the
emphasis IEC958 status bit.  It should check the given value instead
of the resultant value.

Reported-by: Martin Weishart <martin.weishart@telosalliance.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2910,7 +2910,7 @@ static unsigned int convert_to_spdif_sta
 	if (val & AC_DIG1_PROFESSIONAL)
 		sbits |= IEC958_AES0_PROFESSIONAL;
 	if (sbits & IEC958_AES0_PROFESSIONAL) {
-		if (sbits & AC_DIG1_EMPHASIS)
+		if (val & AC_DIG1_EMPHASIS)
 			sbits |= IEC958_AES0_PRO_EMPHASIS_5015;
 	} else {
 		if (val & AC_DIG1_EMPHASIS)


