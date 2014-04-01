Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaDAMFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:05:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaDALRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/144] ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs
Date: Tue,  1 Apr 2014 12:14:11 +0100
Message-Id: <1396350948-29910-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c5eda4c1bf6214332c46fb2f4e7c42a85e5e5643 upstream.

The mixer widget (NID 0x20) of AD1884 and AD1984 codecs isn't
connected directly to the actual I/O paths but only via another mixer
widget (NID 0x21).  We need a similar fix as we did for AD1882.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_analog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 3d8e567..570bce0 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3697,6 +3697,7 @@ static int ad1884_parse_auto_config(struct hda_codec *codec)
 	spec = codec->spec;
 
 	spec->gen.mixer_nid = 0x20;
+	spec->gen.mixer_merge_nid = 0x21;
 	spec->gen.beep_nid = 0x10;
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
 
-- 
1.9.1

