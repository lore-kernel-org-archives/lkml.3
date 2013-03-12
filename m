Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab3CLL2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255Ab3CLL2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:28:45 -0400
Date: Tue, 12 Mar 2013 13:28:42 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130312112842.GY11223@redhat.com>
References: <20130311174155.GU31619@redhat.com>
 <513E1CFC.6010201@siemens.com>
 <20130311181306.GW31619@redhat.com>
 <513E2220.2090501@siemens.com>
 <20130311183915.GA14689@redhat.com>
 <513E26A7.4020405@siemens.com>
 <20130311185132.GB14689@redhat.com>
 <513E2A0A.3080008@siemens.com>
 <20130311193003.GC14689@redhat.com>
 <513EF48F.20004@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513EF48F.20004@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:25:35AM +0100, Jan Kiszka wrote:
> On 2013-03-11 20:30, Gleb Natapov wrote:
> > On Mon, Mar 11, 2013 at 08:01:30PM +0100, Jan Kiszka wrote:
> >> On 2013-03-11 19:51, Gleb Natapov wrote:
> >>>>> On Intel:
> >>>>> CPU 1                          CPU 2 in a guest mode
> >>>>> send INIT
> >>>>> send SIPI
> >>>>>                                 INIT vmexit
> >>>>>                                 vmxoff
> >>>>>                                 reset and start from SIPI vector
> >>>>
> >>>> Is SIPI sticky as well, even if the CPU is not in the wait-for-SIPI
> >>>> state (but runnable and in vmxon) while receiving it?
> >>>>
> >>> That what they seams to be saying:
> >>>  However, an INIT and SIPI interrupts sent to a CPU during time when
> >>>  it is in a VMX mode are remembered and delivered, perhaps hours later,
> >>>  when the CPU exits the VMX mode
> >>>
> >>> Otherwise their exploit will not work.
> >>
> >> Very weird, specifically as SIPI is not just a binary event but carries
> >> payload. Will another SIPI event overwrite the previously "saved"
> >> vector? We are deep into an underspecified area...
> > My guess is that VMX INIT blocking is done by the same mechanism as
> > INIT blocking during SMM. Obviously after exit from SMM pending
> > INIT/SIPI have to be processed.
> 
> I think this should be further examined via a test case that can run on
> real HW. Is kvm-unit-test ready for this? Then we "just" need to
> implement what you were already asking for: minimalistic nVMX tests...
> 
I do not think kvm-unit-test will run on bare metal. I once implemented
framework for interrupt injection testing that ran on bare metal too. It
was very handy to compare KVM behaviour with real HW, but it was since
folded into kvm-unit-test.

--
			Gleb.
