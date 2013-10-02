Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3JBWpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 18:45:51 -0400
Received: from ozlabs.org ([203.10.76.45]:41317 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3JBWpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 18:45:49 -0400
Date: Thu, 3 Oct 2013 08:45:42 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alexander Graf <agraf@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Gleb Natapov <gleb@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131002224542.GA10016@iris.ozlabs.ibm.com>
References: <20131002050940.GA25363@drongo>
 <524BDD73.3020106@redhat.com>
 <1380704789.645.57.camel@pasglop>
 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
 <20131002100224.GF17294@redhat.com>
 <1380722275.12149.28.camel@concordia>
 <029A8D6C-C23C-42B2-8C26-D76B59E2C9DD@suse.de>
 <524C2EAE.7090209@redhat.com>
 <C4834CF8-F81C-4B82-B1A7-1751D50AADB7@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4834CF8-F81C-4B82-B1A7-1751D50AADB7@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:36:05PM +0200, Alexander Graf wrote:
> 
> On 02.10.2013, at 16:33, Paolo Bonzini wrote:
> 
> > Il 02/10/2013 16:08, Alexander Graf ha scritto:
> >>> The hwrng is accessible by host userspace via /dev/mem.
> >> 
> >> A guest should live on the same permission level as a user space
> >> application. If you run QEMU as UID 1000 without access to /dev/mem, why
> >> should the guest suddenly be able to directly access a memory location
> >> (MMIO) it couldn't access directly through a normal user space interface.
> >> 
> >> It's basically a layering violation.
> > 
> > With Michael's earlier patch in this series, the hwrng is accessible by
> > host userspace via /dev/hwrng, no?
> 
> Yes, but there's not token from user space that gets passed into the kernel to check whether access is ok or not. So while QEMU may not have permission to open /dev/hwrng it could spawn a guest that opens it, drains all entropy out of it and thus stall other processes which try to fetch entropy, no?

Even if you drain all entropy out of it, wait 64 microseconds and it
will be full again. :)  Basically it produces 64 bits every
microsecond and puts that in a 64 entry x 64-bit FIFO buffer, which is
what is read by the MMIO.  So there is no danger of stalling other
processes for any significant amount of time.

Paul.
