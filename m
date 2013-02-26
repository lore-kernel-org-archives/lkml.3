Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab3B0BJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:09:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760154Ab3BZX5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [ 051/150] ALSA: usb/quirks, fix out-of-bounds access
Date: Tue, 26 Feb 2013 15:55:08 -0800
Message-Id: <20130226235529.470214340@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 4909a0caabb8b4352efcea223e58b86f8bc1f98b upstream.

bootresponse in snd_usb_mbox2_boot_quirk is only 12 (decimal) u8's
long, but i9s passed to snd_usb_ctl_msg as it would be 0x12 (hexa)
long. Fix that by having proper size of the array, i.e. 0x12.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -533,7 +533,7 @@ static int snd_usb_mbox2_boot_quirk(stru
 {
 	struct usb_host_config *config = dev->actconfig;
 	int err;
-	u8 bootresponse[12];
+	u8 bootresponse[0x12];
 	int fwsize;
 	int count;
 


