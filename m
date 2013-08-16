Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3HPOfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:35:10 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34172 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042Ab3HPOee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:34:34 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: [PATCH 7/8] remove KM_USER0 from kmap_atomic call
Date: Fri, 16 Aug 2013 09:34:03 -0500
Message-Id: <1376663644-153546-8-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1376663644-153546-1-git-send-email-athorlton@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
In-Reply-To: <87wqo050fc.fsf@tassilo.jf.intel.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/x86/mm/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a088ed7..d3f6dc7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1233,7 +1233,7 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 void clear_user_highpage_nocache(struct page *page, unsigned long vaddr)
 {
-	void *p = kmap_atomic(page, KM_USER0);
+	void *p = kmap_atomic(page);
 	clear_page_nocache(p);
 	kunmap_atomic(p);
 }
-- 
1.7.12.4

