Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3CKRXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:23:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3CKRXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:23:46 -0400
Date: Mon, 11 Mar 2013 19:23:42 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130311172342.GS31619@redhat.com>
References: <513DAE8F.3050102@redhat.com>
 <20130311102852.GE31619@redhat.com>
 <513DBF45.9030803@redhat.com>
 <20130311115144.GG31619@redhat.com>
 <513DDCC2.9070807@redhat.com>
 <20130311135441.GN31619@redhat.com>
 <513DE3C4.5000503@siemens.com>
 <20130311140503.GO31619@redhat.com>
 <513DE8C5.3090209@redhat.com>
 <513DFA01.1040500@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513DFA01.1040500@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 04:36:33PM +0100, Jan Kiszka wrote:
> On 2013-03-11 15:23, Paolo Bonzini wrote:
> > Il 11/03/2013 15:05, Gleb Natapov ha scritto:
> >> On Mon, Mar 11, 2013 at 03:01:40PM +0100, Jan Kiszka wrote:
> >>>> We are not moving away from mp_state, we are moving away from using
> >>>> mp_state for signaling because with nested virt INIT does not always
> >>>> change mp_state, not only that it can change mp_state long after signal
> >>>> is received after vmx off is done.
> >>>
> >>> Right.
> >>>
> >>> BTW, for that to happen, we will also need to influence the INIT level.
> >>> Unless I misread the spec, INIT is blocked while in root mode, and if
> >>> you deassert INIT before leaving root (vmxoff, vmenter), nothing
> >>> actually happens. So what matters is the INIT signal level at the exit
> >>> of root mode.
> >>>
> >> You are talking about INIT# signal received via CPU pin, right? I think
> >> INIT send by IPI cannot go away.
> > 
> > Neither can go away.  For INIT sent by IPI, 10.4.7 says:
> > 
> > Only the Pentium and P6 family processors support the INIT-deassert IPI.
> > An INIT-disassert IPI has no affect on the state of the APIC, other than
> > to reload the arbitration ID register with the value in the APIC ID
> > register.
> > 
> > 18.27.1 also says that "In the local APIC, NMI and INIT (except for INIT
> > deassert) are always treated as edge triggered interrupts".
> > 
> > 
> > For INIT#, the ICH9 chipset says that "INIT# is driven low for 16 PCI
> > clocks" when a soft reset is requested.  So we can guess that INIT# is
> > also edge-triggered.
> 
> Ah, ok. So, virtually, INIT stays asserted until it can be delivered in
> form of a reset or a vmexit.
> 
vmexit clears it?

--
			Gleb.
