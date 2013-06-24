Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3FXTbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:31:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:47363 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3FXTbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jonas Bonn <jonas@southpole.se>, <linux@openrisc.net>
Subject: [PATCH 20/32] openrisc: delete __cpuinit usage from all openrisc files
Date: Mon, 24 Jun 2013 15:30:25 -0400
Message-ID: <1372102237-8757-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

Note that some harmless section mismatch warnings may result, since
notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
are flagged as __cpuinit  -- so if we remove the __cpuinit from
arch specific callers, we will also get section mismatch warnings.
As an intermediate step, we intend to turn the linux/init.h cpuinit
content into no-ops as early as possible, since that will get rid
of these warnings.  In any case, they are temporary and harmless.

This removes all the arch/openrisc uses of the __cpuinit macros from
all C files.  Currently openrisc does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux@lists.openrisc.net
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/openrisc/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index f4d5bed..d7359ff 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -267,7 +267,7 @@ void __init detect_unit_config(unsigned long upr, unsigned long mask,
  *
  */
 
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	const int *val;
 	struct device_node *cpu = NULL;
-- 
1.8.1.2

