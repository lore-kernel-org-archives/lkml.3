Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaJ2D21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:28:27 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:35430 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ2D20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:28:26 -0400
MIME-Version: 1.0
In-Reply-To: <1414392371.8884.2.camel@perches.com>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net> <1414392371.8884.2.camel@perches.com>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 29 Oct 2014 11:28:04 +0800
Message-ID: <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
Subject: Re: [RFC V2] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
To: Joe Perches <joe@perches.com>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 2:46 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-10-27 at 14:37 +0800, Wang, Yalin wrote:
>> this change add CONFIG_HAVE_ARCH_BITREVERSE config option,
>> so that we can use arm/arm64 rbit instruction to do bitrev operation
>> by hardware.

I don't see the original patch in my inbox, so replying here.

>>
>> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
>> ---
>>  arch/arm/Kconfig                |  1 +
>>  arch/arm/include/asm/bitrev.h   | 21 +++++++++++++++++++++
>>  arch/arm64/Kconfig              |  1 +
>>  arch/arm64/include/asm/bitrev.h | 21 +++++++++++++++++++++
>>  include/linux/bitrev.h          |  9 +++++++++
>>  lib/Kconfig                     |  9 +++++++++
>>  lib/bitrev.c                    |  2 ++
>>  7 files changed, 64 insertions(+)
>>  create mode 100644 arch/arm/include/asm/bitrev.h
>>  create mode 100644 arch/arm64/include/asm/bitrev.h
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 89c4b5c..426cbcc 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -16,6 +16,7 @@ config ARM
>>       select DCACHE_WORD_ACCESS if HAVE_EFFICIENT_UNALIGNED_ACCESS
>>       select GENERIC_ALLOCATOR
>>       select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)
>> +     select HAVE_ARCH_BITREVERSE if (CPU_V7M || CPU_V7)
>>       select GENERIC_CLOCKEVENTS_BROADCAST if SMP
>>       select GENERIC_IDLE_POLL_SETUP
>>       select GENERIC_IRQ_PROBE

[...]

>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 9532f8d..263c28c 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -36,6 +36,7 @@ config ARM64
>>       select HARDIRQS_SW_RESEND
>>       select HAVE_ARCH_AUDITSYSCALL
>>       select HAVE_ARCH_JUMP_LABEL
>> +     select HAVE_ARCH_BITREVERSE
>>       select HAVE_ARCH_KGDB
>>       select HAVE_ARCH_TRACEHOOK
>>       select HAVE_BPF_JIT

The kconfig lists should be sorted.

Rob
