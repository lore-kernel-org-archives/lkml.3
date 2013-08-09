Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967817Ab3HICTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:19:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967445Ab3HIB6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haynes <hgeorge@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 021/102] ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION
Date: Thu,  8 Aug 2013 18:56:57 -0700
Message-Id: <20130809015014.991214954@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vinod.koul@intel.com>

commit a8d30608eaed6cc759b8e2e8a8bbbb42591f797f upstream.

the return value of SNDRV_COMPRESS_VERSION always return default -ENOTTY as the
return value was never updated for this call
assign return value from put_user()

Reported-by: Haynes <hgeorge@codeaurora.org>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/compress_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -743,7 +743,7 @@ static long snd_compr_ioctl(struct file
 	mutex_lock(&stream->device->lock);
 	switch (_IOC_NR(cmd)) {
 	case _IOC_NR(SNDRV_COMPRESS_IOCTL_VERSION):
-		put_user(SNDRV_COMPRESS_VERSION,
+		retval = put_user(SNDRV_COMPRESS_VERSION,
 				(int __user *)arg) ? -EFAULT : 0;
 		break;
 	case _IOC_NR(SNDRV_COMPRESS_GET_CAPS):


