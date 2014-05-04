Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaEDPyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:54:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaEDPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "W. Trevor King" <wking@tremily.us>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.4 06/43] ALSA: hda - Enable beep for ASUS 1015E
Date: Sun,  4 May 2014 11:42:00 -0400
Message-Id: <20140504154225.100640176@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4323,6 +4323,7 @@ static void alc_auto_init_std(struct hda
 
 static const struct snd_pci_quirk beep_white_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x103c, "ASUS", 1),
+	SND_PCI_QUIRK(0x1043, 0x115d, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
 	SND_PCI_QUIRK(0x1043, 0x831a, "EeePC", 1),


