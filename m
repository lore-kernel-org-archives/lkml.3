Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3J3SLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab3J3SLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:11:15 -0400
Message-ID: <52714BB0.8010504@redhat.com>
Date: Wed, 30 Oct 2013 19:10:56 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] kvm: Emulate MOVBE, v3
References: <1379861095-628-1-git-send-email-bp@alien8.de>
In-Reply-To: <1379861095-628-1-git-send-email-bp@alien8.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2013 16:44, Borislav Petkov ha scritto:
> From: Borislav Petkov <bp@suse.de>
> 
> Alriiight,
> 
> here's another version of the patchset, hopefully addressing all review
> feedback from last time. 6/6 is the respective qemu patch to handle
> emulated features query, etc.
> 
> It is still a lot of fun to generate fast! Atom 32-bit SMP guests like
> this:
> 
> [    0.022876] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.033304] smpboot: CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz (fam: 06, model: 1c, stepping: 02)
> [    0.037000] APIC calibration not consistent with PM-Timer: 146ms instead of 100ms
> [    0.037000] APIC delta adjusted to PM-Timer: 6249937 (9125627)
> [    0.037066] Performance Events: unsupported p6 CPU model 28 no PMU driver, software events only.
> [    0.043605] SMP alternatives: lockdep: fixing up alternatives
> [    0.044030] CPU 1 irqstacks, hard=f450c000 soft=f450e000
> [    0.045004] smpboot: Booting Node   0, Processors  #1[    0.004000] Initializing CPU#1
> [    0.004000] Atom PSE erratum detected, BIOS microcode update recommended
> 
> [    0.120290] SMP alternatives: lockdep: fixing up alternatives
> [    0.121007] CPU 2 irqstacks, hard=f451c000 soft=f451e000
> [    0.122003]  #2[    0.004000] Initializing CPU#2
> [    0.004000] Atom PSE erratum detected, BIOS microcode update recommended
> 
> ...
> 
> [    0.667192] SMP alternatives: lockdep: fixing up alternatives
> [    0.668007] CPU 7 irqstacks, hard=f45b0000 soft=f45b2000
> [    0.669010]  #7 OK
> [    0.004000] Initializing CPU#7
> [    0.004000] Atom PSE erratum detected, BIOS microcode update recommended
> [    0.781052] Brought up 8 CPUs
> [    0.781917] smpboot: Total of 8 processors activated (57461.27 BogoMIPS)
> 
> LooL :-)
> 
> Comments and suggestions appreciated, as always!
> 
> Thanks.
> 
> Borislav Petkov (5):
>   kvm: Add KVM_GET_EMULATED_CPUID
>   kvm, emulator: Use opcode length
>   kvm, emulator: Rename VendorSpecific flag
>   kvm, emulator: Add initial three-byte insns support
>   kvm: Emulate MOVBE
> 
>  Documentation/virtual/kvm/api.txt  | 77 +++++++++++++++++++++++++++++--
>  arch/x86/include/asm/kvm_emulate.h | 10 ++--
>  arch/x86/include/uapi/asm/kvm.h    |  6 +--
>  arch/x86/kvm/cpuid.c               | 75 +++++++++++++++++++++++++++---
>  arch/x86/kvm/cpuid.h               |  5 +-
>  arch/x86/kvm/emulate.c             | 94 ++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/x86.c                 | 16 ++++---
>  include/uapi/linux/kvm.h           |  2 +
>  8 files changed, 251 insertions(+), 34 deletions(-)
> 
> Borislav Petkov (1):
>   qemu: Add support for emulated CPU features
> 
>  include/sysemu/kvm.h      |  4 ++++
>  linux-headers/linux/kvm.h |  4 ++++
>  target-i386/cpu.c         |  7 +++++++
>  target-i386/kvm.c         | 38 ++++++++++++++++++++++++++++++++++----
>  4 files changed, 49 insertions(+), 4 deletions(-)
> 

I tested this patch manually with a small C test program and asm.

Would you please prepare a patch to kvm-unit-tests that stresses the new
codepath?

Paolo
