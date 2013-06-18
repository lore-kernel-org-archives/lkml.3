Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3FRKU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:20:28 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56457 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3FRKU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:20:27 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/2] mfd: davinci_voicecodec: Fix build breakage
Date: Tue, 18 Jun 2013 15:35:39 +0530
Message-Id: <1371549940-18834-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the missing header file to fix the following build error:
drivers/mfd/davinci_voicecodec.c: In function ‘davinci_vc_probe’:
drivers/mfd/davinci_voicecodec.c:86:3: error: implicit declaration of function
‘io_v2p’ [-Werror=implicit-function-declaration]
   (dma_addr_t)(io_v2p(davinci_vc->base) + DAVINCI_VC_WFIFO);

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
This series is based on Samuel's mfd-next tree and is compile tested.
---
 include/linux/mfd/davinci_voicecodec.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mfd/davinci_voicecodec.h b/include/linux/mfd/davinci_voicecodec.h
index 0ab6132..6b0e974 100644
--- a/include/linux/mfd/davinci_voicecodec.h
+++ b/include/linux/mfd/davinci_voicecodec.h
@@ -28,6 +28,7 @@
 #include <linux/mfd/core.h>
 
 #include <mach/edma.h>
+#include <mach/hardware.h>
 
 /*
  * Register values.
-- 
1.7.9.5

