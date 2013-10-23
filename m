Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3JWNsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:48:10 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:60522 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3JWNsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:48:07 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen@asianux.com>, Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
Thread-Topic: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
Thread-Index: AQHOz+CNfxdrFiqJVE276Bbxr7amH5oCTHE8
Date: Wed, 23 Oct 2013 13:47:56 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075152B30@IN01WEMBXA.internal.synopsys.com>
References: <5267AE7D.4080600@asianux.com>
In-Reply-To: <5267AE7D.4080600@asianux.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.144.160.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for top posting !

NAK.

ARC will never have VGA console. You need to add !ARC to relevant Kconfig. However that approach is frowned upon in general. The current way to doing such things is to define a new Kconfig item which relevant arches can select.

-Vineet
________________________________________
From: Chen Gang [gang.chen@asianux.com]
Sent: Wednesday, October 23, 2013 4:39 PM
To: vgupta@synopsys.com; Arnd Bergmann; sachin.kamat@linaro.org; Paul Gortmaker; James Hogan
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arc: kernel: add default extern variable 'screen_info' in "setup.c"

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
@@ -37,6 +38,8 @@ struct task_struct *_current_task[NR_CPUS];   /* For stack switching */

 struct cpuinfo_arc cpuinfo_arc700[NR_CPUS];

+struct screen_info screen_info;
+

 void read_arc_build_cfg_regs(void)
 {
--
1.7.7.6
