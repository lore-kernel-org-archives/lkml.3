Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaLSLjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:39:03 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:9612 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaLSLjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:39:01 -0500
From: Qais Yousef <qais.yousef@imgtec.com>
To: <alsa-devel@alsa-project.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Vinod Koul <vinod.koul@intel.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: compress_driver.h: include sound/core.h explicitly
Date: Fri, 19 Dec 2014 11:38:30 +0000
Message-ID: <1418989110-10011-1-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following compilation error:

   include/sound/compress_driver.h: In function ‘snd_compr_drain_notify’:
   include/sound/compress_driver.h:177:2: error: implicit declaration of function ‘snd_BUG_ON’ [-Werror=implicit-function-declaration]
     if (snd_BUG_ON(!stream))

snd_BUG_ON() is defined in sound/core.h but the file is not included explicitly,
so include it.

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org

---
 include/sound/compress_driver.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/sound/compress_driver.h b/include/sound/compress_driver.h
index 396e8f73670a..1e2531058b7e 100644
--- a/include/sound/compress_driver.h
+++ b/include/sound/compress_driver.h
@@ -27,6 +27,7 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <sound/core.h>
 #include <sound/compress_offload.h>
 #include <sound/asound.h>
 #include <sound/pcm.h>
-- 
2.1.0

