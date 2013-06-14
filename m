Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818Ab3FNCkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:40:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54518 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759801Ab3FNCkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:40:00 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 12/33] macintosh: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:37 -0700
Message-Id: <2884936fcfd6463d116ba108b8b174dd822c8547.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/macintosh/mac_hid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index 6a82388..80d30e8 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -181,7 +181,7 @@ static void mac_hid_stop_emulation(void)
 	mac_hid_destroy_emumouse();
 }
 
-static int mac_hid_toggle_emumouse(ctl_table *table, int write,
+static int mac_hid_toggle_emumouse(struct ctl_table *table, int write,
 				   void __user *buffer, size_t *lenp,
 				   loff_t *ppos)
 {
@@ -214,7 +214,7 @@ static int mac_hid_toggle_emumouse(ctl_table *table, int write,
 }
 
 /* file(s) in /proc/sys/dev/mac_hid */
-static ctl_table mac_hid_files[] = {
+static struct ctl_table mac_hid_files[] = {
 	{
 		.procname	= "mouse_button_emulation",
 		.data		= &mouse_emulate_buttons,
@@ -240,7 +240,7 @@ static ctl_table mac_hid_files[] = {
 };
 
 /* dir in /proc/sys/dev */
-static ctl_table mac_hid_dir[] = {
+static struct ctl_table mac_hid_dir[] = {
 	{
 		.procname	= "mac_hid",
 		.maxlen		= 0,
@@ -251,7 +251,7 @@ static ctl_table mac_hid_dir[] = {
 };
 
 /* /proc/sys/dev itself, in case that is not there yet */
-static ctl_table mac_hid_root_dir[] = {
+static struct ctl_table mac_hid_root_dir[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
-- 
1.8.1.2.459.gbcd45b4.dirty

