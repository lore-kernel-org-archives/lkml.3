Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaE0N3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:29:06 -0400
Received: from smtp7.sms.unimo.it ([155.185.44.150]:56380 "EHLO
	smtp7.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaE0N3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:29:03 -0400
From: paolo <paolo.valente@unimore.it>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Cc: Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Paolo Valente <paolo.valente@unimore.it>
Subject: [PATCH RFC RESEND 03/14] block: add hierarchical-support option to kconfig
Date: Tue, 27 May 2014 14:42:27 +0200
Message-Id: <1401194558-5283-4-git-send-email-paolo.valente@unimore.it>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Checconi <fchecconi@gmail.com>

Add the CGROUP_BFQIO option to Kconfig.iosched. This option allows
full hierarchical support to be enabled in BFQ, and the bfqio
controller to be added to the cgroups interface.

Signed-off-by: Fabio Checconi <fchecconi@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/Kconfig.iosched | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 8f98cc7..a3675cb 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -46,7 +46,18 @@ config IOSCHED_BFQ
 	  The BFQ I/O scheduler tries to distribute bandwidth among all
 	  processes according to their weights.
 	  It aims at distributing the bandwidth as desired, regardless
-	  of the disk parameters and with any workload.
+	  of the disk parameters and with any workload. If compiled
+	  built-in (saying Y here), BFQ can be configured to support
+	  hierarchical scheduling.
+
+config CGROUP_BFQIO
+	bool "BFQ hierarchical scheduling support"
+	depends on CGROUPS && IOSCHED_BFQ=y
+	default n
+	---help---
+	  Enable hierarchical scheduling in BFQ, using the cgroups
+	  filesystem interface.  The name of the subsystem will be
+	  bfqio.
 
 choice
 	prompt "Default I/O scheduler"
-- 
1.9.2

