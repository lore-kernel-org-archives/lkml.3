Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3JVWal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:30:41 -0400
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:56400 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861Ab3JVWah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:196:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1622:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3353:3868:3870:3871:3874:4605:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: paint74_524c2439cc30
X-Filterd-Recvd-Size: 2474
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/24] cdrom: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:48 -0700
Message-Id: <694a7bdcb2b5724332d0e47b43cec5aa3b06e119.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8a3aff7..d49a76f 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3465,7 +3465,7 @@ static int cdrom_print_info(const char *header, int val, char *info,
 	return 0;
 }
 
-static int cdrom_sysctl_info(ctl_table *ctl, int write,
+static int cdrom_sysctl_info(struct ctl_table *ctl, int write,
                            void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int pos;
@@ -3578,7 +3578,7 @@ static void cdrom_update_settings(void)
 	mutex_unlock(&cdrom_mutex);
 }
 
-static int cdrom_sysctl_handler(ctl_table *ctl, int write,
+static int cdrom_sysctl_handler(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
@@ -3604,7 +3604,7 @@ static int cdrom_sysctl_handler(ctl_table *ctl, int write,
 }
 
 /* Place files in /proc/sys/dev/cdrom */
-static ctl_table cdrom_table[] = {
+static struct ctl_table cdrom_table[] = {
 	{
 		.procname	= "info",
 		.data		= &cdrom_sysctl_settings.info, 
@@ -3650,7 +3650,7 @@ static ctl_table cdrom_table[] = {
 	{ }
 };
 
-static ctl_table cdrom_cdrom_table[] = {
+static struct ctl_table cdrom_cdrom_table[] = {
 	{
 		.procname	= "cdrom",
 		.maxlen		= 0,
@@ -3661,7 +3661,7 @@ static ctl_table cdrom_cdrom_table[] = {
 };
 
 /* Make sure that /proc/sys/dev is there */
-static ctl_table cdrom_root_table[] = {
+static struct ctl_table cdrom_root_table[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
-- 
1.8.1.2.459.gbcd45b4.dirty

