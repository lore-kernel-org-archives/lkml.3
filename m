Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbaFQQZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:25:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139AbaFQQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:25:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 115/121] drivers/tty/hvc: don't free hvc_console_setup after init
Date: Tue, 17 Jun 2014 09:18:13 -0700
Message-Id: <1403021899-16708-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>

commit 501fed45b7e8836ee9373f4d31e2d85e3db6103a upstream.

When 'console=hvc0' is specified to the kernel parameter in x86 KVM guest,
hvc console is setup within a kthread. However, that will cause SEGV
and the boot will fail when the driver is builtin to the kernel,
because currently hvc_console_setup() is annotated with '__init'. This
patch removes '__init' to boot the guest successfully with 'console=hvc0'.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/hvc/hvc_console.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 89c1dd1..728572a 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -190,7 +190,7 @@ static struct tty_driver *hvc_console_device(struct console *c, int *index)
 	return hvc_driver;
 }
 
-static int __init hvc_console_setup(struct console *co, char *options)
+static int hvc_console_setup(struct console *co, char *options)
 {	
 	if (co->index < 0 || co->index >= MAX_NR_HVC_CONSOLES)
 		return -ENODEV;
-- 
1.9.1

