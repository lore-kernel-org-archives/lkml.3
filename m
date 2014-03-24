Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaCXR5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:57:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbaCXR5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:57:12 -0400
Date: Mon, 24 Mar 2014 18:55:11 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 3/4] KVM: ioapic: extract body of kvm_ioapic_set_irq
Message-ID: <20140324175508.GA6143@potion.brq.redhat.com>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
 <1395394081-16252-4-git-send-email-pbonzini@redhat.com>
 <20140321185858.GA22118@potion.brq.redhat.com>
 <532E9EEF.2080906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <532E9EEF.2080906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-23 09:44+0100, Paolo Bonzini:
> Il 21/03/2014 19:58, Radim Krčmář ha scritto:
> >>> +	/*
> >>> +	 * Return 0 for coalesced interrupts; for edge-triggered interrupts,
> >>> +	 * this only happens if a previous edge has not been delivered due
> >>> +	 * do masking.  For level interrupts, the remote_irr field tells
> >          (^ to)
> >>> +	 * us if the interrupt is waiting for an EOI.
> >
> >How do we know we haven't delivered an edge-triggered interrupt when
> >ioapic_service() always clears this IRR bit?
> 
> We know we have at least delivered it to the local APIC(s).  If it
> is masked in the ioredirtbl, ioapic_service doesn't clear the IRR.

I see, LAPIC can't "refuse" an interrupt, so kvm_irq_delivery_to_apic()
won't (mustn't) fail. (The code looks fragile if it returned -1.)

Thanks.
