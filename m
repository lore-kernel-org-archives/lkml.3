Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3CAU0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:26:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3CATpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mihail Zenkov <mihail.zenkov@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 04/77] ALSA: emu10k1: Fix regression in emu1010 firmware loading
Date: Fri,  1 Mar 2013 11:43:49 -0800
Message-Id: <20130301194352.416358715@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mihail Zenkov <mihail.zenkov@gmail.com>

commit d28215996b0c3a900411769039aa3c54cf7008ab upstream.

This patch fix regression in emu1010 firmware loading after
http://git.alsa-project.org/?p=alsa-kprivate.git;a=commitdiff;h=b209c4dfcd960ab176d4746ab7dc442a3edb4575

I just revert small part of this commit. Tested on emu1212m pci.

Signed-off-by: Mihail Zenkov <mihail.zenkov@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/emu10k1/emu10k1_main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -860,6 +860,11 @@ static int snd_emu10k1_emu1010_init(stru
 		}
 		snd_printk(KERN_INFO "emu1010: firmware file = %s, size = 0x%zx\n",
 			   filename, emu->firmware->size);
+		err = snd_emu1010_load_firmware(emu);
+		if (err != 0) {
+			snd_printk(KERN_INFO "emu1010: Loading Firmware file %s failed\n", filename);
+			return err;
+		}
 	}
 
 	/* ID, should read & 0x7f = 0x55 when FPGA programmed. */


