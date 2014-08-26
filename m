Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbaHZX65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:58:57 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:56779 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbaHZX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:58:56 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 26 Aug 2014 16:58:34 -0700
Message-ID: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com>
Subject: GET_RNG_SEED hypercall ABI? (Re: [PATCH v5 0/5] random,x86,kvm:
 Rework arch RNG seeds and get some from kvm)
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        Andrew Honig <ahonig@google.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alok Kataria <akataria@vmware.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa pointed out that the ABI that I chose (an MSR from the KVM range
and a KVM cpuid bit) is unnecessarily KVM-specific.  It would be nice
to allocate an MSR that everyone involved can agree on and, rather
than relying on a cpuid bit, just have the guest probe for the MSR.

This leads to a few questions:

1. How do we allocate an MSR?  (For background, this would be an MSR
that either returns 64 bits of best-effort cryptographically secure
random data or fails with #GP.)

2. For KVM, what's the right way to allow QEMU to turn the feature on
and off?  Is this even necessary?  KVM currently doesn't seem to allow
QEMU to turn any of its MSRs off; it just allows QEMU to ask it to
stop advertising support.

3. QEMU people, can you please fix your RDMSR emulation to send #GP on
failure?  I can work around it for this MSR in the Linux code, but for
Pete's sake... :(

Thanks,
Andy
