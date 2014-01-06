Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbaAFWkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:40:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbaAFWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 012/129] ALSA: hda - Add enable_msi=0 workaround for four HP machines
Date: Mon,  6 Jan 2014 14:37:21 -0800
Message-Id: <20140106223859.938296675@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 693e0cb052c607e2d41edf9e9f1fa99ff8c266c1 upstream.

While enabling these machines, we found we would sometimes lose an
interrupt if we change hardware volume during playback, and that
disabling msi fixed this issue. (Losing the interrupt caused underruns
and crackling audio, as the one second timeout is usually bigger than
the period size.)

The machines were all machines from HP, running AMD Hudson controller,
and Realtek ALC282 codec.

BugLink: https://bugs.launchpad.net/bugs/1260225
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3332,6 +3332,10 @@ static void check_probe_mask(struct azx
  * white/black-list for enable_msi
  */
 static struct snd_pci_quirk msi_black_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x2191, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x2192, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x21f7, "HP", 0), /* AMD Hudson */
+	SND_PCI_QUIRK(0x103c, 0x21fa, "HP", 0), /* AMD Hudson */
 	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
 	SND_PCI_QUIRK(0x1043, 0x822d, "ASUS", 0), /* Athlon64 X2 + nvidia MCP55 */


