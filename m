Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3CDEDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:03:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347Ab3CDDnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:37 -0500
Message-Id: <20130304033716.795093499@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 093/153] ALSA: hda - hdmi: Make jacks phantom, if theyre not detectable
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_hdmi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1228,6 +1228,9 @@ static int generic_hdmi_build_jack(struc
 	int pcmdev = spec->pcm_rec[pin_idx].device;
 
 	snprintf(hdmi_str, sizeof(hdmi_str), "HDMI/DP,pcm=%d", pcmdev);
+	if (!is_jack_detectable(codec, per_pin->pin_nid))
+		strncat(hdmi_str, " Phantom",
+			sizeof(hdmi_str) - strlen(hdmi_str) - 1);
 
 	err = snd_hda_input_jack_add(codec, per_pin->pin_nid,
 			     SND_JACK_VIDEOOUT, pcmdev > 0 ? hdmi_str : NULL);


