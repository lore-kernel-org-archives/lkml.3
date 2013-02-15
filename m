Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222Ab3BOAIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 19:08:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:55910 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935201Ab3BOAIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 19:08:20 -0500
Message-ID: <1360886876.22260.9.camel@pasglop>
Subject: Re: [RFC PATCH] virt_mmio: fix signature checking for BE guests
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 15 Feb 2013 11:07:56 +1100
In-Reply-To: <511BB134.30003@arm.com>
References: <1360765538-18097-1-git-send-email-marc.zyngier@arm.com>
	 <1360768102.4045.107.camel@hornet> <511BB134.30003@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 15:28 +0000, Marc Zyngier wrote:

> Well, the spec clearly says that the registers reflect the endianess of
> the guest, and it makes sense: when performing the MMIO access, KVM
> needs to convert between host and guest endianess.

It's actually a horrible idea :-)

What does "guest endianness" means from a qemu perspective if your
emulated CPU can operate in either mode ?

It's actually been causing endless problems, besides linux doesn't have
"Sane" MMIO accessors that say "current endianness". ioreadN/writeN are
LE, realN/writeN are LE, ioreadNbe/iowriteNbe are BE always, the only
"whatever my endianness is" are the __raw ones which also don't have
barriers etc...  

> > Having said that, does the change make everything else work with a BE
> > guest? (I assume we're talking about the guest being BE, right? ;-) If
> > so it means that the host is not following the current spec and it
> > treats all the registers as LE.
> 
> Yes, I only care about a BE guest. And no, not much is actually working
> (kvmtool is not happy about the guest addresses it finds in the
> virtio-ring). Need to dive into it and understand what needs to be fixed...
> 
> >> - Reading the MAGIC register byte by byte. Is that allowed? The spec
> >>   only says it is 32bit wide.
> > 
> > And the spirit of the spec was: _exactly 32bit wide_. It's just simpler
> > to implement one access width on the host side.
> 
> I guessed as much...

Cheers,
Ben.


