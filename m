Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaKZPD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:03:26 -0500
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:57177
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKZPDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:03:24 -0500
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-4-git-send-email-alex.bennee@linaro.org> <20141126143855.GC3245@hawk.usersys.redhat.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Gleb Natapov <gleb@kernel.org>,
        jan.kiszka@siemens.com,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com,
        r65777@freescale.com, pbonzini@redhat.com, bp@suse.de
Subject: Re: [PATCH 3/7] KVM: arm: guest debug, add stub KVM_SET_GUEST_DEBUG ioctl
In-reply-to: <20141126143855.GC3245@hawk.usersys.redhat.com>
Date: Wed, 26 Nov 2014 15:03:14 +0000
Message-ID: <87r3wqknrh.fsf@linaro.org>
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

> On Tue, Nov 25, 2014 at 04:10:01PM +0000, Alex Bennée wrote:
>> This commit adds a stub function to support the KVM_SET_GUEST_DEBUG
>> ioctl. Currently any operation flag will return EINVAL. Actual
>> functionality will be added with further patches.
>
> Technically the stub is already there, and you're extending it to
> start looking at control flags, but still not doing anything yet.

Sure we do:

>>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>>  					struct kvm_guest_debug *dbg)
>>  {
>> -	return -EINVAL;
>> +	/* If it's not enabled clear all flags */
>> +	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
>> +		vcpu->guest_debug = 0;
>> +		return 0;
>> +	}

That's some class non-functionality right there ;-)

>> +	vcpu->guest_debug = dbg->control;
>> +	kvm_info("%s: guest_debug is 0x%lx\n", __func__, vcpu->guest_debug);
>> +
>> +	/* Single Step */
>> +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
>> +		kvm_info("SS requested, not yet implemented\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Software Break Points */
>> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP) {
>> +		kvm_info("SW BP support requested, not yet implemented\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Hardware assisted Break and Watch points */
>> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
>> +		kvm_info("HW BP support requested, not yet implemented\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>>  }
>
> I guess all the kvm_info's were useful for developing this patch series,
> but do we still need them?

They also served the very useful roll of stopping checkpatch.pl bitching
about my reluctance to remove braces from the if () { } clauses. However
I take your point. I can certainly remove the kvm_info() statements as
each bit of functionality is added while leaving this one to help when
someone is bisecting and confused.

-- 
Alex Bennée
