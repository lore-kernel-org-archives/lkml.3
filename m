Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3KSOnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:43:07 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55148 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3KSOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:43:03 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 13/13] staging/lustre: remove INIT_STRATEGY
Date: Tue, 19 Nov 2013 22:38:47 +0800
Message-Id: <1384871927-8553-14-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

legacy code used to support kernel where struct ctl_table
has strategy member.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/kp30.h       |    4 ----
 .../lustre/lustre/libcfs/linux/linux-proc.c        |    3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index ba78541..3a883f8 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -204,8 +204,4 @@ extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
  */
 # define LPPID "%d"
 
-/* compat macroses */
-
-#define INIT_STRATEGY(a)
-
 #endif
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
index f2bb8672..ef0ab10 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
@@ -452,7 +452,6 @@ static ctl_table_t lnet_table[] = {
 		.maxlen   = sizeof(int),
 		.mode     = 0444,
 		.proc_handler = &proc_dointvec,
-		INIT_STRATEGY(&sysctl_intvec)
 	},
 	{
 		.procname = "catastrophe",
@@ -460,7 +459,6 @@ static ctl_table_t lnet_table[] = {
 		.maxlen   = sizeof(int),
 		.mode     = 0444,
 		.proc_handler = &proc_dointvec,
-		INIT_STRATEGY(&sysctl_intvec)
 	},
 	{
 		.procname = "panic_on_lbug",
@@ -468,7 +466,6 @@ static ctl_table_t lnet_table[] = {
 		.maxlen   = sizeof(int),
 		.mode     = 0644,
 		.proc_handler = &proc_dointvec,
-		INIT_STRATEGY(&sysctl_intvec)
 	},
 	{
 		.procname = "dump_kernel",
-- 
1.7.9.5

