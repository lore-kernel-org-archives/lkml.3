Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaH2GhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:37:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaH2GhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:37:16 -0400
Message-ID: <54001F7F.5030206@redhat.com>
Date: Fri, 29 Aug 2014 08:36:47 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Gleb Natapov <gleb@kernel.org>,
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
Subject: Re: GET_RNG_SEED hypercall ABI? (Re: [PATCH v5 0/5] random,x86,kvm:
 Rework arch RNG seeds and get some from kvm)
References: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com> <20140828141704.GI18167@minantech.com> <CALCETrXDygWbKwPNux=qEbqVCCk28Lu7q+gJte=6ZwpCNsbd8w@mail.gmail.com> <53FF8722.6080302@redhat.com> <CALCETrVW3ZQ7C6F4tab+UrUy=bX4UepPPrhVNrDtLx=ckz2EpA@mail.gmail.com>
In-Reply-To: <CALCETrVW3ZQ7C6F4tab+UrUy=bX4UepPPrhVNrDtLx=ckz2EpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/08/2014 02:13, Andy Lutomirski ha scritto:
> Hmm.  Then, assuming that someone manages to allocate a
> cross-hypervisor MSR number for this, what am I supposed to do in the
> KVM code?  Just make it available unconditionally?  I don't see why
> that wouldn't work reliably, but it seems like an odd design.

The odd part of it is what Gleb mentioned.

> Also, the one and only native feature flag I tested (rdtscp) actually
> does work: RDTSCP seems to send #UD if QEMU is passed -cpu
> host,-rdtscp.

True, and I'm not sure why.  There are a couple others.  I was thinking
more of things like SSE, AVX or DE (that affects the availability of a
bit in CR4).

Paolo
