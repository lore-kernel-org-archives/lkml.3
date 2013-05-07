Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab3EGJUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:20:35 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:49215 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab3EGJUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:20:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] proc: Use PDE attribute setting accessor functions
Date: Tue,  7 May 2013 11:20:26 +0200
Message-Id: <1367918426-7076-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-msm/last_radio_log.c: In function 'msm_init_last_radio_log':
arch/arm/mach-msm/last_radio_log.c:69:7: error: dereferencing pointer to incomplete type

arch/cris/kernel/profile.c: In function 'init_cris_profile':
arch/cris/kernel/profile.c:79:8: error: dereferencing pointer to incomplete type

Use proc_set_size(), cfr. commit 271a15eabe094538d958dc68ccfc9c36b699247a
("proc: Supply PDE attribute setting accessor functions")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/arm/mach-msm/last_radio_log.c |    2 +-
 arch/cris/kernel/profile.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/last_radio_log.c b/arch/arm/mach-msm/last_radio_log.c
index 7777767..9c392a2 100644
--- a/arch/arm/mach-msm/last_radio_log.c
+++ b/arch/arm/mach-msm/last_radio_log.c
@@ -66,6 +66,6 @@ void msm_init_last_radio_log(struct module *owner)
 	pr_err("%s: last radio log is %d bytes long\n", __func__,
 		radio_log_size);
 	last_radio_log_fops.owner = owner;
-	entry->size = radio_log_size;
+	proc_set_size(entry, radio_log_size);
 }
 EXPORT_SYMBOL(msm_init_last_radio_log);
diff --git a/arch/cris/kernel/profile.c b/arch/cris/kernel/profile.c
index b82e086..cd9f15b 100644
--- a/arch/cris/kernel/profile.c
+++ b/arch/cris/kernel/profile.c
@@ -76,7 +76,7 @@ static int __init init_cris_profile(void)
 	entry = proc_create("system_profile", S_IWUSR | S_IRUGO, NULL,
 			    &cris_proc_profile_operations);
 	if (entry) {
-		entry->size = SAMPLE_BUFFER_SIZE;
+		proc_set_size(entry, SAMPLE_BUFFER_SIZE);
 	}
 	prof_running = 1;
 
-- 
1.7.0.4

