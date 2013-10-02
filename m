Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3JBOeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:34:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab3JBO26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:58 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH 17/26] kvm: Use get_user_pages_unlocked() in async_pf_execute()
Date: Wed,  2 Oct 2013 16:27:58 +0200
Message-Id: <1380724087-13927-18-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: kvm@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 virt/kvm/async_pf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 8a39dda7a325..8d4b39a4bc12 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -67,9 +67,7 @@ static void async_pf_execute(struct work_struct *work)
 	might_sleep();
 
 	use_mm(mm);
-	down_read(&mm->mmap_sem);
-	get_user_pages(current, mm, addr, 1, 1, 0, &page, NULL);
-	up_read(&mm->mmap_sem);
+	get_user_pages_unlocked(current, mm, addr, 1, 1, 0, &page);
 	unuse_mm(mm);
 
 	spin_lock(&vcpu->async_pf.lock);
-- 
1.8.1.4

