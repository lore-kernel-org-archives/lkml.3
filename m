Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423154AbaDKQXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:23:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbaDKQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20G=C3=BCdel?= <cg@dmesg.ch>,
        Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 01/23] Revert "ALSA: hda - Increment default stream numbers for AMD HDMI controllers"
Date: Fri, 11 Apr 2014 09:11:50 -0700
Message-Id: <20140411161200.446445522@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411161200.236939691@linuxfoundation.org>
References: <20140411161200.236939691@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

This reverts commit 7546abfb8e1f9933b549f05898377e9444ee4cb2.

The commit [7546abfb: ALSA: hda - Increment default stream numbers for
AMD HDMI controllers] introduced a regression where the AMD HDMI
playback streams don't work properly.  As the simplest fix, this patch
reverts that commit.

The upstream code has been changed largely and already contains
another fix (by changing the stream assignment order), this revert
should be applied only to 3.14 kernel where the regression was
introduced.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77002
Reported-by: Christian Güdel <cg@dmesg.ch>
Reported-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Greg, there is no upstream commit id due to the reason describe in the
above.  It's a simple revert, so please take as is.

thanks,

Takashi

 sound/pci/hda/hda_intel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -297,9 +297,9 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO
 #define ULI_NUM_CAPTURE		5
 #define ULI_NUM_PLAYBACK	6
 
-/* ATI HDMI may have up to 8 playbacks and 0 capture */
+/* ATI HDMI has 1 playback and 0 capture */
 #define ATIHDMI_NUM_CAPTURE	0
-#define ATIHDMI_NUM_PLAYBACK	8
+#define ATIHDMI_NUM_PLAYBACK	1
 
 /* TERA has 4 playback and 3 capture */
 #define TERA_NUM_CAPTURE	3


