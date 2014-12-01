Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaLAR4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:56:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbaLAR4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:56:31 -0500
Message-ID: <547CABC6.7030309@redhat.com>
Date: Mon, 01 Dec 2014 18:56:22 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
Subject: Re: [PATCH 0/4] KVM: x86: APIC fixes
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com> <547C95B8.7020300@redhat.com> <20141201175505.GA22851@potion.brq.redhat.com>
In-Reply-To: <20141201175505.GA22851@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/12/2014 18:55, Radim Krčmář wrote:
> 2014-12-01 17:22+0100, Paolo Bonzini:
>> On 27/11/2014 20:03, Radim Krčmář wrote:
>>> The interesting one is [3/4], which improves upon a previous CVE fix;
>>> we also handle logical destination wrapping in it, so [2/4] does the
>>> same for physical;  and to make it nicer, [1/4] removes a condition.
>>> [4/4] makes our fast path return true when the message was handled.
>>>
>>> Radim Krčmář (4):
>>>   KVM: x86: deliver phys lowest-prio
>>>   KVM: x86: fix APIC physical destination wrapping
>>>   KVM: x86: allow 256 logical x2APICs again
>>>   KVM: x86: don't retry hopeless APIC delivery
>>>
>>>  arch/x86/kvm/lapic.c | 20 +++++++++++---------
>>>  arch/x86/kvm/lapic.h |  2 --
>>>  2 files changed, 11 insertions(+), 11 deletions(-)
>>>
>>
>> So the order should be 1/2/5/3/4, right?
> 
> It would be safer, thank you.
> 
> (And when I look at it now, [4/4] would be better as 1st.)

Ok, applying 4/1/2/5/3.

Paolo
