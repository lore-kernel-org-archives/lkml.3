Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3CSSj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab3CSSj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:39:28 -0400
Message-ID: <5148B0DC.9000609@redhat.com>
Date: Tue, 19 Mar 2013 19:39:24 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: let userspace inject interrupts into the local APIC
References: <1363708273-19653-1-git-send-email-pbonzini@redhat.com> <20130319181323.GL19292@redhat.com>
In-Reply-To: <20130319181323.GL19292@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/03/2013 19:13, Gleb Natapov ha scritto:
>> > There is no way for userspace to inject interrupts into a VCPU's
>> > local APIC, which is important in order to inject INITs coming from
>> > the chipset.  KVM_INTERRUPT is currently disabled when the in-kernel
>> > local APIC is used, so we can repurpose it.  The shorthand destination
>> > field must contain APIC_DEST_SELF, which has a double effect: first,
>> > the ICR2 register is not used and the 32-bit field of KVM_INTERRUPT is
>> > enough; second, it ensures that the valid range of the irq field is
>> > distinct in the userspace-APIC and kernel-APIC cases.
>> > 
> Init coming from triggering INIT# line should not be modeled as INIT coming from
> APIC.

Then Jan's patch was wrong, and INIT should not have been an apic event
(perhaps SIPI should).

> In fact INIT cannot be send using SELF shorthand.

Where does the SDM say that?

Paolo

> If APIC code will be fixed to check for that this code will break.
