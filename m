Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaE1RLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbaE1RLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:11:43 -0400
Message-ID: <538618C9.10600@redhat.com>
Date: Wed, 28 May 2014 19:11:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, yang.z.zhang@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: lapic: sync highest ISR to hardware apic on EOI
References: <1400856713-18628-1-git-send-email-pbonzini@redhat.com> <20140528165623.GA10861@amt.cnet>
In-Reply-To: <20140528165623.GA10861@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/05/2014 18:57, Marcelo Tosatti ha scritto:
> On Fri, May 23, 2014 at 04:51:53PM +0200, Paolo Bonzini wrote:
>> When Hyper-V enlightenments are in effect, Windows prefers to issue an
>> Hyper-V MSR write to issue an EOI rather than an x2apic MSR write.
>> The Hyper-V MSR write is not handled by the processor, and besides
>> being slower, this also causes bugs with APIC virtualization.  The
>> reason is that on EOI the processor will modify the highest in-service
>> interrupt (SVI) field of the VMCS, as explained in section 29.1.4 of
>> the SDM.
>>
>> We need to do the same, and be careful not to muck with the isr_count
>> and highest_isr_cache fields that are unused when virtual interrupt
>> delivery is enabled.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/lapic.c |   62 ++++++++++++++++++++++++++++++++++---------------
>>  1 files changed, 43 insertions(+), 19 deletions(-)
>
> Why not disable Hyper-V APIC enlightenment if APIC-V is available ?

That would be a good suggestion indeed, but it doesn't help if you just 
keep your old configuration and get new hardware.

Paolo

