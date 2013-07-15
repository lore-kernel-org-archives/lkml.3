Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3GOO1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:27:43 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49651 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3GOO1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:27:41 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 02/17] staging/lustre: fix Lustre code link order
Date: Mon, 15 Jul 2013 22:27:05 +0800
Message-Id: <1373898440-14208-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Makefiles to keep link order in match with Lustre module
dependency, so that when Lustre is built in kernel, we'll have
the same dependency. Otherwise we'll crash kernel if Lustre is
builtin due to missing internal dependency.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/Makefile        |    2 +-
 drivers/staging/lustre/lnet/Makefile   |    2 +-
 drivers/staging/lustre/lustre/Makefile |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/Makefile b/drivers/staging/lustre/Makefile
index 2616289..fb0e0fa 100644
--- a/drivers/staging/lustre/Makefile
+++ b/drivers/staging/lustre/Makefile
@@ -1,4 +1,4 @@
 subdir-ccflags-y := -I$(src)/include/
 
-obj-$(CONFIG_LUSTRE_FS)		+= lustre/
 obj-$(CONFIG_LNET)		+= lnet/
+obj-$(CONFIG_LUSTRE_FS)		+= lustre/
diff --git a/drivers/staging/lustre/lnet/Makefile b/drivers/staging/lustre/lnet/Makefile
index 374212b..f6f03e3 100644
--- a/drivers/staging/lustre/lnet/Makefile
+++ b/drivers/staging/lustre/lnet/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_LNET) := klnds/ lnet/ selftest/
+obj-$(CONFIG_LNET) += lnet/ klnds/ selftest/
diff --git a/drivers/staging/lustre/lustre/Makefile b/drivers/staging/lustre/lustre/Makefile
index 3fb94fc..d1eb0bd 100644
--- a/drivers/staging/lustre/lustre/Makefile
+++ b/drivers/staging/lustre/lustre/Makefile
@@ -1,2 +1,2 @@
-obj-$(CONFIG_LUSTRE_FS) := fid/ lvfs/ obdclass/ ptlrpc/ obdecho/ mgc/ lov/ \
-			   osc/ mdc/ lmv/ llite/ fld/ libcfs/
+obj-$(CONFIG_LUSTRE_FS) += libcfs/ lvfs/ obdclass/ ptlrpc/ fld/ osc/ mgc/ \
+			   fid/ lov/ mdc/ lmv/ llite/ obdecho/
-- 
1.7.9.5

