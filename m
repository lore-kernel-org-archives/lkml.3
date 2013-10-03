Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3JCGJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:09:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab3JCGI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:08:59 -0400
Date: Thu, 3 Oct 2013 09:08:40 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131003060840.GA4017@redhat.com>
References: <524BDD73.3020106@redhat.com>
 <1380704789.645.57.camel@pasglop>
 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
 <20131002100224.GF17294@redhat.com>
 <1380722275.12149.28.camel@concordia>
 <029A8D6C-C23C-42B2-8C26-D76B59E2C9DD@suse.de>
 <524C2EAE.7090209@redhat.com>
 <20131002143720.GK17294@redhat.com>
 <1380752480.645.74.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380752480.645.74.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 08:21:20AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2013-10-02 at 17:37 +0300, Gleb Natapov wrote:
> > On Wed, Oct 02, 2013 at 04:33:18PM +0200, Paolo Bonzini wrote:
> > > Il 02/10/2013 16:08, Alexander Graf ha scritto:
> > > > > The hwrng is accessible by host userspace via /dev/mem.
> > > > 
> > > > A guest should live on the same permission level as a user space
> > > > application. If you run QEMU as UID 1000 without access to /dev/mem, why
> > > > should the guest suddenly be able to directly access a memory location
> > > > (MMIO) it couldn't access directly through a normal user space interface.
> > > > 
> > > > It's basically a layering violation.
> > > 
> > > With Michael's earlier patch in this series, the hwrng is accessible by
> > > host userspace via /dev/hwrng, no?
> > > 
> > Access to which can be controlled by its permission. Permission of
> > /dev/kvm may be different. If we route hypercall via userspace and
> > configure qemu to get entropy from /dev/hwrng everything will fall
> > nicely together (except performance).
> 
> Yes, except abysmall performance and a lot more code for something
> completely and utterly pointless .... nice.
> 
Pointless? You yourself said that fallback to userspace will be required
for migration, so the code have to be there regardless. About abysmal
performance this is what you repeatedly refused to prove. All you
said is that exit to userspace is expensive, we all know that, it is
slow for all arch and all devices implemented in usrerspace, but we do
not move all of them to the kernel. We do move some, most performance
critical, so all you need to show that for typical guest workload having
device in the kernel speed up things measurably. Why not do that instead
of writing rude emails?

--
			Gleb.
