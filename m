Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3JWLK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:10:56 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6055 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3JWLKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:10:55 -0400
X-Spam-Score: -100.8
Message-ID: <5267AE7D.4080600@asianux.com>
Date: Wed, 23 Oct 2013 19:09:49 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        sachin.kamat@linaro.org, Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: kernel: add default extern variable 'screen_info' in
 "setup.c"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add default 'screen_info' just like some of other architectures (e.g.
cris, score, sh, tile), or can not pass compiling.

The related error (with allmodconfig):

  drivers/built-in.o: In function `vgacon_save_screen':
  drivers/video/console/vgacon.c:1347: undefined reference to `screen_info'
  drivers/video/console/vgacon.c:1348: undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_resize':
  drivers/video/console/vgacon.c:1314: undefined reference to `screen_info'
  drivers/video/console/vgacon.c:1315: undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_switch':
  drivers/video/console/vgacon.c:820: undefined reference to `screen_info'
  drivers/built-in.o:drivers/video/console/vgacon.c:840: more undefined references to `screen_info' follow


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/kernel/setup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 2c68bc7e..07130f3 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/of_fdt.h>
 #include <linux/cache.h>
+#include <linux/screen_info.h>
 #include <asm/sections.h>
 #include <asm/arcregs.h>
 #include <asm/tlb.h>
@@ -37,6 +38,8 @@ struct task_struct *_current_task[NR_CPUS];	/* For stack switching */
 
 struct cpuinfo_arc cpuinfo_arc700[NR_CPUS];
 
+struct screen_info screen_info;
+
 
 void read_arc_build_cfg_regs(void)
 {
-- 
1.7.7.6
