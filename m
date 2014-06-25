Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbaFYN1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:27:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbaFYN1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:27:46 -0400
From: Hannes Reinecke <hare@suse.de>
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Rusty Russel <rusty@rustcorp.com.au>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] Add module param type 'ullong'
Date: Wed, 25 Jun 2014 15:27:37 +0200
Message-Id: <1403702859-74437-3-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1403702859-74437-1-git-send-email-hare@suse.de>
References: <1403702859-74437-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some driver might want to pass in an 64-bit value, so introduce
a module param type 'ullong'.

Cc: Rusty Russel <rusty@rustcorp.com.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Ewan Milne <emilne@redhat.com>
---
 include/linux/moduleparam.h | 5 +++++
 kernel/params.c             | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index b1990c5..494f99e 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -381,6 +381,11 @@ extern int param_set_ulong(const char *val, const struct kernel_param *kp);
 extern int param_get_ulong(char *buffer, const struct kernel_param *kp);
 #define param_check_ulong(name, p) __param_check(name, p, unsigned long)
 
+extern struct kernel_param_ops param_ops_ullong;
+extern int param_set_ullong(const char *val, const struct kernel_param *kp);
+extern int param_get_ullong(char *buffer, const struct kernel_param *kp);
+#define param_check_ullong(name, p) __param_check(name, p, unsigned long long)
+
 extern struct kernel_param_ops param_ops_charp;
 extern int param_set_charp(const char *val, const struct kernel_param *kp);
 extern int param_get_charp(char *buffer, const struct kernel_param *kp);
diff --git a/kernel/params.c b/kernel/params.c
index 1e52ca2..34f5270 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -256,6 +256,7 @@ STANDARD_PARAM_DEF(int, int, "%i", kstrtoint);
 STANDARD_PARAM_DEF(uint, unsigned int, "%u", kstrtouint);
 STANDARD_PARAM_DEF(long, long, "%li", kstrtol);
 STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", kstrtoul);
+STANDARD_PARAM_DEF(ullong, unsigned long long, "%llu", kstrtoull);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
-- 
1.7.12.4

