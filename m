Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783AbaEKT0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:26:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825AbaEKT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: [PATCH 3.4 01/22] drivers/tty/hvc: dont free hvc_console_setup after init
Date: Sun, 11 May 2014 21:21:09 +0200
Message-Id: <20140511192103.942552390@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511192103.733723493@linuxfoundation.org>
References: <20140511192103.733723493@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/hvc/hvc_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -190,7 +190,7 @@ static struct tty_driver *hvc_console_de
 	return hvc_driver;
 }
 
-static int __init hvc_console_setup(struct console *co, char *options)
+static int hvc_console_setup(struct console *co, char *options)
 {	
 	if (co->index < 0 || co->index >= MAX_NR_HVC_CONSOLES)
 		return -ENODEV;


