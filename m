Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaLRJRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:17:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaLRJR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:17:29 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        torvalds@linux-foundation.org
Cc: Alexander Graf <agraf@suse.de>, gleb@kernel.org
Subject: [PATCH] KVM: PPC: E500: Compile fix in this_cpu_write
Date: Thu, 18 Dec 2014 10:17:08 +0100
Message-Id: <1418894228-8189-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1418894228-8189-1-git-send-email-pbonzini@redhat.com>
References: <1418894228-8189-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Commit 69111bac42f5 (powerpc: Replace __get_cpu_var uses) introduced compile
breakage to the e500 target by introducing invalid automatically created C
syntax.

Fix up the breakage and make the code compile again.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/e500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index c09550c96357..b29ce752c7d6 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -78,7 +78,7 @@ static inline int local_sid_setup_one(struct id *entry)
 
 	sid = __this_cpu_inc_return(pcpu_last_used_sid);
 	if (sid < NUM_TIDS) {
-		__this_cpu_write(pcpu_sids)entry[sid], entry);
+		__this_cpu_write(pcpu_sids.entry[sid], entry);
 		entry->val = sid;
 		entry->pentry = this_cpu_ptr(&pcpu_sids.entry[sid]);
 		ret = sid;
-- 
1.8.3.1

