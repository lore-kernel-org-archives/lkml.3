Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaGZTM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:12:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaGZTKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:10:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 05/87] ALSA: hda - initialize audio InfoFrame to be all zero
Date: Sat, 26 Jul 2014 12:01:39 -0700
Message-Id: <20140726190214.704707871@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengdong Lin <mengdong.lin@intel.com>

commit caaf5ef9493f72390905f1e97b310b8906d32dac upstream.

This patch initialized the local audio InfoFrame variable 'ai' to be all zero,
thus the data bytes will indicate "Refer to Stream Header" by default.

Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1062,6 +1062,7 @@ static void hdmi_pin_setup_infoframe(str
 {
 	union audio_infoframe ai;
 
+	memset(&ai, 0, sizeof(ai));
 	if (conn_type == 0) { /* HDMI */
 		struct hdmi_audio_infoframe *hdmi_ai = &ai.hdmi;
 


