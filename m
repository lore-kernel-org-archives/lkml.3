Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbaGPQDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:03:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41403 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759734AbaGPQDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:03:20 -0400
Message-ID: <53C6A236.7040904@zytor.com>
Date: Wed, 16 Jul 2014 09:03:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>
CC: Daniel Borkmann <dborkman@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
References: <cover.1405477965.git.luto@amacapital.net> <20140716064110.GV18167@minantech.com> <53C62563.6050106@redhat.com> <53C62B68.50702@redhat.com> <CALCETrVLJ7qH3y04K9Sz1pU3i9+H9Cq_RoDfBeWnsH0VC68qKw@mail.gmail.com>
In-Reply-To: <CALCETrVLJ7qH3y04K9Sz1pU3i9+H9Cq_RoDfBeWnsH0VC68qKw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 07:07 AM, Andy Lutomirski wrote:
> 
> This patch has nothing whatsoever to do with how much I trust the CPU
> vs the hypervisor.  It's for the enormous installed base of machines
> without RDRAND.
> 
> hpa suggested emulating RDRAND awhile ago, but I think that'll
> unusably slow -- the kernel uses RDRAND in various places where it's
> expected to be fast, and not using it at all will be preferable to
> causing a VM exit for every few bytes.  I've been careful to only use
> this in the guest in places where a few hundred to a few thousand
> cycles per 64 bits of RNG seed is acceptable.
> 

I suggested emulating RDRAND *but not set the CPUID bit*.  We already
developed a protocol in KVM/Qemu to enumerate emulated features (created
for MOVBE as I recall), specifically to service the semantic "feature X
will work but will be substantially slower than normal."

	-hpa


