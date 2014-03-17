Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbaCQLod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:44:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbaCQLoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:44:32 -0400
Message-ID: <5326DA5D.7040503@redhat.com>
Date: Mon, 17 Mar 2014 12:19:57 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE
 instructions
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com> <f9c71833-f869-440c-8ab1-cd1f81f2da3b@email.android.com>
In-Reply-To: <f9c71833-f869-440c-8ab1-cd1f81f2da3b@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/03/2014 23:39, H. Peter Anvin ha scritto:
> MOVAPS, MOVAPD, and MOVDQA are the same operation.  They may, architecturally, have different performance characteristics, but nothing that would affect an emulator.

In fact MOVAPS and MOVAPD are implemented the same way in this patch:

I(Aligned, em_mov), I(Aligned, em_mov), N, N,

These are respectively for no prefix, 0x66, 0xf2 and 0xf3.  MOVDQA was 
already implemented, but on AMD some memcpy implementations use MOVAPS 
because it's a byte shorter.

Paolo

> On March 15, 2014 1:01:58 PM PDT, Igor Mammedov <imammedo@redhat.com> wrote:
>> MS HCK test fails on 32-bit Windows 8.1 due to missing MOVAPS
>> instruction emulation, this series adds it and while at it,
>> it adds emulation of MOVAPD which is trivial to implement on
>> top of MOVAPS.
>>
>> Igor Mammedov (2):
>>  KVM: x86 emulator: emulate MOVAPS
>>  KVM: x86 emulator: emulate MOVAPD
>>
>> arch/x86/kvm/emulate.c | 8 +++++++-
>> 1 file changed, 7 insertions(+), 1 deletion(-)
>

