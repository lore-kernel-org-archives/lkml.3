Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab3JBFOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:14:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40765 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab3JBFOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:14:15 -0400
Date: Tue, 1 Oct 2013 22:13:34 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sparclinux@vger.kernel.org, Brad Spengler <spender@grsecurity.net>
Subject: [PATCH] sparc: fix ldom_reboot buffer overflow harder
Message-ID: <20131002051334.GA2406@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The length argument to strlcpy was still wrong. It could overflow the end of
full_boot_str by 5 bytes. Instead of strcat and strlcpy, just use snprint.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/sparc/kernel/ds.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 4d9ac84..dff60ab 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -849,9 +849,8 @@ void ldom_reboot(const char *boot_command)
 	if (boot_command && strlen(boot_command)) {
 		unsigned long len;
 
-		strcpy(full_boot_str, "boot ");
-		strlcpy(full_boot_str + strlen("boot "), boot_command,
-			sizeof(full_boot_str));
+		snprintf(full_boot_str, sizeof(full_boot_str), "boot %s",
+			 boot_command);
 		len = strlen(full_boot_str);
 
 		if (reboot_data_supported) {
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
