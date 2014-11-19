Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbaKSX1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:27:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:23890 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751995AbaKSX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:11 -0500
Message-Id: <20141119232709.907008577@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rustad <mark.d.rustad@intel.com>, Petr Mladek <pmladek@suse.cz>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [for-next][PATCH 04/18] x86/kvm/tracing: Use helper function trace_seq_buffer_ptr()
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-x86-kvm-tracing-Use-helper-function-trace_seq_buffer.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

To allow for the restructiong of the trace_seq code, we need users
of it to use the helper functions instead of accessing the internals
of the trace_seq structure itself.

Link: http://lkml.kernel.org/r/20141104160221.585025609@goodmis.org

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Mark Rustad <mark.d.rustad@intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/mmutrace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 5aaf35641768..ce463a9cc8fb 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -22,7 +22,7 @@
 	__entry->unsync = sp->unsync;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
-	const u32 saved_len = p->len;					\
+	const char *saved_ptr = trace_seq_buffer_ptr(p);		\
 	static const char *access_str[] = {			        \
 		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
 	};							        \
@@ -41,7 +41,7 @@
 			 role.nxe ? "" : "!",				\
 			 __entry->root_count,				\
 			 __entry->unsync ? "unsync" : "sync", 0);	\
-	p->buffer + saved_len;						\
+	saved_ptr;							\
 		})
 
 #define kvm_mmu_trace_pferr_flags       \
-- 
2.1.1


