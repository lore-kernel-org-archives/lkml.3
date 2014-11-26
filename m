Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaKZO6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:58:17 -0500
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:57140
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaKZO6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:58:16 -0500
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-3-git-send-email-alex.bennee@linaro.org> <20141126143122.GB3245@hawk.usersys.redhat.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de,
        Catalin Marinas <catalin.marinas@arm.com>, jan.kiszka@siemens.com,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com,
        r65777@freescale.com, pbonzini@redhat.com, bp@suse.de
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
In-reply-to: <20141126143122.GB3245@hawk.usersys.redhat.com>
Date: Wed, 26 Nov 2014 14:58:16 +0000
Message-ID: <87sih6knzr.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Tue, Nov 25, 2014 at 04:10:00PM +0000, Alex Bennée wrote:
>> This commit defines the API headers for guest debugging. There are two
>> architecture specific debug structures:
<snip>
>> +/* Architecture related debug defines - upper 16 bits of
>> + * kvm_guest_debug->control
>> + */
>> +#define KVM_GUESTDBG_USE_SW_BP_SHIFT	16
>> +#define KVM_GUESTDBG_USE_SW_BP		(1 << KVM_GUESTDBG_USE_SW_BP_SHIFT)
>> +#define KVM_GUESTDBG_USE_HW_BP_SHIFT	17
>> +#define KVM_GUESTDBG_USE_HW_BP		(1 << KVM_GUESTDBG_USE_HW_BP_SHIFT)
>> +
>
> I see this are defined in arch/x86/include/uapi/asm/kvm.h,
> so you needed to reproduce them here, but shouldn't they
> be promoted to include/uapi/linux/kvm.h instead?

Well if we move them to common uapi we either restrict the $ARCH
specific options that don't have SW/HW BKPTS (would be weird but...) or
make them generic in the lower 16 bits (breaks API).

But in principle I have no objection if other don't.

-- 
Alex Bennée
