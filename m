Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaHUM1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:27:36 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57338 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbaHUM1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:27:35 -0400
Message-ID: <53F5E5B1.6020106@redhat.com>
Date: Thu, 21 Aug 2014 14:27:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 1/6] KVM: add kvm_arch_sched_in
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com> <1408567997-21222-2-git-send-email-rkrcmar@redhat.com> <53F5ADF6.7060000@redhat.com> <20140821113801.GA20546@potion.brq.redhat.com>
In-Reply-To: <20140821113801.GA20546@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/08/2014 13:38, Radim Krčmář ha scritto:
> 2014-08-21 10:29+0200, Paolo Bonzini:
>> Il 20/08/2014 22:53, Radim Krčmář ha scritto:
>>> Introduce preempt notifiers for architecture specific code.
>>> Advantage over creating a new notifier in every arch is slightly simpler
>>> code and guaranteed call order with respect to kvm_sched_in.
>>>
>>> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
>>> ---
>>>  arch/arm/kvm/arm.c         | 4 ++++
>>>  arch/mips/kvm/mips.c       | 4 ++++
>>>  arch/powerpc/kvm/powerpc.c | 4 ++++
>>>  arch/s390/kvm/kvm-s390.c   | 4 ++++
>>>  arch/x86/kvm/x86.c         | 4 ++++
>>
>> What about adding them as static inlines in
>> arch/*/include/asm/kvm_host.h (except for arch/x86 of course)?
> 
> All empty arch functions are in '.c' files, so it seems better to follow
> the same path.
> (And have one refactoring patch if GCC does not optimize this.)

GCC certainly does not optimize this (unless you use LTO).

Paolo

