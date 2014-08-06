Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaHFOIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:08:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaHFOIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:08:42 -0400
Message-ID: <53E236E6.6050206@redhat.com>
Date: Wed, 06 Aug 2014 16:08:38 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: always exit on EOIs for interrupts listed in
 the IOAPIC redir table
References: <1406736728-8516-1-git-send-email-pbonzini@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AB51BA1@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AB51BA1@SHSMSX104.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/08/2014 16:03, Zhang, Yang Z ha scritto:
> Paolo Bonzini wrote on 2014-07-31:
>> Probably, the guest is masking the interrupt in the redirection table in
>> the interrupt routine, i.e. while the interrupt is set in a LAPIC's ISR.
>> The simplest fix is to ignore the masking state, we would rather have
>> an unnecessary exit rather than a missed IRQ ACK and anyway IOAPIC
>> interrupts are not as performance-sensitive as for example MSIs.
> 
> I feel this fixing may hurt performance in some cases. If the mask
> bit is set, this means the vector in this entry may be used by other
> devices(like a assigned device). But here you set it in eoi exit bitmap
> and this will cause vmexit on each EOI which should not happen.

Note that this *was* reported on an assigned device.

IOAPIC should not be a performance-sensitive path.  High-performance
assigned devices should be using MSIs.

Paolo
