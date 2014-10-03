Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbaJCX5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:57:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbaJCVxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 043/238] ALSA: hda - Fix COEF setups for ALC1150 codec
Date: Fri,  3 Oct 2014 14:29:18 -0700
Message-Id: <20141003212915.037053068@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit acf08081adb5e8fe0519eb97bb49797ef52614d6 upstream.

ALC1150 codec seems to need the COEF- and PLL-setups just like its
compatible ALC882 codec.  Some machines (e.g. SunMicro X10SAT) show
the problem like too low output volumes unless the COEF setup is
applied.

Reported-and-tested-by: Dana Goyette <danagoyette@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -327,6 +327,7 @@ static void alc_auto_init_amp(struct hda
 		case 0x10ec0885:
 		case 0x10ec0887:
 		/*case 0x10ec0889:*/ /* this causes an SPDIF problem */
+		case 0x10ec0900:
 			alc889_coef_init(codec);
 			break;
 		case 0x10ec0888:
@@ -2330,6 +2331,7 @@ static int patch_alc882(struct hda_codec
 	switch (codec->vendor_id) {
 	case 0x10ec0882:
 	case 0x10ec0885:
+	case 0x10ec0900:
 		break;
 	default:
 		/* ALC883 and variants */


