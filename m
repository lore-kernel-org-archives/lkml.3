Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab3BZX5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212Ab3BZX5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 056/150] ALSA: hda - Workaround for silent output on Sony Vaio VGC-LN51JGB with ALC889
Date: Tue, 26 Feb 2013 15:55:13 -0800
Message-Id: <20130226235529.987201933@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

commit 12e31a78c70dc12897fda2489113f445c0e94a18 upstream.

Some Vaio all-in-one desktop PCs (for example VGC-LN51JGB) are affected by
the same issue that caused Vaio Z laptops to become silent: the speaker pin
must be connected to the first DAC even though the codec itself advertises
flexible routing through any of the DACs.

Use the no-primary-hp fixup for choosing the speaker pin as the primary so
that the right DAC is assigned on this device.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5394,6 +5394,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1043, 0x835f, "Asus Eee 1601", ALC888_FIXUP_EEE1601),
 	SND_PCI_QUIRK(0x104d, 0x9047, "Sony Vaio TT", ALC889_FIXUP_VAIO_TT),
 	SND_PCI_QUIRK(0x104d, 0x905a, "Sony Vaio Z", ALC882_FIXUP_NO_PRIMARY_HP),
+	SND_PCI_QUIRK(0x104d, 0x9043, "Sony Vaio VGC-LN51JGB", ALC882_FIXUP_NO_PRIMARY_HP),
 
 	/* All Apple entries are in codec SSIDs */
 	SND_PCI_QUIRK(0x106b, 0x00a0, "MacBookPro 3,1", ALC889_FIXUP_MBP_VREF),


