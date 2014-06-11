Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbaFKPca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:32:30 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:14157 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755748AbaFKPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:32:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYKAGN0mFNbslCP/2dsb2JhbABagw2sBAUBAQEBAQEFAZkZgQYXdYRgI4EaN4hGAc8WhViIdB2EKwSPY4pKk0qDPjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/auditfilter.c: replace count*size kmalloc by kcalloc
Date: Wed, 11 Jun 2014 17:31:07 +0200
Message-Id: <1402500667-6831-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Eric Paris <eparis@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/auditfilter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 8e9bc9c..c447cd9 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -106,7 +106,7 @@ static inline struct audit_entry *audit_init_entry(u32 field_count)
 	if (unlikely(!entry))
 		return NULL;
 
-	fields = kzalloc(sizeof(*fields) * field_count, GFP_KERNEL);
+	fields = kcalloc(field_count, sizeof(*fields), GFP_KERNEL);
 	if (unlikely(!fields)) {
 		kfree(entry);
 		return NULL;
@@ -160,7 +160,7 @@ static __u32 *classes[AUDIT_SYSCALL_CLASSES];
 
 int __init audit_register_class(int class, unsigned *list)
 {
-	__u32 *p = kzalloc(AUDIT_BITMASK_SIZE * sizeof(__u32), GFP_KERNEL);
+	__u32 *p = kcalloc(AUDIT_BITMASK_SIZE, sizeof(__u32), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 	while (*list != ~0U) {
-- 
1.8.4.5

