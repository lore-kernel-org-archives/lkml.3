Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3JVWbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:31:08 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:49173 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755703Ab3JVWbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:31:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coat50_8ecf8e36e549
X-Filterd-Recvd-Size: 2741
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org
Subject: [PATCH 14/24] nfs: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:57 -0700
Message-Id: <eea46ae938bf85586b6abf1579ea28de08b57be5.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/nfs/nfs4sysctl.c | 6 +++---
 fs/nfs/sysctl.c     | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4sysctl.c b/fs/nfs/nfs4sysctl.c
index 2628d92..b6ebe7e 100644
--- a/fs/nfs/nfs4sysctl.c
+++ b/fs/nfs/nfs4sysctl.c
@@ -16,7 +16,7 @@ static const int nfs_set_port_min = 0;
 static const int nfs_set_port_max = 65535;
 static struct ctl_table_header *nfs4_callback_sysctl_table;
 
-static ctl_table nfs4_cb_sysctls[] = {
+static struct ctl_table nfs4_cb_sysctls[] = {
 	{
 		.procname = "nfs_callback_tcpport",
 		.data = &nfs_callback_set_tcpport,
@@ -36,7 +36,7 @@ static ctl_table nfs4_cb_sysctls[] = {
 	{ }
 };
 
-static ctl_table nfs4_cb_sysctl_dir[] = {
+static struct ctl_table nfs4_cb_sysctl_dir[] = {
 	{
 		.procname = "nfs",
 		.mode = 0555,
@@ -45,7 +45,7 @@ static ctl_table nfs4_cb_sysctl_dir[] = {
 	{ }
 };
 
-static ctl_table nfs4_cb_sysctl_root[] = {
+static struct ctl_table nfs4_cb_sysctl_root[] = {
 	{
 		.procname = "fs",
 		.mode = 0555,
diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index 6b3f253..bb6ed81 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -13,7 +13,7 @@
 
 static struct ctl_table_header *nfs_callback_sysctl_table;
 
-static ctl_table nfs_cb_sysctls[] = {
+static struct ctl_table nfs_cb_sysctls[] = {
 	{
 		.procname	= "nfs_mountpoint_timeout",
 		.data		= &nfs_mountpoint_expiry_timeout,
@@ -31,7 +31,7 @@ static ctl_table nfs_cb_sysctls[] = {
 	{ }
 };
 
-static ctl_table nfs_cb_sysctl_dir[] = {
+static struct ctl_table nfs_cb_sysctl_dir[] = {
 	{
 		.procname = "nfs",
 		.mode = 0555,
@@ -40,7 +40,7 @@ static ctl_table nfs_cb_sysctl_dir[] = {
 	{ }
 };
 
-static ctl_table nfs_cb_sysctl_root[] = {
+static struct ctl_table nfs_cb_sysctl_root[] = {
 	{
 		.procname = "fs",
 		.mode = 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

