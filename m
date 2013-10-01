Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3JAJjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:39:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:57815 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3JAJjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:39:45 -0400
Message-ID: <1380620338.645.22.camel@pasglop>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, agraf@suse.de, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Date: Tue, 01 Oct 2013 19:38:58 +1000
In-Reply-To: <20131001083908.GA17294@redhat.com>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
	 <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
	 <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia>
	 <20131001083908.GA17294@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 11:39 +0300, Gleb Natapov wrote:
> On Tue, Oct 01, 2013 at 06:34:26PM +1000, Michael Ellerman wrote:
> > On Thu, Sep 26, 2013 at 11:06:59AM +0200, Paolo Bonzini wrote:
> > > Il 26/09/2013 08:31, Michael Ellerman ha scritto:
> > > > Some powernv systems include a hwrng. Guests can access it via the
> > > > H_RANDOM hcall.
> > > 
> > > Is there any reason to do this in the kernel?  
> > 
> > It's less code, and it's faster :)
> > 
> > > It does not have to be a particularly fast path;
> > 
> > Sure, but do we have to make it slow on purpose?
> > 
> We do not put non performance critical devices into the kernel.

So for the sake of that dogma you are going to make us do something that
is about 100 times slower ? (and possibly involves more lines of code)

It's not just speed ... H_RANDOM is going to be called by the guest
kernel. A round trip to qemu is going to introduce a kernel jitter
(complete stop of operations of the kernel on that virtual processor) of
a full exit + round trip to qemu + back to the kernel to get to some
source of random number ...  this is going to be in the dozens of ns at
least.

This makes no sense.

Ben.


