Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaK3KUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:20:43 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33636 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaK3KUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:20:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141130101056.GB484@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-6-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA-cjM9yUXi6tc79UP0fBKAagtFKQgV3iAjz5DWr9yxZUQ@mail.gmail.com> <20141130101056.GB484@cbox>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Sun, 30 Nov 2014 10:20:19 +0000
Message-ID: <CAFEAcA882aVrnkKFVMaLA0NzkN9OGHJTQseo_w5UFkmBfTDnTQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] KVM: arm64: guest debug, add support for single-step
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Bharat Bhushan <r65777@freescale.com>, bp@suse.de,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 November 2014 at 10:10, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> In any case, I think it was related to how userspace observes the state
> of the CPU, because when you do the MMIO operation emulation in
> userspace, currently if you observe the PC though GET_ONE_REG, you'll
> see a PC pointing to the next instruction, not the one you're emulating
> which is strange.

Also if we ever add support for userspace to say "this MMIO should
fault" then we definitely need the PC-advance to happen afterwards,
not before.

> Not sure what the relation to a guest single-stepping itself was.

I think it just came up in the course of that discussion, because
single-step handling also needs to perform an action (clear PSTATE.SS)
as part of the "advance over this insn" operation. But I think that
you're right that doing the advance before dropping out to userspace
is no worse for singlestep than it is for any other case.

-- PMM
