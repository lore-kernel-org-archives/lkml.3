Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaD1BdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42871 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "W. Trevor King" <wking@tremily.us>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.727061442@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 69/94] ALSA: hda - Enable beep for ASUS 1015E
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "W. Trevor King" <wking@tremily.us>

commit a4b7f21d7b42b33609df3f86992a8deff80abfaf upstream.

The `lspci -nnvv` output contains (wrapped for line length):

  00:1b.0 Audio device [0403]:
    Intel Corporation 7 Series/C210 Series Chipset Family
    High Definition Audio Controller [8086:1e20] (rev 04)
        Subsystem: ASUSTeK Computer Inc. Device [1043:115d]

Signed-off-by: W. Trevor King <wking@tremily.us>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3855,6 +3855,7 @@ static void alc_auto_init_std(struct hda
 
 static const struct snd_pci_quirk beep_white_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x103c, "ASUS", 1),
+	SND_PCI_QUIRK(0x1043, 0x115d, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
 	SND_PCI_QUIRK(0x1043, 0x831a, "EeePC", 1),

