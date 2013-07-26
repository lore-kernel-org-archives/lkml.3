Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab3GZUwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:52:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760016Ab3GZUs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 77/79] ALSA: hda - Remove NO_PRESENCE bit override for Dell 1420n Laptop
Date: Fri, 26 Jul 2013 13:48:07 -0700
Message-Id: <20130726204730.909846876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f3e351eef3a7fd1e36a3e18d4f2f069b00deb23c upstream.

The quirk for Dell laptops with STAC9228 overrides the pin default
config of NID 0x0f to the value with AC_DEFCFG_MISC_NO_PRESENCE bit
on.  I'm not quite sure why this was done so, but can guess that this
was introduced for avoiding this to be muted by another headphone
plug.  Now, after transition to the generic parser, this workaround
rather causes a problem (notably as unexpected speaker mutes) because
the pin is seen as if it's always plugged in.

Since the generic parser can handle multiple headphone plugging
gracefully, we can get rid of this override now.

Reported-and-tested-by: Eric Shattow <lucent@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -3227,7 +3227,7 @@ static const struct hda_fixup stac927x_f
 			/* configure the analog microphone on some laptops */
 			{ 0x0c, 0x90a79130 },
 			/* correct the front output jack as a hp out */
-			{ 0x0f, 0x0227011f },
+			{ 0x0f, 0x0221101f },
 			/* correct the front input jack as a mic */
 			{ 0x0e, 0x02a79130 },
 			{}


