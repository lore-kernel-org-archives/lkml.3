Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3BANLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:11:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:45022 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab3BANLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:11:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 46/89] ALSA: hda - fix inverted internal mic on Acer AOA150/ZG5
Date: Fri,  1 Feb 2013 14:08:01 +0100
Message-Id: <20130201130210.805339417@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit fcd8f3b1d43c645e291638bc6c80a1c680722869 upstream.

This patch enables internal mic input on the machine.

BugLink: https://bugs.launchpad.net/bugs/1107477
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5703,6 +5703,7 @@ static const struct alc_model_fixup alc2
 };
 
 static const struct snd_pci_quirk alc268_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1025, 0x015b, "Acer AOA 150 (ZG5)", ALC268_FIXUP_INV_DMIC),
 	/* below is codec SSID since multiple Toshiba laptops have the
 	 * same PCI SSID 1179:ff00
 	 */


