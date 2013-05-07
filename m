Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab3EGEPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:15:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3EGD6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:43 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HAmtUutmq08A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Bfq-vjDcz30A:10 a=omOdbC7AAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035842.279760560@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [008/126] ALSA: hda - Enabling Realtek ALC 671 codec
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0008-ALSA-hda-Enabling-Realtek-ALC-671-codec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>

[ Upstream commit 1d87caa69c04008e09f5ff47b5e6acb6116febc7 ]

* Added the device ID to the modalias list and assinged ALC662 patches
for it
* Added 4 port support for the device ID 0671 in alc662_parse_auto_config

Signed-off-by: Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e1b7061..dd7f1db 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6656,7 +6656,8 @@ static int alc662_parse_auto_config(struct hda_codec *codec)
 	const hda_nid_t *ssids;
 
 	if (codec->vendor_id == 0x10ec0272 || codec->vendor_id == 0x10ec0663 ||
-	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670)
+	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670 ||
+	    codec->vendor_id == 0x10ec0671)
 		ssids = alc663_ssids;
 	else
 		ssids = alc662_ssids;
@@ -7108,6 +7109,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0665, .name = "ALC665", .patch = patch_alc662 },
 	{ .id = 0x10ec0668, .name = "ALC668", .patch = patch_alc662 },
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
+	{ .id = 0x10ec0671, .name = "ALC671", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
-- 
1.7.10.4


