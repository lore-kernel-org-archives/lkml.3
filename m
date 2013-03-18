Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab3CRVib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:38:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36043 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219Ab3CRVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:38:28 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 12/12] kexec: Require CAP_SYS_COMPROMISE_KERNEL
Date: Mon, 18 Mar 2013 17:32:33 -0400
Message-Id: <1363642353-30749-12-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:e0f4:3a1:9c35:d688
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec can easily be used to modify the security policy of a running kernel.
CONFIG_KEXEC_JUMP makes it trivial for an attacker to simply jump to another
kernel, modify the security policy of the previous kernel and then switch
back, but it's still merely a matter of difficulty. Long term we'll want
an interface for ensuring that kexec is able to launch signed code, but we
should default to safe behaviour for now.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index bddd3d7..cbdb930 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -946,7 +946,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!capable(CAP_SYS_BOOT) || !capable(CAP_COMPROMISE_KERNEL))
 		return -EPERM;
 
 	/*
-- 
1.8.1.2

