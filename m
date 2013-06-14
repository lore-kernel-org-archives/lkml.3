Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab3FNCid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:38:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54145 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751286Ab3FNCib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:38:31 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 02/33] frv: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:27 -0700
Message-Id: <9fc3b9d2c9dd12c74aab5115a3c50b9eb3ae76d5.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/frv/kernel/pm.c     | 8 ++++----
 arch/frv/kernel/sysctl.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
index 0b57992..ac767d9 100644
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -150,7 +150,7 @@ static int user_atoi(char __user *ubuf, size_t len)
 /*
  * Send us to sleep.
  */
-static int sysctl_pm_do_suspend(ctl_table *ctl, int write,
+static int sysctl_pm_do_suspend(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *fpos)
 {
 	int mode;
@@ -197,7 +197,7 @@ static int try_set_cmode(int new_cmode)
 }
 
 
-static int cmode_procctl(ctl_table *ctl, int write,
+static int cmode_procctl(struct ctl_table *ctl, int write,
 			 void __user *buffer, size_t *lenp, loff_t *fpos)
 {
 	int new_cmode;
@@ -269,7 +269,7 @@ static int try_set_cm(int new_cm)
 	return 0;
 }
 
-static int p0_procctl(ctl_table *ctl, int write,
+static int p0_procctl(struct ctl_table *ctl, int write,
 		      void __user *buffer, size_t *lenp, loff_t *fpos)
 {
 	int new_p0;
@@ -282,7 +282,7 @@ static int p0_procctl(ctl_table *ctl, int write,
 	return try_set_p0(new_p0)?:*lenp;
 }
 
-static int cm_procctl(ctl_table *ctl, int write,
+static int cm_procctl(struct ctl_table *ctl, int write,
 		      void __user *buffer, size_t *lenp, loff_t *fpos)
 {
 	int new_cm;
diff --git a/arch/frv/kernel/sysctl.c b/arch/frv/kernel/sysctl.c
index 6c155d6..f4dfae2 100644
--- a/arch/frv/kernel/sysctl.c
+++ b/arch/frv/kernel/sysctl.c
@@ -46,7 +46,7 @@ static void frv_change_dcache_mode(unsigned long newmode)
 /*
  * handle requests to dynamically switch the write caching mode delivered by /proc
  */
-static int procctl_frv_cachemode(ctl_table *table, int write,
+static int procctl_frv_cachemode(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos)
 {
@@ -121,7 +121,7 @@ static int procctl_frv_cachemode(ctl_table *table, int write,
  * permit the mm_struct the nominated process is using have its MMU context ID pinned
  */
 #ifdef CONFIG_MMU
-static int procctl_frv_pin_cxnr(ctl_table *table, int write,
+static int procctl_frv_pin_cxnr(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
-- 
1.8.1.2.459.gbcd45b4.dirty

