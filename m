Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937615Ab3DJWuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:50:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937447Ab3DJWuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mengdong Lin <mengdong.lin@intel.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 04/19] ALSA: hda - bug fix on return value when getting HDMI ELD info
Date: Wed, 10 Apr 2013 15:50:27 -0700
Message-Id: <20130410225027.271964003@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410225026.833809117@linuxfoundation.org>
References: <20130410225026.833809117@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengdong Lin <mengdong.lin@intel.com>

commit 2ef5692efad330b67a234e2c49edad38538751e7 upstream.

In function snd_hdmi_get_eld(), the variable 'ret' should be initialized to 0.
Otherwise it will be returned uninitialized as non-zero after ELD info is got
successfully. Thus hdmi_present_sense() will always assume ELD info is invalid
by mistake, and /proc file system cannot show the proper ELD info.

Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
Acked-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_eld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -322,7 +322,7 @@ int snd_hdmi_get_eld(struct hdmi_eld *el
 		     struct hda_codec *codec, hda_nid_t nid)
 {
 	int i;
-	int ret;
+	int ret = 0;
 	int size;
 	unsigned char *buf;
 


