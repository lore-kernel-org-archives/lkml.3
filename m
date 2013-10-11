Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049Ab3JKTk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:40:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956Ab3JKTkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brad Spengler <spender@grsecurity.net>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 071/110] sparc: fix ldom_reboot buffer overflow harder
Date: Fri, 11 Oct 2013 12:38:51 -0700
Message-Id: <20131011193815.576100463@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 20928bd3f08afb036c096d9559d581926b895918 ]

The length argument to strlcpy was still wrong. It could overflow the end of
full_boot_str by 5 bytes. Instead of strcat and strlcpy, just use snprint.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/ds.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -842,9 +842,8 @@ void ldom_reboot(const char *boot_comman
 	if (boot_command && strlen(boot_command)) {
 		unsigned long len;
 
-		strcpy(full_boot_str, "boot ");
-		strlcpy(full_boot_str + strlen("boot "), boot_command,
-			sizeof(full_boot_str));
+		snprintf(full_boot_str, sizeof(full_boot_str), "boot %s",
+			 boot_command);
 		len = strlen(full_boot_str);
 
 		if (reboot_data_supported) {


