Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935405AbaBDWNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:13:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011AbaBDVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 079/133] ALSA: hda - Correct AD1986A 3stack pin configs
Date: Tue,  4 Feb 2014 13:08:00 -0800
Message-Id: <20140204210739.264460571@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ed0e0d0617a8dc3d8b82c6e54827f269f2247b07 upstream.

The 3stack pin configs for AD1986A codec had incorrect values that
resulted in broken mic and line-in.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66621
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -264,11 +264,11 @@ static const struct hda_fixup ad1986a_fi
 		.v.pins = (const struct hda_pintbl[]) {
 			{ 0x1a, 0x02214021 }, /* headphone */
 			{ 0x1b, 0x01014011 }, /* front */
-			{ 0x1c, 0x01013012 }, /* surround */
-			{ 0x1d, 0x01019015 }, /* clfe */
+			{ 0x1c, 0x01813030 }, /* line-in */
+			{ 0x1d, 0x01a19020 }, /* rear mic */
 			{ 0x1e, 0x411111f0 }, /* N/A */
 			{ 0x1f, 0x02a190f0 }, /* mic */
-			{ 0x20, 0x018130f0 }, /* line-in */
+			{ 0x20, 0x411111f0 }, /* N/A */
 			{}
 		},
 	},


