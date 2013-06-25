Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3FYTKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:10:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3FYSdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>
Subject: [ 24/95] parisc: kernel: using strlcpy() instead of strcpy()
Date: Tue, 25 Jun 2013 11:32:11 -0700
Message-Id: <20130625182156.365876467@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit ea99b1adf22abd62bdcf14b1c9a0a4d3664eefd8 upstream.

'boot_args' is an input args, and 'boot_command_line' has a fix length.
So use strlcpy() instead of strcpy() to avoid memory overflow.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -69,7 +69,8 @@ void __init setup_cmdline(char **cmdline
 		/* called from hpux boot loader */
 		boot_command_line[0] = '\0';
 	} else {
-		strcpy(boot_command_line, (char *)__va(boot_args[1]));
+		strlcpy(boot_command_line, (char *)__va(boot_args[1]),
+			COMMAND_LINE_SIZE);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 		if (boot_args[2] != 0) /* did palo pass us a ramdisk? */


