Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaGZOEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:04:50 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53585 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaGZOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:04:48 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: x86: ia32: sys_ia32.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:06:14 +0200
Message-Id: <1406383574-1589-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/ia32/sys_ia32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 8e0ceec..d0675ed 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -210,7 +210,7 @@ long sys32_vm86_warning(void)
 		compat_printk(KERN_INFO
 			      "%s: vm86 mode not supported on 64 bit kernel\n",
 			      me->comm);
-		strncpy(lastcomm, me->comm, sizeof(lastcomm));
+		strlcpy(lastcomm, me->comm, sizeof(lastcomm));
 	}
 	return -ENOSYS;
 }
-- 
1.7.10.4

