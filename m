Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaD1K3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:29:01 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40294 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaD1K26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:28:58 -0400
Message-ID: <535E2D65.4090508@redhat.com>
Date: Mon, 28 Apr 2014 12:28:53 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/6] Emulator speedups - avoid initializations
 where possible
References: <1397666774-24713-1-git-send-email-bsd@redhat.com>
In-Reply-To: <1397666774-24713-1-git-send-email-bsd@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/04/2014 18:46, Bandan Das ha scritto:
> While initializing emulation context structure, kvm memsets to 0 a
> number of fields some of which are redundant since they get set
> eventually in x86_decode_insn. Cleanup unnecessary initializations
> and remove some fields.
>
> This is on top of Paolo's RFC
> KVM: x86: speedups for emulator memory accesses
> https://lkml.org/lkml/2014/4/1/494
>
> Here are the new realmode.flat numbers with improvement
> wrt unpatched kernel -
>
> 639 cycles/emulated jump instruction (4.3%)
> 776 cycles/emulated move instruction (7.5%)
> 791 cycles/emulated arithmetic instruction (11%)
> 943 cycles/emulated memory load instruction (5.2%)
> 948 cycles/emulated memory store instruction (7.6%)
> 929 cycles/emulated memory RMW instruction (9.0%)
>
> v1 numbers -
> 639 cycles/emulated jump instruction
> 786 cycles/emulated move instruction
> 802 cycles/emulated arithmetic instruction
> 936 cycles/emulated memory load instruction
> 970 cycles/emulated memory store instruction
> 1000 cycles/emulated memory RMW instruction
>
> v3:
> Minor changes as proposed in review
>  - 3/6 - cleanup typos
>  - 6/6 - change comment in struct x86_emulate_ctxt and add back a missing
>        	 if in decode_modrm
>
> v2:
> All thanks and credit to Paolo!
>  - 1/6 - no change
>  - 2/6 - new patch, inercept and check_perm replaced with checks for bits in ctxt->d
>  - 3/6 - new patch, remove if condition in decode_rm and rearrange bit operations
>  - 4/6 - remove else conditions from v1 and misc cleanups
>  - 5/6 - new patch, remove seg_override and related fields and functions
>  - 6/6 - new patch, remove memopp and move rip_relative to a local variable in
>          decode_modrm
>
> Bandan Das (6):
>   KVM: emulate: move init_decode_cache to emulate.c
>   KVM: emulate: Remove ctxt->intercept and ctxt->check_perm checks
>   KVM: emulate: cleanup decode_modrm
>   KVM: emulate: clean up initializations in init_decode_cache
>   KVM: emulate: rework seg_override
>   KVM: emulate: remove memopp and rip_relative
>
>  arch/x86/include/asm/kvm_emulate.h | 26 +++++++-----
>  arch/x86/kvm/emulate.c             | 85 ++++++++++++++++++--------------------
>  arch/x86/kvm/x86.c                 | 13 ------
>  3 files changed, 56 insertions(+), 68 deletions(-)
>

Applied to a private branch collecting all the emulator speedups.  Thanks!

Paolo
