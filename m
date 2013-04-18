Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967627Ab3DRJjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:39:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab3DRJR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 08/72] ALSA: hda - bug fix on return value when getting HDMI ELD info
Date: Thu, 18 Apr 2013 10:15:53 +0100
Message-Id: <1366276617-3553-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengdong Lin <mengdong.lin@intel.com>

commit 2ef5692efad330b67a234e2c49edad38538751e7 upstream.

In function snd_hdmi_get_eld(), the variable 'ret' should be initialized to 0.
Otherwise it will be returned uninitialized as non-zero after ELD info is got
successfully. Thus hdmi_present_sense() will always assume ELD info is invalid
by mistake, and /proc file system cannot show the proper ELD info.

Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
Acked-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_eld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 4c054f4..86f6468 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -322,7 +322,7 @@ int snd_hdmi_get_eld(struct hdmi_eld *eld,
 		     struct hda_codec *codec, hda_nid_t nid)
 {
 	int i;
-	int ret;
+	int ret = 0;
 	int size;
 	unsigned char *buf;
 
-- 
1.8.1.2

