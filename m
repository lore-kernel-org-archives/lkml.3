Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaGUMUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbaGUMUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:20:32 -0400
Message-ID: <53CD056E.4050203@redhat.com>
Date: Mon, 21 Jul 2014 14:19:58 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: x86: Additional rflags.rf fixes
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/07/2014 13:37, Nadav Amit ha scritto:
> RFLAGS.RF is not handled well by kvm, in both the x86 emulator and vmx code.
> This flag should be cleared after every instruction emulation (other than
> IRETD/IRETQ).  It should be set in various conditions as described in Intel SDM
> 17.3.1.1.  This series of patches addresses the clearing of RF on emulated
> instructions, the setting the RF upon fault injection.  It does not handle the
> case of traps and interrupts injection during REP-string, since there is
> no easy indication whether the first iteration of a rep-string occurred.
> The value of RF depends on whether the first iteration took place.
> 
> Thanks for reviewing the patches.
> 
> Nadav Amit (7):
>   KVM: x86: Defining missing x86 vectors
>   KVM: x86: Function for determining exception type
>   KVM: x86: Clearing rflags.rf upon skipped emulated instruction
>   KVM: vmx: set rflags.rf during fault injection
>   KVM: x86: popf emulation should not change RF
>   KVM: x86: Clear rflags.rf on emulated instructions
>   KVM: x86: Cleanup of rflags.rf cleaning
> 
>  arch/x86/include/uapi/asm/kvm.h |  3 +++
>  arch/x86/kvm/emulate.c          | 13 ++++++++-----
>  arch/x86/kvm/vmx.c              | 11 ++++++++++-
>  arch/x86/kvm/x86.c              | 37 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h              |  9 +++++++++
>  5 files changed, 67 insertions(+), 6 deletions(-)
> 

I'm not applying patches 2 and 4 yet.  I have applied the others:

      KVM: x86: Clearing rflags.rf upon skipped emulated instruction
      KVM: x86: popf emulation should not change RF
      KVM: x86: Clear rflags.rf on emulated instructions
      KVM: x86: Cleanup of rflags.rf cleaning
      KVM: x86: emulator injects #DB when RFLAGS.RF is set
      KVM: x86: Defining missing x86 vectors

since the remaining two are independent.

Thanks!

Paolo
