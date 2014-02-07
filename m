Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaBGQmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:42:00 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43872 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaBGQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:41:59 -0500
Date: Fri, 7 Feb 2014 22:11:53 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rashika Kheria <rashika.kheria@gmail.com>, alsa-devel@alsa-project.org,
        josh@joshtriplett.org
Subject: [PATCH 1/3] sound: Include appropriate header file in
 pcsp/pcsp_input.c
Message-ID: <512472c7d96cf1c239ba3d0bc517891a7c2f9da1.1391791103.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file in drivers/pcsp/pcsp_input.c because it
defines function whose prototype definitions are present in
drivers/pcsp/pcsp_input.h.

This eliminates the following warning in drivers/pcsp/pcsp_input.c:
sound/drivers/pcsp/pcsp_input.c:42:6: warning: no previous prototype for ‘pcspkr_stop_sound’ [-Wmissing-prototypes]
sound/drivers/pcsp/pcsp_input.c:80:5: warning: no previous prototype for ‘pcspkr_input_init’ [-Wmissing-prototypes]
sound/drivers/pcsp/pcsp_input.c:110:5: warning: no previous prototype for ‘pcspkr_input_remove’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 sound/drivers/pcsp/pcsp_input.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/drivers/pcsp/pcsp_input.c b/sound/drivers/pcsp/pcsp_input.c
index b874b0a..0ecf8a4 100644
--- a/sound/drivers/pcsp/pcsp_input.c
+++ b/sound/drivers/pcsp/pcsp_input.c
@@ -16,6 +16,7 @@
 #include <linux/input.h>
 #include <asm/io.h>
 #include "pcsp.h"
+#include "pcsp_input.h"
 
 static void pcspkr_do_sound(unsigned int count)
 {
-- 
1.7.9.5

