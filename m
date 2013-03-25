Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3CYBbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:31:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33945 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947Ab3CYBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:55 -0400
Message-Id: <20130325010531.283688304@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:35 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>,
        Martin Weishart <martin.weishart@telosalliance.com>
Subject: [ 071/104] ALSA: hda - Fix typo in checking IEC958 emphasis bit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a686fd141e20244ad75f80ad54706da07d7bb90a upstream.

There is a typo in convert_to_spdif_status() about checking the
emphasis IEC958 status bit.  It should check the given value instead
of the resultant value.

Reported-by: Martin Weishart <martin.weishart@telosalliance.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2771,7 +2771,7 @@ static unsigned int convert_to_spdif_sta
 	if (val & AC_DIG1_PROFESSIONAL)
 		sbits |= IEC958_AES0_PROFESSIONAL;
 	if (sbits & IEC958_AES0_PROFESSIONAL) {
-		if (sbits & AC_DIG1_EMPHASIS)
+		if (val & AC_DIG1_EMPHASIS)
 			sbits |= IEC958_AES0_PRO_EMPHASIS_5015;
 	} else {
 		if (val & AC_DIG1_EMPHASIS)


