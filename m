Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaKYRN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:13:28 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:51426 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaKYRNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:13:25 -0500
MIME-Version: 1.0
In-Reply-To: <5474B6BC.2060309@redhat.com>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-3-git-send-email-alex.bennee@linaro.org> <5474B6BC.2060309@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 25 Nov 2014 17:13:04 +0000
Message-ID: <CAFEAcA-ikeiciAh4RXpKQQ_pY9FRePxR7nEBUEjcaaxB0ZAAtA@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2014 at 17:05, Paolo Bonzini <pbonzini@redhat.com> wrote:
> So there is no register that says "this breakpoint has triggered" or
> "this watchpoint has triggered"?

Nope. You take a debug exception; the syndrome register tells
you if it was a bp or a wp, and if it was a wp the fault address
register tells you the address being accessed (if it was a bp
you know the program counter, obviously). The debugger is expected
to be able to figure it out from there, if it cares.

-- PMM
