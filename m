Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaCQJa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:30:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbaCQJa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:30:56 -0400
Message-ID: <5326C0C3.6000105@redhat.com>
Date: Mon, 17 Mar 2014 10:30:43 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE
 instructions
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com> <8569d2b4-0593-4f7a-859c-3848670f718d@email.android.com>
In-Reply-To: <8569d2b4-0593-4f7a-859c-3848670f718d@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/03/2014 23:42, H. Peter Anvin ha scritto:
> Stupid question... what instructions do NOT need emulsion in KVM? It would seem that at least anything that touches memory would?

Yes, indeed.  Anything that touches memory can be used on MMIO and then 
needs emulation.

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

