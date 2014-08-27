Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbaH0HAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:00:13 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64683 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaH0HAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:00:11 -0400
Message-ID: <53FD81F5.6030701@redhat.com>
Date: Wed, 27 Aug 2014 09:00:05 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Gleb Natapov <gleb@kernel.org>, Andrew Honig <ahonig@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, X86 ML <x86@kernel.org>,
        Bandan Das <bsd@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alok Kataria <akataria@vmware.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: GET_RNG_SEED hypercall ABI? (Re: [PATCH v5 0/5] random,x86,kvm:
 Rework arch RNG seeds and get some from kvm)
References: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com>
In-Reply-To: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/08/2014 01:58, Andy Lutomirski ha scritto:
> hpa pointed out that the ABI that I chose (an MSR from the KVM range
> and a KVM cpuid bit) is unnecessarily KVM-specific.  It would be nice
> to allocate an MSR that everyone involved can agree on and, rather
> than relying on a cpuid bit, just have the guest probe for the MSR.
> 
> This leads to a few questions:
> 
> 1. How do we allocate an MSR?  (For background, this would be an MSR
> that either returns 64 bits of best-effort cryptographically secure
> random data or fails with #GP.)

Ask Intel? :)

> 2. For KVM, what's the right way to allow QEMU to turn the feature on
> and off?  Is this even necessary?  KVM currently doesn't seem to allow
> QEMU to turn any of its MSRs off; it just allows QEMU to ask it to
> stop advertising support.

Note that QEMU is not involved in the implementation of your feature,
only in advertising it.  You could look at CPUID at runtime, but that
would mean teaching KVM to look for the KVMKVMKVM\0\0\0 signature in the
CPUID data supplied by userspace.  I don't think this is particularly
useful.

> 3. QEMU people, can you please fix your RDMSR emulation to send #GP on
> failure?  I can work around it for this MSR in the Linux code, but for
> Pete's sake... :(

Sure, I will look at it.  Though I expect it was done because of MSRs
that are missing in QEMU (similar to how Linux doesn't #GP if compiled
with pvops).

Paolo
