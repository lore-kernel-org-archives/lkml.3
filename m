Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3JCG3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:29:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3JCG3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:29:16 -0400
Date: Thu, 3 Oct 2013 09:28:59 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131003062859.GV17294@redhat.com>
References: <20131001083908.GA17294@redhat.com>
 <1380620338.645.22.camel@pasglop>
 <524AAFAA.3010801@redhat.com>
 <20131002050940.GA25363@drongo>
 <524BDD73.3020106@redhat.com>
 <1380704789.645.57.camel@pasglop>
 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
 <20131002100224.GF17294@redhat.com>
 <1380751642.645.71.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380751642.645.71.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 08:07:22AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2013-10-02 at 13:02 +0300, Gleb Natapov wrote:
> 
> > Yes, I alluded to it in my email to Paul and Paolo asked also. How this
> > interface is disabled? Also hwrnd is MMIO in a host why guest needs to
> > use hypercall instead of emulating the device (in kernel or somewhere
> > else?). Another things is that on a host hwrnd is protected from
> > direct userspace access by virtue of been a device, but guest code (event
> > kernel mode) is userspace as far as hosts security model goes, so by
> > implementing this hypercall in a way that directly access hwrnd you
> > expose hwrnd to a userspace unconditionally. Why is this a good idea? 
> 
> BTW. Is this always going to be like this ?
> 
If something questionable will be noticed explanation will be required.
It is like that for all arches and all parts of kernel.

> Every *single* architectural or design decision we make for our
> architecture has to be justified 30 times over, every piece of code bike
> shedded to oblivion for month, etc... ?
> 
This is simply not true, most powerpc patches go in without any comments.

> Do we always have to finally get to some kind of agreement on design, go
> to the 6 month bike-shedding phase, just to have somebody else come up
> and start re-questioning the whole original design (without any
> understanding of our specific constraints of course) ?
> 
Do you really think that nobody here understands that exit to userspace
is slow?

> You guys are the most horrendous community I have ever got to work with.
> It's simply impossible to get anything done in any reasonable time
> frame .
> 
> At this stage, it would have taken us an order of magnitude less time to
> simply rewrite an entire hypervisor from scratch.
Of course, it is always much easier to ignore other people input and do
everything your way. Why listen to people who deal with migration issues
for many years if you can commit the patch and forget about it until
migration fails, but who cares, you got there in an order of magnitude
less time and this is what counts.

> 
> This is sad.
> 
Agree.

--
			Gleb.
