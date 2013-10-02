Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3JBJHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:07:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:52713 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab3JBJHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:07:09 -0400
Message-ID: <1380704789.645.57.camel@pasglop>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, agraf@suse.de, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Date: Wed, 02 Oct 2013 19:06:29 +1000
In-Reply-To: <524BDD73.3020106@redhat.com>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
	 <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
	 <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia>
	 <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop>
	 <524AAFAA.3010801@redhat.com> <20131002050940.GA25363@drongo>
	 <524BDD73.3020106@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 10:46 +0200, Paolo Bonzini wrote:

> 
> Thanks.  Any chance you can give some numbers of a kernel hypercall and
> a userspace hypercall on Power, so we have actual data?  For example a
> hypercall that returns H_PARAMETER as soon as possible.

I don't have (yet) numbers at hand but we have basically 3 places where
we can handle hypercalls:

 - Kernel real mode. This is where most of our MMU stuff goes for
example unless it needs to trigger a page fault in Linux. This is
executed with translation disabled and the MMU still in guest context.
This is the fastest path since we don't take out the other threads nor
perform any expensive context change. This is where we put the
"accelerated" H_RANDOM as well.

 - Kernel virtual mode. That's a full exit, so all threads are out and
MMU switched back to host Linux. Things like vhost MMIO emulation goes
there, page faults, etc...

 - Qemu. This adds the round trip to userspace on top of the above.

Cheers,
Ben.


