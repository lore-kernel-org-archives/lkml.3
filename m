Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800Ab3JKTvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:51:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab3JKTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 103/135] xen/hvc: allow xenboot console to be used again
Date: Fri, 11 Oct 2013 12:39:44 -0700
Message-Id: <20131011193956.446819261@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit a9fbf4d591da6cd1d3eaab826c7c15f77fc8f6a3 upstream.

Commit d0380e6c3c0f6edb986d8798a23acfaf33d5df23 (early_printk:
consolidate random copies of identical code) added in 3.10 introduced
a check for con->index == -1 in early_console_register().

Initialize index to -1 for the xenboot console so earlyprintk=xen
works again.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/hvc/hvc_xen.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -636,6 +636,7 @@ struct console xenboot_console = {
 	.name		= "xenboot",
 	.write		= xenboot_write_console,
 	.flags		= CON_PRINTBUFFER | CON_BOOT | CON_ANYTIME,
+	.index		= -1,
 };
 #endif	/* CONFIG_EARLY_PRINTK */
 


