Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3JVWaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:30:30 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:40708 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861Ab3JVWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tent73_3b917f00805c
X-Filterd-Recvd-Size: 2552
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 02/24] ia64: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:45 -0700
Message-Id: <afc5f51789e13121442988f18bed7539eeb912d7.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ia64/kernel/crash.c   | 4 ++--
 arch/ia64/kernel/perfmon.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index b942f40..2955f35 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -237,7 +237,7 @@ kdump_init_notifier(struct notifier_block *self, unsigned long val, void *data)
 }
 
 #ifdef CONFIG_SYSCTL
-static ctl_table kdump_ctl_table[] = {
+static struct ctl_table kdump_ctl_table[] = {
 	{
 		.procname = "kdump_on_init",
 		.data = &kdump_on_init,
@@ -255,7 +255,7 @@ static ctl_table kdump_ctl_table[] = {
 	{ }
 };
 
-static ctl_table sys_table[] = {
+static struct ctl_table sys_table[] = {
 	{
 	  .procname = "kernel",
 	  .mode = 0555,
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 5a9ff1c..81c962b 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -521,7 +521,7 @@ static pmu_config_t		*pmu_conf;
 pfm_sysctl_t pfm_sysctl;
 EXPORT_SYMBOL(pfm_sysctl);
 
-static ctl_table pfm_ctl_table[]={
+static struct ctl_table pfm_ctl_table[] = {
 	{
 		.procname	= "debug",
 		.data		= &pfm_sysctl.debug,
@@ -552,7 +552,7 @@ static ctl_table pfm_ctl_table[]={
 	},
 	{}
 };
-static ctl_table pfm_sysctl_dir[] = {
+static struct ctl_table pfm_sysctl_dir[] = {
 	{
 		.procname	= "perfmon",
 		.mode		= 0555,
@@ -560,7 +560,7 @@ static ctl_table pfm_sysctl_dir[] = {
 	},
  	{}
 };
-static ctl_table pfm_sysctl_root[] = {
+static struct ctl_table pfm_sysctl_root[] = {
 	{
 		.procname	= "kernel",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

