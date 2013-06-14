Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab3FNCjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:39:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35697 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759726Ab3FNCjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:39:33 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 09/33] cdrom: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:34 -0700
Message-Id: <263daec286a14e77180b796086be33d26dc81fe1.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
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

