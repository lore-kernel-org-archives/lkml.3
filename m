Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbaCTWPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:15:15 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:46151 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759289AbaCTWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:15:12 -0400
Message-ID: <532B66C2.9020605@redhat.com>
Date: Thu, 20 Mar 2014 23:08:02 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, gleb@kernel.org, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>	 <1395154495-22807-5-git-send-email-pbonzini@redhat.com> <1395347087.632.38.camel@ul30vt.home>
In-Reply-To: <1395347087.632.38.camel@ul30vt.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/03/2014 21:24, Alex Williamson ha scritto:
>> >
>> > +void kvm_ioapic_inject_all(struct kvm_ioapic *ioapic, unsigned long irr)
>> > +{
> nit, kvm_ioapic_state.irr is a u32

Yes, but for_each_set_bit requires unsigned long.

>> > +	u32 idx;
>> > +
>> > +	rtc_irq_eoi_tracking_reset(ioapic);
>> > +	for_each_set_bit(idx, &irr, 32) {
>
> Can we use IOAPIC_NUM_PINS in place of 32?

Yes, indeeed.

> > +		printk("ioapic_service for GSI %d\n", idx);
>
> Is this leftover debugging?  Maybe give it a loglevel if it's
> intentional.  Looks reasonable otherwise.  Thanks,

I'll remove it.  Thanks for the review!

Paolo
