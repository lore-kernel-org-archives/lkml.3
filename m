Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965129AbaE2OXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:23:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59305 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932848AbaE2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 020/103] KVM: x86: remove WARN_ON from get_kernel_ns()
Date: Thu, 29 May 2014 15:48:05 +0200
Message-Id: <146ca9148a6898ebc57576419dd375ac266f23b2.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b351c39cc9e0151cee9b8d52a1e714928faabb38 upstream.

Function and callers can be preempted.

https://bugzilla.kernel.org/show_bug.cgi?id=73721

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92af83d79c97..77046f7177d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1073,7 +1073,6 @@ static inline u64 get_kernel_ns(void)
 {
 	struct timespec ts;
 
-	WARN_ON(preemptible());
 	ktime_get_ts(&ts);
 	monotonic_to_bootbased(&ts);
 	return timespec_to_ns(&ts);
-- 
1.9.3

