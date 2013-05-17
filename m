Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3EQW1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:27:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab3EQVhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 009/102] Revert "ALSA: hda - Dont set up active streams twice"
Date: Fri, 17 May 2013 14:35:24 -0700
Message-Id: <20130517213245.297834106@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6c35ae3c327ef4b5f51d3428d2ba47ac2153e882 upstream.

This reverts commit affdb62b815b38261f09f9d4ec210a35c7ffb1f3.

The commit introduced a regression with AD codecs where the stream is
always clean up.  Since the patch is just a minor optimization and
reverting the commit fixes the issue, let's just revert it.

Reported-and-tested-by: Michael Burian <michael.burian@sbg.at>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1577,7 +1577,7 @@ void snd_hda_codec_setup_stream(struct h
 		    "NID=0x%x, stream=0x%x, channel=%d, format=0x%x\n",
 		    nid, stream_tag, channel_id, format);
 	p = get_hda_cvt_setup(codec, nid);
-	if (!p || p->active)
+	if (!p)
 		return;
 
 	if (codec->pcm_format_first)
@@ -1624,7 +1624,7 @@ void __snd_hda_codec_cleanup_stream(stru
 
 	snd_printdd("hda_codec_cleanup_stream: NID=0x%x\n", nid);
 	p = get_hda_cvt_setup(codec, nid);
-	if (p && p->active) {
+	if (p) {
 		/* here we just clear the active flag when do_now isn't set;
 		 * actual clean-ups will be done later in
 		 * purify_inactive_streams() called from snd_hda_codec_prpapre()


