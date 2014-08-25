Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbaHYOdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345AbaHYOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:33:16 -0400
Date: Mon, 25 Aug 2014 16:32:57 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 5/7] KVM: trace kvm_ple_window grow/shrink
Message-ID: <20140825143256.GB11024@potion.brq.redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
 <1408637291-18533-6-git-send-email-rkrcmar@redhat.com>
 <20140825135341.GA20218@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140825135341.GA20218@kria>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-25 15:53+0200, Sabrina Dubroca:
> Hello,
> 
> 2014-08-21, 18:08:09 +0200, Radim Krčmář wrote:
> > Tracepoint for dynamic PLE window, fired on every potential change.
> > +#define trace_kvm_ple_window_grow(vcpu_id, new, old) \
> > +	trace_kvm_ple_window(true, vcpu_id, new, old)
> > +#define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
> > +	trace_kvm_ple_window(false, vcpu_id, new, old)
> > +
> >  #endif /* CONFIG_X86_64 */
> 
> Looks like these are needed on 32-bit as well.
> Today's linux-next doesn't build:
> 
> [...]
> 
> I moved the line
> 
> #endif /* CONFIG_X86_64 */
> 
> above
> 
> TRACE_EVENT(kvm_ple_window,
> 
> and it builds.

Thanks!

Paolo, can you still fix this "just" by rebasing?

---
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 1742dfb..4c2868f 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -848,6 +848,8 @@ TRACE_EVENT(kvm_track_tsc,
 		  __print_symbolic(__entry->host_clock, host_clocks))
 );
 
+#endif /* CONFIG_X86_64 */
+
 TRACE_EVENT(kvm_ple_window,
 	TP_PROTO(bool grow, unsigned int vcpu_id, int new, int old),
 	TP_ARGS(grow, vcpu_id, new, old),
@@ -878,8 +880,6 @@ TRACE_EVENT(kvm_ple_window,
 #define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
 	trace_kvm_ple_window(false, vcpu_id, new, old)
 
-#endif /* CONFIG_X86_64 */
-
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
