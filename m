Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab3K0BfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:35:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3K0A6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 3.12 017/116] thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS > 32
Date: Tue, 26 Nov 2013 16:56:30 -0800
Message-Id: <20131127005738.141853766@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit cab6661344f14a09d7aecdf821a40f68ef9b18cc upstream.

SNDRV_CARDS can be specified via Kconfig since 3.11 kernel, so this
can be over 32bit integer range, which leads to a build error.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/thinkpad_acpi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6420,7 +6420,12 @@ static struct ibm_struct brightness_driv
 #define TPACPI_ALSA_SHRTNAME "ThinkPad Console Audio Control"
 #define TPACPI_ALSA_MIXERNAME TPACPI_ALSA_SHRTNAME
 
-static int alsa_index = ~((1 << (SNDRV_CARDS - 3)) - 1); /* last three slots */
+#if SNDRV_CARDS <= 32
+#define DEFAULT_ALSA_IDX		~((1 << (SNDRV_CARDS - 3)) - 1)
+#else
+#define DEFAULT_ALSA_IDX		~((1 << (32 - 3)) - 1)
+#endif
+static int alsa_index = DEFAULT_ALSA_IDX; /* last three slots */
 static char *alsa_id = "ThinkPadEC";
 static bool alsa_enable = SNDRV_DEFAULT_ENABLE1;
 


