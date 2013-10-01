Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab3JAIec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:34:32 -0400
Received: from ozlabs.org ([203.10.76.45]:50182 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab3JAIea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:34:30 -0400
Date: Tue, 1 Oct 2013 18:34:26 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, gleb@redhat.com, agraf@suse.de,
        mpm@selenic.com, herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131001083426.GB27484@concordia>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
 <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
 <5243F933.7000907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5243F933.7000907@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 11:06:59AM +0200, Paolo Bonzini wrote:
> Il 26/09/2013 08:31, Michael Ellerman ha scritto:
> > Some powernv systems include a hwrng. Guests can access it via the
> > H_RANDOM hcall.
> 
> Is there any reason to do this in the kernel?  

It's less code, and it's faster :)

> It does not have to be a particularly fast path;

Sure, but do we have to make it slow on purpose?

> on x86, we are simply forwarding /dev/hwrng or
> /dev/random data to the guest.  You can simply use virtio-rng.

Not all guests support virtio-rng.

> If you really want to have the hypercall, implementing it in QEMU means
> that you can support it on all systems, in fact even when running
> without KVM.  

Sure, I can add a fallback to /dev/hwrng for full emulation.

> The QEMU command line would be something like "-object
> rng-random,filename=/dev/random,id=rng0 -device spapr-rng,rng=rng0".

We can't use /dev/random like that. The PAPR specification, which is
what we're implementing, implies that H_RANDOM provides data from a
hardware source.

cheers
