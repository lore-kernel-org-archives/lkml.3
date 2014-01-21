Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaAUVkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:40:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:56344 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaAUVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 18/73] arm: fix implicit #include <linux/init.h> in entry asm.
Date: Tue, 21 Jan 2014 16:22:21 -0500
Message-ID: <1390339396-3479-19-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They use the "_INIT" macro and friends, and hence need to
source this header file, vs. relying on getting it implicitly.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/kernel/entry-armv.S | 2 ++
 arch/arm/vfp/entry.S         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index b3fb8c9..ffc1c74 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -15,6 +15,8 @@
  *  that causes it to save wrong values...  Be aware!
  */
 
+#include <linux/init.h>
+
 #include <asm/assembler.h>
 #include <asm/memory.h>
 #include <asm/glue-df.h>
diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index 46e1749..ec7ea24 100644
--- a/arch/arm/vfp/entry.S
+++ b/arch/arm/vfp/entry.S
@@ -8,6 +8,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/init.h>
+
 #include <asm/thread_info.h>
 #include <asm/vfpmacros.h>
 #include "../kernel/entry-header.S"
-- 
1.8.4.1

