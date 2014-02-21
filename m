Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaBUNy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:54:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbaBUMti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 021/121] ALSA: hda - Add missing mixer widget for AD1983
Date: Fri, 21 Feb 2014 12:47:25 +0000
Message-Id: <1392986945-9693-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c7579fed1f1b2567529aea64ef19871337403ab3 upstream.

The mixer widget on AD1983 at NID 0x0e was missing in the commit
[f2f8be43c5c9: ALSA: hda - Add aamix NID to AD codecs].

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70011
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_analog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 2ef62fe..ab1526c 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1702,6 +1702,7 @@ static int ad1983_parse_auto_config(struct hda_codec *codec)
 		return err;
 	spec = codec->spec;
 
+	spec->gen.mixer_nid = 0x0e;
 	spec->gen.beep_nid = 0x10;
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
 	err = ad198x_parse_auto_config(codec);
-- 
1.9.0

