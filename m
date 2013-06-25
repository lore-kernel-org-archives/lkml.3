Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3FYKoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:44:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3FYKoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:44:01 -0400
Date: Tue, 25 Jun 2013 13:43:39 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] [BUGFIX] Fix build error caused by an undefinition of
 the kvm_write_tsc_offset tracepoint for x86_32
Message-ID: <20130625104339.GA1475@redhat.com>
References: <20130623075848.GO5832@redhat.com>
 <20130625101641.29672.13013.stgit@yunodevel>
 <51C96E7B.3030503@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C96E7B.3030503@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 07:18:35PM +0900, Yoshihiro YUNOMAE wrote:
> Hi Gleb,
> 
> Thank you for applying my patch.
> I received a mail of build error for i386, so I fixed the problem.
> Since the tracepoint was defined only for x86_64, build was failed in
> x86_32.
> 
> Would you apply this patch to kvm-tree?
> Sorry for the inconvenience this may cause.
> 
No inconvenience. I amended your previous commit since it was still on
the branch that can be rebased.

> Thank you,
> Yoshihiro YUNOMAE
> 
> (2013/06/25 19:16), Yoshihiro YUNOMAE wrote:
> >Fix build error caused by an undefinition of the kvm_write_tsc_offset
> >tracepoint for x86_32.
> >Since the tracepoint in trace.h was defined for CONFIG_X86_64, kernel build
> >on i386 was failed.
> >
> >Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> >Cc: Joerg Roedel <joro@8bytes.org>
> >Cc: Gleb Natapov <gleb@redhat.com>
> >Cc: Paolo Bonzini <pbonzini@redhat.com>
> >Cc: Thomas Gleixner <tglx@linutronix.de>
> >Cc: Ingo Molnar <mingo@redhat.com>
> >Cc: "H. Peter Anvin" <hpa@zytor.com>
> >---
> >  arch/x86/kvm/trace.h |   42 +++++++++++++++++++++---------------------
> >  1 file changed, 21 insertions(+), 21 deletions(-)
> >
> >diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> >index 6c82cf1..545245d 100644
> >--- a/arch/x86/kvm/trace.h
> >+++ b/arch/x86/kvm/trace.h
> >@@ -756,6 +756,27 @@ TRACE_EVENT(
> >  		  __entry->gpa_match ? "GPA" : "GVA")
> >  );
> >
> >+TRACE_EVENT(kvm_write_tsc_offset,
> >+	TP_PROTO(unsigned int vcpu_id, __u64 previous_tsc_offset,
> >+		 __u64 next_tsc_offset),
> >+	TP_ARGS(vcpu_id, previous_tsc_offset, next_tsc_offset),
> >+
> >+	TP_STRUCT__entry(
> >+		__field( unsigned int,	vcpu_id				)
> >+		__field(	__u64,	previous_tsc_offset		)
> >+		__field(	__u64,	next_tsc_offset			)
> >+	),
> >+
> >+	TP_fast_assign(
> >+		__entry->vcpu_id		= vcpu_id;
> >+		__entry->previous_tsc_offset	= previous_tsc_offset;
> >+		__entry->next_tsc_offset	= next_tsc_offset;
> >+	),
> >+
> >+	TP_printk("vcpu=%u prev=%llu next=%llu", __entry->vcpu_id,
> >+		  __entry->previous_tsc_offset, __entry->next_tsc_offset)
> >+);
> >+
> >  #ifdef CONFIG_X86_64
> >
> >  #define host_clocks					\
> >@@ -815,27 +836,6 @@ TRACE_EVENT(kvm_track_tsc,
> >  		  __print_symbolic(__entry->host_clock, host_clocks))
> >  );
> >
> >-TRACE_EVENT(kvm_write_tsc_offset,
> >-	TP_PROTO(unsigned int vcpu_id, __u64 previous_tsc_offset,
> >-		 __u64 next_tsc_offset),
> >-	TP_ARGS(vcpu_id, previous_tsc_offset, next_tsc_offset),
> >-
> >-	TP_STRUCT__entry(
> >-		__field( unsigned int,	vcpu_id				)
> >-		__field(	__u64,	previous_tsc_offset		)
> >-		__field(	__u64,	next_tsc_offset			)
> >-	),
> >-
> >-	TP_fast_assign(
> >-		__entry->vcpu_id		= vcpu_id;
> >-		__entry->previous_tsc_offset	= previous_tsc_offset;
> >-		__entry->next_tsc_offset	= next_tsc_offset;
> >-	),
> >-
> >-	TP_printk("vcpu=%u prev=%llu next=%llu", __entry->vcpu_id,
> >-		  __entry->previous_tsc_offset, __entry->next_tsc_offset)
> >-);
> >-
> >  #endif /* CONFIG_X86_64 */
> >
> >  #endif /* _TRACE_KVM_H */
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> -- 
> Yoshihiro YUNOMAE
> Software Platform Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: yoshihiro.yunomae.ez@hitachi.com
> 

--
			Gleb.
