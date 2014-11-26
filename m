Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaKZNN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:13:28 -0500
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:56553
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaKZNNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:13:25 -0500
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-3-git-send-email-alex.bennee@linaro.org> <5474B6BC.2060309@redhat.com> <CAFEAcA-ikeiciAh4RXpKQQ_pY9FRePxR7nEBUEjcaaxB0ZAAtA@mail.gmail.com> <5474BAD8.7010307@redhat.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Bharat Bhushan <r65777@freescale.com>, bp@suse.de,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
In-reply-to: <5474BAD8.7010307@redhat.com>
Date: Wed, 26 Nov 2014 13:13:25 +0000
Message-ID: <87vbm2ksui.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 25/11/2014 18:13, Peter Maydell wrote:
>> On 25 November 2014 at 17:05, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> > So there is no register that says "this breakpoint has triggered" or
>>> > "this watchpoint has triggered"?
>> Nope. You take a debug exception; the syndrome register tells
>> you if it was a bp or a wp, and if it was a wp the fault address
>> register tells you the address being accessed (if it was a bp
>> you know the program counter, obviously). The debugger is expected
>> to be able to figure it out from there, if it cares.
>
> That's already good enough---do the KVM_DEBUG_EXIT_* constants match the
> syndrome register, or if not why?

No they don't. I did consider it at the time but I was wary of pulling
too much over into the uapi headers wholesale. If your happy to do that
I'll include the change in my next version.

I could also rationalise the exit handlers as they all pretty much do
the same thing (save for the exit/syndrome related info). Again I was
keeping things nicely separated in case any particular exception needed
excessive special case handling.

Would you like those changes?

>
> Paolo

-- 
Alex Bennée
