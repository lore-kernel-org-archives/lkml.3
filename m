Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaFRPp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:45:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaFRPp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:45:26 -0400
Message-ID: <53A1B409.60802@redhat.com>
Date: Wed, 18 Jun 2014 17:45:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/9] KVM: x86: More emulator bugs
References: <539F059F.8050501@redhat.com> <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 16:19, Nadav Amit ha scritto:
> This patch-set resolves several emulator bugs. Each fix is independent of the
> others.  The DR6 bug can occur during DR-access exit (regardless to
> unrestricted mode, MMIO and SPT).
>
>
> Changes in v2:
>
> Introduced kvm_register_readl and kvm_register_writel which consider long-mode
> and cs.l when reading the registers.
>
> Fixing the register read to respect 32/64 bit in hypercall handling, CR exit
> handling and VMX instructions handling.
>
> Thanks for re-reviewing the patch
>
> Nadav Amit (9):
>   KVM: x86: bit-ops emulation ignores offset on 64-bit
>   KVM: x86: Wrong emulation on 'xadd X, X'
>   KVM: x86: Inter privilage level ret emulation is not implemeneted
>   KVM: x86: emulation of dword cmov on long-mode should clear [63:32]
>   KVM: x86: NOP emulation clears (incorrectly) the high 32-bits of RAX
>   KVM: x86: check DR6/7 high-bits are clear only on long-mode
>   KVM: x86: Hypercall handling does not considers opsize correctly
>   KVM: vmx: handle_cr ignores 32/64-bit mode
>   KVM: vmx: vmx instructions handling does not consider cs.l
>
>  arch/x86/kvm/emulate.c | 31 ++++++++++++++++++++-----------
>  arch/x86/kvm/vmx.c     | 16 ++++++++--------
>  arch/x86/kvm/x86.c     | 11 ++++++-----
>  arch/x86/kvm/x86.h     | 27 +++++++++++++++++++++++++++
>  4 files changed, 61 insertions(+), 24 deletions(-)
>

Thanks, looks good.

Paolo
