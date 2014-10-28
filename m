Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbaJ1Hq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:46:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbaJ1DjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:39:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.17 077/146] ALSA: hda - Fix inverted LED gpio setup for Lenovo Ideapad
Date: Tue, 28 Oct 2014 11:33:39 +0800
Message-Id: <20141028033346.731584978@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b1974f965a506c131b60cd3e483340884e831920 upstream.

We implemented in a wrong way for mute LED on Lenovo Ideapad; the bit
must be flipped.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=16373
Fixes: 3e887f379d8a ('ALSA: hda - Add mute LED support to Lenovo Ideapad')
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5786,9 +5786,9 @@ static void alc662_led_gpio1_mute_hook(v
 	unsigned int oldval = spec->gpio_led;
 
 	if (enabled)
-		spec->gpio_led &= ~0x01;
-	else
 		spec->gpio_led |= 0x01;
+	else
+		spec->gpio_led &= ~0x01;
 	if (spec->gpio_led != oldval)
 		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_DATA,
 				    spec->gpio_led);


