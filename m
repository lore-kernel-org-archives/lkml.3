Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaLaJcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 04:32:33 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39828 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaLaJcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 04:32:31 -0500
Date: Wed, 31 Dec 2014 00:48:33 -0800
From: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: lustre: linux-prim.c: fix sparse warnings about
 static declaration
Message-ID: <20141231084833.GA6643@fedora.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:

drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c:198:1: warning: symbol 'libcfs_arch_init' was not declared. Should it be static?
drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c:204:1: warning: symbol 'libcfs_arch_cleanup' was not declared. Should it be static?

Signed-off-by: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
---
v2: Don't break the build, and fix the warnings by defining the functions in libcfs.h.
 drivers/staging/lustre/include/linux/libcfs/libcfs.h | 3 +++
 drivers/staging/lustre/lustre/libcfs/module.c        | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs.h b/drivers/staging/lustre/include/linux/libcfs/libcfs.h
index a6b2f90..4410d7f 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs.h
@@ -85,6 +85,9 @@ static inline int __is_po2(unsigned long long val)
 
 #include <linux/list.h>
 
+int libcfs_arch_init(void);
+void libcfs_arch_cleanup(void);
+
 /* libcfs tcpip */
 int libcfs_ipif_query(char *name, int *up, __u32 *ip, __u32 *mask);
 int libcfs_ipif_enumerate(char ***names);
diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index 2c4fc74..31a4d19 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -334,8 +334,6 @@ extern struct mutex cfs_trace_thread_mutex;
 extern struct cfs_wi_sched *cfs_sched_rehash;
 
 extern void libcfs_init_nidstrings(void);
-extern int libcfs_arch_init(void);
-extern void libcfs_arch_cleanup(void);
 
 static int init_libcfs_module(void)
 {
-- 
1.9.3

