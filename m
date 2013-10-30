Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3J3LRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:17:43 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51310 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3J3LRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:17:40 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, tim.gardner@canonical.com, gleb@redhat.com,
        torvalds@linux-foundation.org
Subject: [PATCH] KVM: use a more sensible error number when debugfs directory creation fails
Date: Wed, 30 Oct 2013 12:17:32 +0100
Message-Id: <1383131852-5566-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if this was due to cut and paste, or somebody was really
using a D20 to pick the error code for kvm_init_debugfs as suggested by
Linus (EFAULT is 14, so the possibility cannot be entirely ruled out).

In any case, this patch fixes it.

Reported-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a9dd682cf5e3..1cf9ccb01013 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3091,7 +3091,7 @@ static const struct file_operations *stat_fops[] = {
 
 static int kvm_init_debug(void)
 {
-	int r = -EFAULT;
+	int r = -EEXIST;
 	struct kvm_stats_debugfs_item *p;
 
 	kvm_debugfs_dir = debugfs_create_dir("kvm", NULL);
-- 
1.8.3.1

