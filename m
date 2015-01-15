Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbbAOJAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:00:06 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:60943 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbbAOI6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:58:22 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 4/8] x86/spinlock: Leftover conversion ACCESS_ONCE->READ_ONCE
Date: Thu, 15 Jan 2015 09:58:30 +0100
Message-Id: <1421312314-72330-5-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com>
References: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011508-0025-0000-0000-00000362B0A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 78bff1c8684f ("x86/ticketlock: Fix spin_unlock_wait() livelock")
introduced another ACCESS_ONCE case in x86 spinlock.h.

Change that as well.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/spinlock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 625660f..9264f0f 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -186,7 +186,7 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 	__ticket_t head = ACCESS_ONCE(lock->tickets.head);
 
 	for (;;) {
-		struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+		struct __raw_tickets tmp = READ_ONCE(lock->tickets);
 		/*
 		 * We need to check "unlocked" in a loop, tmp.head == head
 		 * can be false positive because of overflow.
-- 
1.9.3

