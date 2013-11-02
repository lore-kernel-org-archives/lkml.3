Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3KBOI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 10:08:59 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49740 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3KBOI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 10:08:58 -0400
Message-ID: <52750739.6040706@gmail.com>
Date: Sat, 02 Nov 2013 22:07:53 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Chen Gang <gang.chen@asianux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] about latest commit for "scripts/get_maintainers.pl"
References: <52738E90.6040104@asianux.com> <1383330777.3042.2.camel@joe-AO722>
In-Reply-To: <1383330777.3042.2.camel@joe-AO722>
Content-Type: multipart/mixed;
 boundary="------------050204020001060502000909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050204020001060502000909
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/02/2013 02:32 AM, Joe Perches wrote:
> On Fri, 2013-11-01 at 19:20 +0800, Chen Gang wrote:
>> > Hello Joe:
> Hello Chen Gang.
> 
>> > I meet a failure about "scripts/get_maintainers.pl", it is about the
>> > commit "750432d get_maintainer.pl incomplete output", if use original
>> > "scripts/get_maintainer.pl", it will be OK.
>> > 
>> > Please help check, thanks.
> I don't get that effect.

For me now, I made 3 patches for hexagon, 2 of them can cause issue. I
use sfr next-20131101 tree, the related patch is in attachment (1, 3 can
cause issue), hope they are useful for us.

> I'll look into it and see what I find next week.

Thank you very much, just please help analyze it when you have time.

> You seem to have a work-around available.

Yes, at least now, it doesn't matter to me. I guess this issue is not
urgent to us.


Thanks.
-- 
Chen Gang

--------------050204020001060502000909
Content-Type: text/x-patch;
 name="0001-hexagon-kernel-remove-useless-variables-dn-r-and-err.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-hexagon-kernel-remove-useless-variables-dn-r-and-err.pa";
 filename*1="tch"

>From ef7384078bacdc5151039ea710943e5710d7c5ed Mon Sep 17 00:00:00 2001
From: Chen Gang <gang.chen@asianux.com>
Date: Fri, 1 Nov 2013 18:58:18 +0800
Subject: [PATCH 1/3] hexagon: kernel: remove useless variables 'dn', 'r' and
 'err' in time_init_deferred() in "time.c"


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/hexagon/kernel/time.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index 9903fad..d0c4f5a 100644
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -191,9 +191,6 @@ void __init time_init_deferred(void)
 {
 	struct resource *resource = NULL;
 	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
-	struct device_node *dn;
-	struct resource r;
-	int err;
 
 	ce_dev->cpumask = cpu_all_mask;
 
-- 
1.7.7.6


--------------050204020001060502000909
Content-Type: text/x-patch;
 name="0002-hexagon-kernel-kgdb-include-related-header-for-pass-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-hexagon-kernel-kgdb-include-related-header-for-pass-.pa";
 filename*1="tch"

>From 2e587500be49b44b8d8a5b1e429c6f75b0803495 Mon Sep 17 00:00:00 2001
From: Chen Gang <gang.chen@asianux.com>
Date: Fri, 1 Nov 2013 19:44:02 +0800
Subject: [PATCH] hexagon: kernel: kgdb: include related header for pass compiling.

Need include related headers for pass compiling, the related error (with allmodconfig for v4):

    CC      arch/hexagon/kernel/kgdb.o
  arch/hexagon/kernel/kgdb.c:30: error: invalid use of undefined type 'struct pt_regs'
  arch/hexagon/kernel/kgdb.c:31: error: invalid use of undefined type 'struct pt_regs'
  ...
  arch/hexagon/kernel/kgdb.c:220: error: implicit declaration of function 'local_irq_save'
  arch/hexagon/kernel/kgdb.c:222: error: implicit declaration of function 'local_irq_restore'
  ...


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/hexagon/kernel/kgdb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/hexagon/kernel/kgdb.c b/arch/hexagon/kernel/kgdb.c
index 82d5c25..038580c 100644
--- a/arch/hexagon/kernel/kgdb.c
+++ b/arch/hexagon/kernel/kgdb.c
@@ -18,6 +18,8 @@
  * 02110-1301, USA.
  */
 
+#include <linux/irq.h>
+#include <linux/sched.h>
 #include <linux/kdebug.h>
 #include <linux/kgdb.h>
 
-- 
1.7.7.6


--------------050204020001060502000909
Content-Type: text/x-patch;
 name="0003-hexagon-include-asm-kgdb-add-cs0-1-for-DBG_MAX_REG_N.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-hexagon-include-asm-kgdb-add-cs0-1-for-DBG_MAX_REG_N.pa";
 filename*1="tch"

>From cc69a713ea496aa8e952d9c3c312a659dc1fd5ab Mon Sep 17 00:00:00 2001
From: Chen Gang <gang.chen@asianux.com>
Date: Fri, 1 Nov 2013 19:45:59 +0800
Subject: [PATCH] hexagon: include: asm: kgdb: extend DBG_MAX_REG_NUM for "cs0/1"

Need extend maximized number for "cs0/1", the related warning (with allmodconfig for v4):

  arch/hexagon/kernel/kgdb.c:79: warning: excess elements in array initializer
  arch/hexagon/kernel/kgdb.c:79: warning: (near initialization for 'dbg_reg_def')
  arch/hexagon/kernel/kgdb.c:80: warning: excess elements in array initializer
  arch/hexagon/kernel/kgdb.c:80: warning: (near initialization for 'dbg_reg_def')


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/hexagon/include/asm/kgdb.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/hexagon/include/asm/kgdb.h b/arch/hexagon/include/asm/kgdb.h
index 32a6fb6..ccd3ac3 100644
--- a/arch/hexagon/include/asm/kgdb.h
+++ b/arch/hexagon/include/asm/kgdb.h
@@ -34,10 +34,11 @@ static inline void arch_kgdb_breakpoint(void)
  * 32 gpr + sa0/1 + lc0/1 + m0/1 + gp + ugp + pred + pc = 42 total.
  * vm regs = psp+elr+est+badva = 4
  * syscall+restart = 2 more
- * so 48 = 42 +4 + 2
+ * also add cs0/1 = 2
+ * so 48 = 42 + 4 + 2 + 2
  */
 #define DBG_USER_REGS 42
-#define DBG_MAX_REG_NUM (DBG_USER_REGS + 6)
+#define DBG_MAX_REG_NUM (DBG_USER_REGS + 8)
 #define NUMREGBYTES  (DBG_MAX_REG_NUM*4)
 
 #endif /* __HEXAGON_KGDB_H__ */
-- 
1.7.7.6


--------------050204020001060502000909--
