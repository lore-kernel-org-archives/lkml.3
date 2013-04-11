Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028Ab3DKUgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:36:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5269 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab3DKU0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:05 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LzMaoZeIiL0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1SWc1naRr90A:10 a=metUmxCXAAAA:8 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=0kPLrQdw3YYA:10 a=Foo1usX8mm8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202550.797778760@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Martin Weishart <martin.weishart@telosalliance.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 028/171 ] ALSA: hda - Fix typo in checking IEC958 emphasis bit
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0028-ALSA-hda-Fix-typo-in-checking-IEC958-emphasis-bit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a686fd141e20244ad75f80ad54706da07d7bb90a ]

There is a typo in convert_to_spdif_status() about checking the
emphasis IEC958 status bit.  It should check the given value instead
of the resultant value.

Reported-by: Martin Weishart <martin.weishart@telosalliance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 38fdefc..f60254d 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2970,7 +2970,7 @@ static unsigned int convert_to_spdif_status(unsigned short val)
 	if (val & AC_DIG1_PROFESSIONAL)
 		sbits |= IEC958_AES0_PROFESSIONAL;
 	if (sbits & IEC958_AES0_PROFESSIONAL) {
-		if (sbits & AC_DIG1_EMPHASIS)
+		if (val & AC_DIG1_EMPHASIS)
 			sbits |= IEC958_AES0_PRO_EMPHASIS_5015;
 	} else {
 		if (val & AC_DIG1_EMPHASIS)
-- 
1.7.10.4


