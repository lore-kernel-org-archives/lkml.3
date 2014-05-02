Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaEBW6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbaEBW6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:58:31 -0400
Subject: [PATCH] drivers/tty/hvc: don't free hvc_console_setup after init
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, mitsuhiro.tanino@hds.com,
        paul.gortmaker@windriver.com
Date: Fri, 02 May 2014 18:58:24 -0400
Message-ID: <20140502225824.3868.84428.stgit@hds.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 'console=hvc0' is specified to the kernel parameter in x86 KVM guest,
hvc console is setup within a kthread. However, that will cause SEGV
and the boot will fail when the driver is builtin to the kernel,
because currently hvc_console_setup() is annotated with '__init'. This
patch removes '__init' to boot the guest successfully with 'console=hvc0'.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
---
 drivers/tty/hvc/hvc_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 94f9e3a..0ff7fda 100644
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

