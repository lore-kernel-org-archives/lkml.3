Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaKZNPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:15:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbaKZNPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:15:19 -0500
Message-ID: <5475D236.1070305@redhat.com>
Date: Wed, 26 Nov 2014 14:14:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
CC: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Bharat Bhushan <r65777@freescale.com>, bp@suse.de,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-3-git-send-email-alex.bennee@linaro.org> <5474B6BC.2060309@redhat.com> <CAFEAcA-ikeiciAh4RXpKQQ_pY9FRePxR7nEBUEjcaaxB0ZAAtA@mail.gmail.com> <5474BAD8.7010307@redhat.com> <87vbm2ksui.fsf@linaro.org>
In-Reply-To: <87vbm2ksui.fsf@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/11/2014 14:13, Alex Bennée wrote:
> 
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 25/11/2014 18:13, Peter Maydell wrote:
>>> On 25 November 2014 at 17:05, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>>> So there is no register that says "this breakpoint has triggered" or
>>>>> "this watchpoint has triggered"?
>>> Nope. You take a debug exception; the syndrome register tells
>>> you if it was a bp or a wp, and if it was a wp the fault address
>>> register tells you the address being accessed (if it was a bp
>>> you know the program counter, obviously). The debugger is expected
>>> to be able to figure it out from there, if it cares.
>>
>> That's already good enough---do the KVM_DEBUG_EXIT_* constants match the
>> syndrome register, or if not why?
> 
> No they don't. I did consider it at the time but I was wary of pulling
> too much over into the uapi headers wholesale. If your happy to do that
> I'll include the change in my next version.
> 
> I could also rationalise the exit handlers as they all pretty much do
> the same thing (save for the exit/syndrome related info). Again I was
> keeping things nicely separated in case any particular exception needed
> excessive special case handling.
> 
> Would you like those changes?

Yes, please.

Paolo
