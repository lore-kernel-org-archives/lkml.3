Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab3CRVc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:32:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35928 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344Ab3CRVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:32:54 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 02/12] SELinux: define mapping for CAP_COMPROMISE_KERNEL
Date: Mon, 18 Mar 2013 17:32:23 -0400
Message-Id: <1363642353-30749-2-git-send-email-matthew.garrett@nebula.com>
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

From: Josh Boyer <jwboyer@redhat.com>

Add the name of the new CAP_COMPROMISE_KERNEL capability. This allows SELinux
policies to properly map CAP_COMPROMISE_KERNEL to the appropriate
capability class.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 security/selinux/include/classmap.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 14d04e6..ed99a2d 100644
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
 	  { COMMON_SOCK_PERMS, "attach_queue", NULL } },
-- 
1.8.1.2

