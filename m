Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaBZULr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:11:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44146 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaBZULq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:11:46 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 09/12] uswsusp: Disable when trusted_kernel is true
Date: Wed, 26 Feb 2014 15:11:10 -0500
Message-Id: <1393445473-15068-10-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uswsusp allows a user process to dump and then restore kernel state, which
makes it possible to modify the running kernel. Disable this if
 trusted_kernel is true.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/power/user.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 98d3575..2d7a5d3 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -24,6 +24,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/security.h>
 
 #include <asm/uaccess.h>
 
@@ -49,6 +50,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	struct snapshot_data *data;
 	int error;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	lock_system_sleep();
 
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
-- 
1.8.5.3

