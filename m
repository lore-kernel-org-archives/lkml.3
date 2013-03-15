Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3COWUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:20:41 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.12]:60025 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947Ab3COWUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:20:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1363386037!5931173!3
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] video: ep93xx_fb: include <linux/io.h> for devm_ioremap()
Date: Fri, 15 Mar 2013 15:20:26 -0700
User-Agent: KMail/1.9.9
CC: <linux-fbdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <FlorianSchandinat@gmx.de>, <rmallon@gmail.com>,
        <damien.cassou@lifl.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201303151520.26873.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit be867814 "drivers/video/ep93xx-fb.c: use devm_ functions"

Introduced a build error:

drivers/video/ep93xx-fb.c: In function 'ep93xxfb_probe':
drivers/video/ep93xx-fb.c:532: error: implicit declaration of function 'devm_ioremap'
drivers/video/ep93xx-fb.c:533: warning: assignment makes pointer from integer without a cast

Include <linux/io.h> to pickup the declaration of 'devm_ioremap'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: <stable@vger.kernel.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Damien Cassou <damien.cassou@lifl.fr>

---
 drivers/video/ep93xx-fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
index 3f2519d..e06cd5d 100644
--- a/drivers/video/ep93xx-fb.c
+++ b/drivers/video/ep93xx-fb.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/fb.h>
+#include <linux/io.h>
 
 #include <linux/platform_data/video-ep93xx.h>
 
-- 
1.8.1.4

