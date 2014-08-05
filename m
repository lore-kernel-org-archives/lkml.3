Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaHEJTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:19:35 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59166 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbaHEJTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:19:33 -0400
Message-ID: <53E0A19A.4060504@redhat.com>
Date: Tue, 05 Aug 2014 11:19:22 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Alexander Graf <agraf@suse.de>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kvm-ppc tree
References: <20140804203618.67a5ba54@canb.auug.org.au>
In-Reply-To: <20140804203618.67a5ba54@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/08/2014 12:36, Stephen Rothwell ha scritto:
> Hi Alexander,
> 
> After merging the kvm-ppc tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> arch/powerpc/kvm/kvm-pr.o:(__tracepoints+0xa8): multiple definition of `__tracepoint_kvm_ppc_instr'
> arch/powerpc/kvm/kvm.o:(__tracepoints+0x1c0): first defined here
> 
> Caused by commit 29577fc00ba4 ("KVM: PPC: HV: Remove generic
> instruction emulation").  I note that this commit has no Reviewed-by,
> Tested-by or Acked-by tags and only one Signed-off-by tag.
> 
> I have reverted that commit for today.

Thanks for the heads up.  I will apply this, and wait for tomorrow's
linux-next build before sending the result to Linus:

diff --git a/arch/powerpc/kvm/trace_pr.h b/arch/powerpc/kvm/trace_pr.h
index a674f090dfb8..e1357cd8dc1f 100644
--- a/arch/powerpc/kvm/trace_pr.h
+++ b/arch/powerpc/kvm/trace_pr.h
@@ -291,26 +291,6 @@ TRACE_EVENT(kvm_unmap_hva,
 	TP_printk("unmap hva 0x%lx\n", __entry->hva)
 );
 
-TRACE_EVENT(kvm_ppc_instr,
-	TP_PROTO(unsigned int inst, unsigned long _pc, unsigned int emulate),
-	TP_ARGS(inst, _pc, emulate),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	inst		)
-		__field(	unsigned long,	pc		)
-		__field(	unsigned int,	emulate		)
-	),
-
-	TP_fast_assign(
-		__entry->inst		= inst;
-		__entry->pc		= _pc;
-		__entry->emulate	= emulate;
-	),
-
-	TP_printk("inst %u pc 0x%lx emulate %u\n",
-		  __entry->inst, __entry->pc, __entry->emulate)
-);
-
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */


Paolo
