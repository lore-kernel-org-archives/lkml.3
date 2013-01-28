Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3A1Qm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:42:57 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34028 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3A1Qmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:42:50 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 02/15] SELinux: define mapping for new Secure Boot capability
Date: Mon, 28 Jan 2013 11:42:26 -0500
Message-Id: <1359391359-25783-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

Add the name of the new Secure Boot capability.  This allows SELinux
policies to properly map CAP_COMPROMISE_KERNEL to the appropriate
capability class.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 security/selinux/include/classmap.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index df2de54..70e2834 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -146,8 +146,8 @@ struct security_class_mapping secclass_map[] = {
 	{ "memprotect", { "mmap_zero", NULL } },
 	{ "peer", { "recv", NULL } },
 	{ "capability2",
-	  { "mac_override", "mac_admin", "syslog", "wake_alarm", "block_suspend",
-	    NULL } },
+	  { "mac_override", "mac_admin", "syslog", "wake_alarm",
+	    "block_suspend", "compromise_kernel", NULL } },
 	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
 	{ "tun_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
-- 
1.8.0.2

