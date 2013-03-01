Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab3CATpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3CATpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 03/77] ALSA: hda - hdmi: Make jacks phantom, if theyre not detectable
Date: Fri,  1 Mar 2013 11:43:48 -0800
Message-Id: <20130301194352.319556541@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 30efd8debd1ef30be342d374f01e993509f5b76b upstream.

Just as for analog codecs, a jack that isn't suitable for detection
(in this case, NO_PRESENCE was set) should be a phantom Jack
instead of a normal one.

Thanks to Raymond Yau for spotting.

BugLink: https://bugs.launchpad.net/bugs/961286
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=903869
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1573,6 +1573,9 @@ static int generic_hdmi_build_jack(struc
 
 	if (pcmdev > 0)
 		sprintf(hdmi_str + strlen(hdmi_str), ",pcm=%d", pcmdev);
+	if (!is_jack_detectable(codec, per_pin->pin_nid))
+		strncat(hdmi_str, " Phantom",
+			sizeof(hdmi_str) - strlen(hdmi_str) - 1);
 
 	return snd_hda_jack_add_kctl(codec, per_pin->pin_nid, hdmi_str, 0);
 }


