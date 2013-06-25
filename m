Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3FYKRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:17:04 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56168 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FYKRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:17:02 -0400
X-AuditID: 85900ec0-d2ec7b900000151e-8e-51c96e1a5531
Subject: [PATCH] [BUGFIX] Fix build error caused by an undefinition of the
 kvm_write_tsc_offset tracepoint for x86_32
To: Gleb Natapov <gleb@redhat.com>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>
Date: Tue, 25 Jun 2013 19:16:41 +0900
Message-ID: <20130625101641.29672.13013.stgit@yunodevel>
In-Reply-To: <20130623075848.GO5832@redhat.com>
References: <20130623075848.GO5832@redhat.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error caused by an undefinition of the kvm_write_tsc_offset
tracepoint for x86_32.
Since the tracepoint in trace.h was defined for CONFIG_X86_64, kernel build
on i386 was failed.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/trace.h |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6c82cf1..545245d 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -756,6 +756,27 @@ TRACE_EVENT(
 		  __entry->gpa_match ? "GPA" : "GVA")
 );
 
+TRACE_EVENT(kvm_write_tsc_offset,
+	TP_PROTO(unsigned int vcpu_id, __u64 previous_tsc_offset,
+		 __u64 next_tsc_offset),
+	TP_ARGS(vcpu_id, previous_tsc_offset, next_tsc_offset),
+
+	TP_STRUCT__entry(
+		__field( unsigned int,	vcpu_id				)
+		__field(	__u64,	previous_tsc_offset		)
+		__field(	__u64,	next_tsc_offset			)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id		= vcpu_id;
+		__entry->previous_tsc_offset	= previous_tsc_offset;
+		__entry->next_tsc_offset	= next_tsc_offset;
+	),
+
+	TP_printk("vcpu=%u prev=%llu next=%llu", __entry->vcpu_id,
+		  __entry->previous_tsc_offset, __entry->next_tsc_offset)
+);
+
 #ifdef CONFIG_X86_64
 
 #define host_clocks					\
@@ -815,27 +836,6 @@ TRACE_EVENT(kvm_track_tsc,
 		  __print_symbolic(__entry->host_clock, host_clocks))
 );
 
-TRACE_EVENT(kvm_write_tsc_offset,
-	TP_PROTO(unsigned int vcpu_id, __u64 previous_tsc_offset,
-		 __u64 next_tsc_offset),
-	TP_ARGS(vcpu_id, previous_tsc_offset, next_tsc_offset),
-
-	TP_STRUCT__entry(
-		__field( unsigned int,	vcpu_id				)
-		__field(	__u64,	previous_tsc_offset		)
-		__field(	__u64,	next_tsc_offset			)
-	),
-
-	TP_fast_assign(
-		__entry->vcpu_id		= vcpu_id;
-		__entry->previous_tsc_offset	= previous_tsc_offset;
-		__entry->next_tsc_offset	= next_tsc_offset;
-	),
-
-	TP_printk("vcpu=%u prev=%llu next=%llu", __entry->vcpu_id,
-		  __entry->previous_tsc_offset, __entry->next_tsc_offset)
-);
-
 #endif /* CONFIG_X86_64 */
 
 #endif /* _TRACE_KVM_H */

