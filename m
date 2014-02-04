Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbaBDVeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:34:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934584AbaBDVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Doro Wu <fan-cheng.wu@canonical.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 092/140] ALSA: hda - add headset mic detect quirks for another Dell laptop
Date: Tue,  4 Feb 2014 13:11:19 -0800
Message-Id: <20140204211039.600275521@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

commit 5e87d5807110afd6bd659e1b98929fab43f3732f upstream.

When we plug a 3-ring headset on the Dell machine (Vendor ID:
0x10ec0255, Subsystem ID: 0x1028064d), the headset mic can't be
detected, after apply this patch, the headset mic can work well.

BugLink: https://bugs.launchpad.net/bugs/1260303
Cc: David Henningsson <david.henningsson@canonical.com>
Tested-by: Doro Wu <fan-cheng.wu@canonical.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4284,6 +4284,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x063e, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x063f, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0640, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x064d, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0651, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0652, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0653, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE),


