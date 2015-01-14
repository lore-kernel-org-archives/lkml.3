Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbbANI1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:27:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbbANH17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.18 080/150] ALSA: snd-usb-caiaq: fix stream count check
Date: Tue, 13 Jan 2015 23:22:31 -0800
Message-Id: <20150114072059.470093346@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <daniel@zonque.org>

commit 49cdd5b641933fda6324fc901eaf856924ba6a27 upstream.

Commit 897c329bc ("ALSA: usb: caiaq: check for cdev->n_streams > 1")
introduced a safety check to protect against bogus data provided by
devices. However, the n_streams variable is already divided by
CHANNELS_PER_STREAM, so the correct check is 'n_streams > 0'.

Fix this to un-break support for stereo devices.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/caiaq/audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -816,7 +816,7 @@ int snd_usb_caiaq_audio_init(struct snd_
 		return -EINVAL;
 	}
 
-	if (cdev->n_streams < 2) {
+	if (cdev->n_streams < 1) {
 		dev_err(dev, "bogus number of streams: %d\n", cdev->n_streams);
 		return -EINVAL;
 	}


