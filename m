Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaI3ViO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaI3ViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 044/103] staging: lustre: Remove circular dependency on header
Date: Tue, 30 Sep 2014 14:30:49 -0700
Message-Id: <1412112708-27356-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranith Kumar <bobby.prani@gmail.com>

commit e409842a03b0c2c41c0959fef8a7563208af36c1 upstream.

The following patch fixes a build error on sparc32. I think it should go to
stable 3.16.

Remove a circular dependency on atomic.h header file which leads to compilation
failure on sparc32 as reported here:
http://kisskb.ellerman.id.au/kisskb/buildresult/11340509/

The specific dependency is as follows:

In file included from arch/sparc/include/asm/smp_32.h:24:0,
                 from arch/sparc/include/asm/smp.h:6,
                 from arch/sparc/include/asm/switch_to_32.h:4,
                 from arch/sparc/include/asm/switch_to.h:6,
                 from arch/sparc/include/asm/ptrace.h:84,
                 from arch/sparc/include/asm/processor_32.h:16,
                 from arch/sparc/include/asm/processor.h:6,
                 from arch/sparc/include/asm/barrier_32.h:4,
                 from arch/sparc/include/asm/barrier.h:6,
                 from arch/sparc/include/asm/atomic_32.h:17,
                 from arch/sparc/include/asm/atomic.h:6,
                 from drivers/staging/lustre/lustre/obdclass/class_obd.c:38

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/lustre/lustre/obdclass/class_obd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 4afd962..6d705db 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -35,7 +35,7 @@
  */
 
 #define DEBUG_SUBSYSTEM S_CLASS
-# include <asm/atomic.h>
+# include <linux/atomic.h>
 
 #include <obd_support.h>
 #include <obd_class.h>
-- 
1.9.1

