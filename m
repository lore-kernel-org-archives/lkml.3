Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893AbaDJEO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:14:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934709AbaDJDWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 053/134] ALSA: hda - Add Conexant CX20751/2/3/4 codec support
Date: Wed,  9 Apr 2014 20:22:49 -0700
Message-Id: <20140410032306.947952387@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 61d648fb4726f8a89c07cd1904f9c2e11bf26df5 upstream.

These are almost compatible with the older Conexant codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4521,6 +4521,10 @@ static int patch_conexant_auto(struct hd
  */
 
 static const struct hda_codec_preset snd_hda_preset_conexant[] = {
+	{ .id = 0x14f11510, .name = "CX20751/2",
+	  .patch = patch_conexant_auto },
+	{ .id = 0x14f11511, .name = "CX20753/4",
+	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15045, .name = "CX20549 (Venice)",
 	  .patch = patch_cxt5045 },
 	{ .id = 0x14f15047, .name = "CX20551 (Waikiki)",
@@ -4558,6 +4562,8 @@ static const struct hda_codec_preset snd
 	{} /* terminator */
 };
 
+MODULE_ALIAS("snd-hda-codec-id:14f11510");
+MODULE_ALIAS("snd-hda-codec-id:14f11511");
 MODULE_ALIAS("snd-hda-codec-id:14f15045");
 MODULE_ALIAS("snd-hda-codec-id:14f15047");
 MODULE_ALIAS("snd-hda-codec-id:14f15051");


