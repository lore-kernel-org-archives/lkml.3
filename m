Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaGPUVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:21:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45197 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaGPUVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:21:15 -0400
Message-ID: <53C6DEA5.7010203@zytor.com>
Date: Wed, 16 Jul 2014 13:20:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
References: <cover.1405477965.git.luto@amacapital.net> <20140716064110.GV18167@minantech.com> <53C62563.6050106@redhat.com> <53C62B68.50702@redhat.com> <CALCETrVLJ7qH3y04K9Sz1pU3i9+H9Cq_RoDfBeWnsH0VC68qKw@mail.gmail.com> <53C6A236.7040904@zytor.com> <53C6A362.7090709@redhat.com> <53C6A4A3.1040702@zytor.com> <20140716162133.GO4399@minantech.com>
In-Reply-To: <20140716162133.GO4399@minantech.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 09:21 AM, Gleb Natapov wrote:
> On Wed, Jul 16, 2014 at 09:13:23AM -0700, H. Peter Anvin wrote:
>> On 07/16/2014 09:08 AM, Paolo Bonzini wrote:
>>> Il 16/07/2014 18:03, H. Peter Anvin ha scritto:
>>>> I suggested emulating RDRAND *but not set the CPUID bit*.  We already
>>>> developed a protocol in KVM/Qemu to enumerate emulated features (created
>>>> for MOVBE as I recall), specifically to service the semantic "feature X
>>>> will work but will be substantially slower than normal."
>>>
>>> But those will set the CPUID bit.  There is currently no way for KVM
>>> guests to know if a CPUID bit is real or emulated.
>>>
>>
>> OK, so there wasn't any protocol implemented in the end.  I sit corrected.
>>
> That protocol that was implemented is between qemu and kvm, not kvm and a guest.
> 

Either which way, the notion was to have a PV CPUID bit like the
proposed kvm_get_rng_seed bit, but to have it exercised by executing RDRAND.

The biggest reason to *not* do this would be that with an MSR it is not
available to guest user space, which may be better under the circumstances.

	-hpa


