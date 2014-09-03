Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbaICWU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:20:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813AbaICWS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: [PATCH 3.16 102/125] staging: lustre: Remove circular dependency on header
Date: Wed,  3 Sep 2014 15:07:39 -0700
Message-Id: <20140903220626.763954918@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -35,7 +35,7 @@
  */
 
 #define DEBUG_SUBSYSTEM S_CLASS
-# include <asm/atomic.h>
+# include <linux/atomic.h>
 
 #include <obd_support.h>
 #include <obd_class.h>


