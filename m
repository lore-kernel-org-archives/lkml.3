Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaH2ANl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 20:13:41 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:57225 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaH2ANk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 20:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <53FF8722.6080302@redhat.com>
References: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com>
 <20140828141704.GI18167@minantech.com> <CALCETrXDygWbKwPNux=qEbqVCCk28Lu7q+gJte=6ZwpCNsbd8w@mail.gmail.com>
 <53FF8722.6080302@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 28 Aug 2014 17:13:18 -0700
Message-ID: <CALCETrVW3ZQ7C6F4tab+UrUy=bX4UepPPrhVNrDtLx=ckz2EpA@mail.gmail.com>
Subject: Re: GET_RNG_SEED hypercall ABI? (Re: [PATCH v5 0/5] random,x86,kvm:
 Rework arch RNG seeds and get some from kvm)
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alok Kataria <akataria@vmware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:46 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 28/08/2014 18:22, Andy Lutomirski ha scritto:
>> Is there a non-cpuid interface between QEMU and KVM for this?
>
> No.

Hmm.  Then, assuming that someone manages to allocate a
cross-hypervisor MSR number for this, what am I supposed to do in the
KVM code?  Just make it available unconditionally?  I don't see why
that wouldn't work reliably, but it seems like an odd design.

>
>> AFAICT, even turning off cpuid bits for things like async pf doesn't
>> actually disable the MSRs (which is arguably an attack surface issue).
>
> No, it doesn't.  You cannot disable instructions even if you hide CPUID
> bits, so KVM just extends this to MSRs (both native and paravirtual). It
> sometimes helps too, for example with a particular guest OS that does
> not necessary check CPUID for bits that are always present on Apple
> hardware...

But I bet that no one assumes that KVM paravirt MSRs are available
even if the feature bit isn't set.

Also, the one and only native feature flag I tested (rdtscp) actually
does work: RDTSCP seems to send #UD if QEMU is passed -cpu
host,-rdtscp.

--Andy
