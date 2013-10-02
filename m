Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3JBWDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 18:03:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:42391 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3JBWDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 18:03:17 -0400
Message-ID: <1380751340.645.68.camel@pasglop>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Date: Thu, 03 Oct 2013 08:02:20 +1000
In-Reply-To: <20131002100224.GF17294@redhat.com>
References: <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia>
	 <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop>
	 <524AAFAA.3010801@redhat.com> <20131002050940.GA25363@drongo>
	 <524BDD73.3020106@redhat.com> <1380704789.645.57.camel@pasglop>
	 <668E4650-BC22-4CBF-A282-E7875DF29DB6@suse.de>
	 <3CBF5732-E7EE-4C96-8132-6D7B77270DAF@suse.de>
	 <20131002100224.GF17294@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 13:02 +0300, Gleb Natapov wrote:

> Yes, I alluded to it in my email to Paul and Paolo asked also. How this
> interface is disabled? Also hwrnd is MMIO in a host why guest needs to
> use hypercall instead of emulating the device (in kernel or somewhere
> else?).

Migration will have to be dealt with one way or another, I suppose we
will indeed need a qemu fallback.

As for why hypercall instead of MMIO, well, you'd have to ask the folks
who wrote the PAPR spec :-) It's specified as a hypercall and
implemented as such in pHyp (PowerVM). The existing guests expect it
that way.

It might have to do with the required whitening done by the hypervisor
(H_RANDOM output is supposed to be clean). It also abstracts us from the
underlying HW implementation which could in theory change.
 
>  Another things is that on a host hwrnd is protected from
> direct userspace access by virtue of been a device, but guest code (event
> kernel mode) is userspace as far as hosts security model goes, so by
> implementing this hypercall in a way that directly access hwrnd you
> expose hwrnd to a userspace unconditionally. Why is this a good idea? 

Why would this be a bad idea ?

Ben.

> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm-ppc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


