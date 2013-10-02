Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3JBOhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:37:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab3JBOhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:37:34 -0400
Date: Wed, 2 Oct 2013 17:37:20 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131002143720.GK17294@redhat.com>
References: <524AAFAA.3010801@redhat.com>
 <20131002050940.GA25363@drongo>
 <524BDD73.3020106@redhat.com>
 <1380704789.645.57.camel@pasglop>
 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
 <20131002100224.GF17294@redhat.com>
 <1380722275.12149.28.camel@concordia>
 <029A8D6C-C23C-42B2-8C26-D76B59E2C9DD@suse.de>
 <524C2EAE.7090209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C2EAE.7090209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:33:18PM +0200, Paolo Bonzini wrote:
> Il 02/10/2013 16:08, Alexander Graf ha scritto:
> > > The hwrng is accessible by host userspace via /dev/mem.
> > 
> > A guest should live on the same permission level as a user space
> > application. If you run QEMU as UID 1000 without access to /dev/mem, why
> > should the guest suddenly be able to directly access a memory location
> > (MMIO) it couldn't access directly through a normal user space interface.
> > 
> > It's basically a layering violation.
> 
> With Michael's earlier patch in this series, the hwrng is accessible by
> host userspace via /dev/hwrng, no?
> 
Access to which can be controlled by its permission. Permission of
/dev/kvm may be different. If we route hypercall via userspace and
configure qemu to get entropy from /dev/hwrng everything will fall
nicely together (except performance).

--
			Gleb.
