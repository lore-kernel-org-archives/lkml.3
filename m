Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3CAU0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:26:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3CATpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Zeitz <florob@babelmonkeys.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 05/77] ALSA: emu10k1: Load firmware when it was already cached
Date: Fri,  1 Mar 2013 11:43:50 -0800
Message-Id: <20130301194352.507039388@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Zeitz <florob@babelmonkeys.de>

commit b56ddbe55a363eee4ff7410a97050dad08215f7c upstream.

This expands the regression fix from
d28215996b0c3a900411769039aa3c54cf7008ab.
The firmware also needs to be loaded when it was already cached.

Signed-off-by: Florian Zeitz <florob@babelmonkeys.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/emu10k1/emu10k1_main.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -860,11 +860,12 @@ static int snd_emu10k1_emu1010_init(stru
 		}
 		snd_printk(KERN_INFO "emu1010: firmware file = %s, size = 0x%zx\n",
 			   filename, emu->firmware->size);
-		err = snd_emu1010_load_firmware(emu);
-		if (err != 0) {
-			snd_printk(KERN_INFO "emu1010: Loading Firmware file %s failed\n", filename);
-			return err;
-		}
+	}
+
+	err = snd_emu1010_load_firmware(emu);
+	if (err != 0) {
+		snd_printk(KERN_INFO "emu1010: Loading Firmware failed\n");
+		return err;
 	}
 
 	/* ID, should read & 0x7f = 0x55 when FPGA programmed. */


