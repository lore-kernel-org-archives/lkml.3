Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaJ1DjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:39:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaJ1DjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:39:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.17 078/146] ALSA: hda - Add missing terminating entry to SND_HDA_PIN_QUIRK macro
Date: Tue, 28 Oct 2014 11:33:40 +0800
Message-Id: <20141028033346.779556219@linuxfoundation.org>
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

From: David Henningsson <david.henningsson@canonical.com>

commit fb54a645b2739fb196446ffbbbe3f3589d117b55 upstream.

Without this terminating entry, the pin matching would continue
across random memory until a zero or a non-matching entry was found.

The result being that in some cases, the pin quirk would not be
applied correctly.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_local.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -425,7 +425,7 @@ struct snd_hda_pin_quirk {
 	  .subvendor = _subvendor,\
 	  .name = _name,\
 	  .value = _value,\
-	  .pins = (const struct hda_pintbl[]) { _pins } \
+	  .pins = (const struct hda_pintbl[]) { _pins, {0, 0}} \
 	}
 #else
 
@@ -433,7 +433,7 @@ struct snd_hda_pin_quirk {
 	{ .codec = _codec,\
 	  .subvendor = _subvendor,\
 	  .value = _value,\
-	  .pins = (const struct hda_pintbl[]) { _pins } \
+	  .pins = (const struct hda_pintbl[]) { _pins, {0, 0}} \
 	}
 
 #endif


