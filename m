Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab3FNCjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:39:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42069 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759748Ab3FNCjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:39:42 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corey Minyard <minyard@acm.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: [Trivial PATCH 10/33] char: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:35 -0700
Message-Id: <0103adcfc150f4e50516580da0002d7e32be3de0.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/hpet.c               | 6 +++---
 drivers/char/ipmi/ipmi_poweroff.c | 6 +++---
 drivers/char/random.c             | 8 ++++----
 drivers/char/rtc.c                | 6 +++---
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index d784650..448ce5e 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -725,7 +725,7 @@ static int hpet_is_known(struct hpet_data *hdp)
 	return 0;
 }
 
-static ctl_table hpet_table[] = {
+static struct ctl_table hpet_table[] = {
 	{
 	 .procname = "max-user-freq",
 	 .data = &hpet_max_freq,
@@ -736,7 +736,7 @@ static ctl_table hpet_table[] = {
 	{}
 };
 
-static ctl_table hpet_root[] = {
+static struct ctl_table hpet_root[] = {
 	{
 	 .procname = "hpet",
 	 .maxlen = 0,
@@ -746,7 +746,7 @@ static ctl_table hpet_root[] = {
 	{}
 };
 
-static ctl_table dev_root[] = {
+static struct ctl_table dev_root[] = {
 	{
 	 .procname = "dev",
 	 .maxlen = 0,
diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index 2efa176..9f2e3be 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -659,7 +659,7 @@ static struct ipmi_smi_watcher smi_watcher = {
 #ifdef CONFIG_PROC_FS
 #include <linux/sysctl.h>
 
-static ctl_table ipmi_table[] = {
+static struct ctl_table ipmi_table[] = {
 	{ .procname	= "poweroff_powercycle",
 	  .data		= &poweroff_powercycle,
 	  .maxlen	= sizeof(poweroff_powercycle),
@@ -668,14 +668,14 @@ static ctl_table ipmi_table[] = {
 	{ }
 };
 
-static ctl_table ipmi_dir_table[] = {
+static struct ctl_table ipmi_dir_table[] = {
 	{ .procname	= "ipmi",
 	  .mode		= 0555,
 	  .child	= ipmi_table },
 	{ }
 };
 
-static ctl_table ipmi_root_table[] = {
+static struct ctl_table ipmi_root_table[] = {
 	{ .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= ipmi_dir_table },
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 35487e8..0d91fe5 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1381,10 +1381,10 @@ static char sysctl_bootid[16];
  * as an ASCII string in the standard UUID format.  If accesses via the
  * sysctl system call, it is returned as 16 bytes of binary data.
  */
-static int proc_do_uuid(ctl_table *table, int write,
+static int proc_do_uuid(struct ctl_table *table, int write,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	ctl_table fake_table;
+	struct ctl_table fake_table;
 	unsigned char buf[64], tmp_uuid[16], *uuid;
 
 	uuid = table->data;
@@ -1409,8 +1409,8 @@ static int proc_do_uuid(ctl_table *table, int write,
 }
 
 static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
-extern ctl_table random_table[];
-ctl_table random_table[] = {
+extern struct ctl_table random_table[];
+struct ctl_table random_table[] = {
 	{
 		.procname	= "poolsize",
 		.data		= &sysctl_poolsize,
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 91470fd..c0cbbd4 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -280,7 +280,7 @@ static irqreturn_t rtc_interrupt(int irq, void *dev_id)
 /*
  * sysctl-tuning infrastructure.
  */
-static ctl_table rtc_table[] = {
+static struct ctl_table rtc_table[] = {
 	{
 		.procname	= "max-user-freq",
 		.data		= &rtc_max_user_freq,
@@ -291,7 +291,7 @@ static ctl_table rtc_table[] = {
 	{ }
 };
 
-static ctl_table rtc_root[] = {
+static struct ctl_table rtc_root[] = {
 	{
 		.procname	= "rtc",
 		.mode		= 0555,
@@ -300,7 +300,7 @@ static ctl_table rtc_root[] = {
 	{ }
 };
 
-static ctl_table dev_root[] = {
+static struct ctl_table dev_root[] = {
 	{
 		.procname	= "dev",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

