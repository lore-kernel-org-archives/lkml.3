Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab3K0BaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:30:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab3K0A6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 041/116] ALSA: hda - Apply GPIO setup for MacBooks with CS4208
Date: Tue, 26 Nov 2013 16:56:54 -0800
Message-Id: <20131127005739.794923643@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8fe7b65ab4656e5db466a7d98b1fd48ff83b2c64 upstream.

Apply the existing GPIO0 fixup as default for MacBooks with CS4208
codec.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64401
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_cirrus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -611,6 +611,7 @@ static const struct snd_pci_quirk cs4208
 	/* codec SSID */
 	SND_PCI_QUIRK(0x106b, 0x7100, "MacBookAir 6,1", CS4208_MBA6),
 	SND_PCI_QUIRK(0x106b, 0x7200, "MacBookAir 6,2", CS4208_MBA6),
+	SND_PCI_QUIRK_VENDOR(0x106b, "Apple", CS4208_GPIO0),
 	{} /* terminator */
 };
 


