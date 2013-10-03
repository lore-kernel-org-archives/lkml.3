Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3JCEPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:15:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3JCEPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:15:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 51/52] ALSA: compress: Fix compress device unregister.
Date: Wed,  2 Oct 2013 21:06:09 -0700
Message-Id: <20131003040525.719610740@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Girdwood <liam.r.girdwood@linux.intel.com>

commit 4028b6c4c03f213260e9290ff3a6b5439aad07ce upstream.

snd_unregister_device() should return the device type and not stream
direction.

Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
Tested-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/compress_offload.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -837,7 +837,8 @@ static int snd_compress_dev_disconnect(s
 	struct snd_compr *compr;
 
 	compr = device->device_data;
-	snd_unregister_device(compr->direction, compr->card, compr->device);
+	snd_unregister_device(SNDRV_DEVICE_TYPE_COMPRESS, compr->card,
+		compr->device);
 	return 0;
 }
 


