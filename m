Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaCWIom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 04:44:42 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44701 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaCWIog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 04:44:36 -0400
Message-ID: <532E9EEF.2080906@redhat.com>
Date: Sun, 23 Mar 2014 09:44:31 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 3/4] KVM: ioapic: extract body of kvm_ioapic_set_irq
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com> <1395394081-16252-4-git-send-email-pbonzini@redhat.com> <20140321185858.GA22118@potion.brq.redhat.com>
In-Reply-To: <20140321185858.GA22118@potion.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/03/2014 19:58, Radim Krčmář ha scritto:
>> > +	/*
>> > +	 * Return 0 for coalesced interrupts; for edge-triggered interrupts,
>> > +	 * this only happens if a previous edge has not been delivered due
>> > +	 * do masking.  For level interrupts, the remote_irr field tells
>           (^ to)
>> > +	 * us if the interrupt is waiting for an EOI.
>
> How do we know we haven't delivered an edge-triggered interrupt when
> ioapic_service() always clears this IRR bit?

We know we have at least delivered it to the local APIC(s).  If it is 
masked in the ioredirtbl, ioapic_service doesn't clear the IRR.

Paolo
