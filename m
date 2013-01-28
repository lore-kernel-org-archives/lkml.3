Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3A1Qrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:47:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53429 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3A1Qrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:47:48 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 1/2] kexec: Disable in a secure boot environment
Date: Mon, 28 Jan 2013 11:47:41 -0500
Message-Id: <1359391662-26120-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec could be used as a vector for a malicious user to use a signed kernel
to circumvent the secure boot trust model. In the long run we'll want to
support signed kexec payloads, but for the moment we should just disable
loading entirely in that situation.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 5e4bd78..dd464e0 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -943,7 +943,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!capable(CAP_SYS_BOOT) || !capable(CAP_COMPROMISE_KERNEL))
 		return -EPERM;
 
 	/*
-- 
1.8.0.2

