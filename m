Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491AbaGPP4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:56:34 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:39473 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170AbaGPP4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <53C68CF3.5070208@redhat.com>
References: <cover.1405477965.git.luto@amacapital.net> <20140716064110.GV18167@minantech.com>
 <53C62563.6050106@redhat.com> <53C62B68.50702@redhat.com> <CALCETrVLJ7qH3y04K9Sz1pU3i9+H9Cq_RoDfBeWnsH0VC68qKw@mail.gmail.com>
 <53C68CF3.5070208@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Jul 2014 08:56:10 -0700
Message-ID: <CALCETrWYe9ku4MRwbfNnQckOZGvh-HRs9s3HjApmhYPaDch46w@mail.gmail.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 7:32 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 16/07/2014 16:07, Andy Lutomirski ha scritto:
>
>> This patch has nothing whatsoever to do with how much I trust the CPU
>> vs the hypervisor.  It's for the enormous installed base of machines
>> without RDRAND.
>
>
> Ok.  I think an MSR is fine, though I don't think it's useful for the guest
> to use it if it already has RDRAND and/or RDSEED.
>
>
>> > In any case, is there a matching QEMU patch somewhere?
>>
>> What QEMU change is needed?  I admit I'm a bit vague on how QEMU and
>> KVM cooperate here, but there's no state to save and restore.  I guess
>> that QEMU wants the ability to turn this on and off for migration.
>> How does that work?  I couldn't spot the KVM code that allows this
>> type of control.
>
>
> It is QEMU who decides the CPUID bits that are visible to the guest.  By
> default it blocks bits that it doesn't know about.  You would need to add
> the bit in the kvm_default_features and kvm_feature_name arrays.
>
> For migration, we have "versioned" machine types, for example pc-2.1.
> Once the versioned machine type exists, blocking the feature is a one-liner
> like
>
>     x86_cpu_compat_disable_kvm_features(FEAT_KVM, KVM_FEATURE_NAME);
>
> Unfortunately, QEMU is in hard freeze, so you'd likely be the one creating
> pc-2.2.  This is a boilerplate but relatively complicated patch.  But let's
> cross that bridge when we'll reach it.  For now, you can simply add the bit
> to the two arrays above.
>

Done.

NB: Patch 4 of this series is bad due to an asm constraint issue that
I haven't figured out yet.  I'll send a replacement once I get it
working.  *sigh* the x86 kernel loading code is a bit of a compilation
mess.

> Paolo



-- 
Andy Lutomirski
AMA Capital Management, LLC
