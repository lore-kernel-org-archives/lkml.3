Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaIWCls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:41:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:38676 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891AbaIWClF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:41:05 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Cree <mcree@orcon.net.nz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 43/45] alpha: Fix fall-out from disintegrating asm/system.h
Date: Tue, 23 Sep 2014 10:31:45 +0800
Message-Id: <1411439507-30391-43-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Cree <mcree@orcon.net.nz>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit d1b5153f3ec83789b71d64efaf2a880c8fe6358e upstream.

Commit ec2212088c42 ("Disintegrate asm/system.h for Alpha") removed
asm/system.h however arch/alpha/oprofile/common.c requires definitions
that were shifted from asm/system.h to asm/special_insns.h.  Include
that.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Acked-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/alpha/oprofile/common.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/alpha/oprofile/common.c b/arch/alpha/oprofile/common.c
index a0a5d27..b8ce18f 100644
--- a/arch/alpha/oprofile/common.c
+++ b/arch/alpha/oprofile/common.c
@@ -12,6 +12,7 @@
 #include <linux/smp.h>
 #include <linux/errno.h>
 #include <asm/ptrace.h>
+#include <asm/special_insns.h>
 
 #include "op_impl.h"
 
-- 
1.7.9.5

