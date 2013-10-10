Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3JJP4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:56:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52982 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3JJPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 103/104] xen/hvc: allow xenboot console to be used again
Date: Thu, 10 Oct 2013 08:42:31 -0700
Message-Id: <1381419752-29733-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit a9fbf4d591da6cd1d3eaab826c7c15f77fc8f6a3 upstream.

Commit d0380e6c3c0f6edb986d8798a23acfaf33d5df23 (early_printk:
consolidate random copies of identical code) added in 3.10 introduced
a check for con->index == -1 in early_console_register().

Initialize index to -1 for the xenboot console so earlyprintk=xen
works again.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/hvc/hvc_xen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 19843ec..6fe7c6c 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -636,6 +636,7 @@ struct console xenboot_console = {
 	.name		= "xenboot",
 	.write		= xenboot_write_console,
 	.flags		= CON_PRINTBUFFER | CON_BOOT | CON_ANYTIME,
+	.index		= -1,
 };
 #endif	/* CONFIG_EARLY_PRINTK */
 
-- 
1.8.1.2

