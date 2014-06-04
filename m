Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbaFEAPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:15:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaFDXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 147/228] ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets
Date: Wed,  4 Jun 2014 16:22:56 -0700
Message-Id: <20140604232352.743425257@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 77f07800cb456bed6e5c345e6e4e83e8eda62437 upstream.

The recent Intel H97/Z97 chipsets need the similar setups like other
Intel chipsets for snooping, etc.  Especially without snooping, the
audio playback stutters or gets corrupted.  This fix patch just adds
the corresponding PCI ID entry with the proper flags.

Reported-and-tested-by: Arthur Borsboom <arthurborsboom@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3988,6 +3988,9 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids)
 	/* Lynx Point */
 	{ PCI_DEVICE(0x8086, 0x8c20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
+	/* 9 Series */
+	{ PCI_DEVICE(0x8086, 0x8ca0),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
 	/* Wellsburg */
 	{ PCI_DEVICE(0x8086, 0x8d20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },


