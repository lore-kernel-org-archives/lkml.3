Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab3B0BIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:08:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162Ab3BZX5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 053/150] ALSA: hda - Disable runtime PM for Intel 5 Series/3400
Date: Tue, 26 Feb 2013 15:55:10 -0800
Message-Id: <20130226235529.665984912@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2c1350fdeaefefe1a149d3b083383409f43f0daa upstream.

We've got a regression report wrt the IRQ issue related with the
power-save on a Dell machine, and disabling runtime PM works around.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=53441

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3624,7 +3624,7 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids)
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH },
 	/* 5 Series/3400 */
 	{ PCI_DEVICE(0x8086, 0x3b56),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Poulsbo */
 	{ PCI_DEVICE(0x8086, 0x811b),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },


