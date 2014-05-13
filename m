Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbaEMKOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:14:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933679AbaEMKLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:53 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 123/182] drivers/tty/hvc: don't free hvc_console_setup after init
Date: Tue, 13 May 2014 11:27:55 +0200
Message-Id: <d8659036c829de3326d32dcd0bd185142d3755ea.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 501fed45b7e8836ee9373f4d31e2d85e3db6103a upstream.

When 'console=hvc0' is specified to the kernel parameter in x86 KVM guest,
hvc console is setup within a kthread. However, that will cause SEGV
and the boot will fail when the driver is builtin to the kernel,
because currently hvc_console_setup() is annotated with '__init'. This
patch removes '__init' to boot the guest successfully with 'console=hvc0'.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/hvc/hvc_console.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 620da5f88e91..e8e06d82acf0 100644
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
1.9.3

