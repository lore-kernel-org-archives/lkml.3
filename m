Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3LBOig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:38:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab3LBOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:38:30 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] firmware: Suppress fallback warnings when CONFIG_FW_LOADER_USER_HELPER=n
Date: Mon,  2 Dec 2013 15:38:19 +0100
Message-Id: <1385995099-11901-5-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385995099-11901-1-git-send-email-tiwai@suse.de>
References: <1385995099-11901-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit [3e358ac2bb5b: firmware: Be a bit more verbose about direct
firmware loading failure] introduced a new warning message about
falling back to user helper, but this isn't true when
CONFIG_FW_LOADER_USER_HELPER isn't set.

In this patch, clear the FW_OPT_FALLBACK flag in the case without
userhelper, so that the corresponding code will be disabled.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/firmware_class.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 65797742c6b6..33b87bf664ab 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -99,7 +99,11 @@ static inline long firmware_loading_timeout(void)
 /* firmware behavior options */
 #define FW_OPT_UEVENT	(1U << 0)
 #define FW_OPT_NOWAIT	(1U << 1)
+#ifdef CONFIG_FW_LOADER_USER_HELPER
 #define FW_OPT_FALLBACK	(1U << 2)
+#else
+#define FW_OPT_FALLBACK	0
+#endif
 
 struct firmware_cache {
 	/* firmware_buf instance will be added into the below list */
-- 
1.8.4.4

