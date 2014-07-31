Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaGaQ5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:57:49 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55731 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaGaQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:57:45 -0400
Message-ID: <53DA7583.2030504@redhat.com>
Date: Thu, 31 Jul 2014 18:57:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
CC: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Gleb Natapov <gleb@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo
 regs
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
In-Reply-To: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/07/2014 15:55, Alex Bennée ha scritto:
> To cleanly restore an SMP VM we need to ensure that the current pause
> state of each vcpu is correctly recorded. Things could get confused if
> the CPU starts running after migration restore completes when it was
> paused before it state was captured.
> 
> I've done this by exposing a register (currently only 1 bit used) via
> the GET/SET_ONE_REG logic to pass the state between KVM and the VM
> controller (e.g. QEMU).
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  arch/arm64/include/uapi/asm/kvm.h |  8 +++++
>  arch/arm64/kvm/guest.c            | 61 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 68 insertions(+), 1 deletion(-)

Since it's a pseudo register anyway, would it make sense to use the
existing KVM_GET/SET_MP_STATE ioctl interface?

How is this represented within QEMU in TCG mode?  Also, how is KVM/ARM
representing (and passing to QEMU) the halted state of the VCPU?

Paolo
