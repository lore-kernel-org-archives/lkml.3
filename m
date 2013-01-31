Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3AaJ1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:27:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:29812 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab3AaJ1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,575,1355126400"; 
   d="scan'208";a="278976801"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 2/3] sysctl: put get/get_uts() into CONFIG_PROC_SYSCTL code block
Date: Thu, 31 Jan 2013 17:28:31 +0800
Message-Id: <1359624512-23469-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359624512-23469-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1359624512-23469-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put get/get_uts() into CONFIG_PROC_SYSCTL code block as they are used
only when CONFIG_PROC_SYSCTL is enabled.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/utsname_sysctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index 63da38c..4f69f9a 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -15,6 +15,8 @@
 #include <linux/sysctl.h>
 #include <linux/wait.h>
 
+#ifdef CONFIG_PROC_SYSCTL
+
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
@@ -38,7 +40,6 @@ static void put_uts(ctl_table *table, int write, void *which)
 		up_write(&uts_sem);
 }
 
-#ifdef CONFIG_PROC_SYSCTL
 /*
  *	Special case of dostring for the UTS structure. This has locks
  *	to observe. Should this be in kernel/sys.c ????
-- 
1.7.7.6

