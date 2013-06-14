Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3FNCiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:38:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58872 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932160Ab3FNCit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:38:49 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 04/33] mips: lasat: sysctl: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:29 -0700
Message-Id: <ac945517c9abcd71f312ea07693526bab1a912c2.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/lasat/sysctl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/lasat/sysctl.c b/arch/mips/lasat/sysctl.c
index f27694f..3b7f65c 100644
--- a/arch/mips/lasat/sysctl.c
+++ b/arch/mips/lasat/sysctl.c
@@ -39,7 +39,7 @@
 
 
 /* And the same for proc */
-int proc_dolasatstring(ctl_table *table, int write,
+int proc_dolasatstring(struct ctl_table *table, int write,
 		       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int r;
@@ -54,7 +54,7 @@ int proc_dolasatstring(ctl_table *table, int write,
 }
 
 /* proc function to write EEPROM after changing int entry */
-int proc_dolasatint(ctl_table *table, int write,
+int proc_dolasatint(struct ctl_table *table, int write,
 		       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int r;
@@ -72,7 +72,7 @@ int proc_dolasatint(ctl_table *table, int write,
 static int rtctmp;
 
 /* proc function to read/write RealTime Clock */
-int proc_dolasatrtc(ctl_table *table, int write,
+int proc_dolasatrtc(struct ctl_table *table, int write,
 		       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct timespec ts;
@@ -97,7 +97,7 @@ int proc_dolasatrtc(ctl_table *table, int write,
 #endif
 
 #ifdef CONFIG_INET
-int proc_lasat_ip(ctl_table *table, int write,
+int proc_lasat_ip(struct ctl_table *table, int write,
 		       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	unsigned int ip;
@@ -157,7 +157,7 @@ int proc_lasat_ip(ctl_table *table, int write,
 }
 #endif
 
-int proc_lasat_prid(ctl_table *table, int write,
+int proc_lasat_prid(struct ctl_table *table, int write,
 		       void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int r;
@@ -176,7 +176,7 @@ int proc_lasat_prid(ctl_table *table, int write,
 
 extern int lasat_boot_to_service;
 
-static ctl_table lasat_table[] = {
+static struct ctl_table lasat_table[] = {
 	{
 		.procname	= "cpu-hz",
 		.data		= &lasat_board_info.li_cpu_hz,
@@ -262,7 +262,7 @@ static ctl_table lasat_table[] = {
 	{}
 };
 
-static ctl_table lasat_root_table[] = {
+static struct ctl_table lasat_root_table[] = {
 	{
 		.procname	= "lasat",
 		.mode		=  0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

