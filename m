Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3EHTLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:11:19 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28660 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753328Ab3EHTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:11:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OEuyMl2QDw/GTU0z47zDU
Date: Wed, 8 May 2013 12:11:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Christoph Lameter <cl@linux.com>
Cc: Chris Mason <clmason@fusionio.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SLAB changes for v3.10
Message-ID: <20130508191109.GB32546@atomide.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
 <20130508003022.GS28721@atomide.com>
 <20130508042422.GU28721@atomide.com>
 <20130508181353.23991.17852@localhost.localdomain>
 <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
 <20130508184817.4271.72594@localhost.localdomain>
 <0000013e85852607-fd84223c-112e-46b9-a60f-73d9597d90ac-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013e85852607-fd84223c-112e-46b9-a60f-73d9597d90ac-000000@email.amazonses.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux.com> [130508 12:06]:
> On Wed, 8 May 2013, Chris Mason wrote:
> 
> > > You correctly moved the checks out of the if (!kmalloc_cacheS())
> > > condition so that the caches are created properly.
> >
> > But if the ordering is required at all, why is it ok to create cache 2
> > after cache 6 instead of after cache 7?
> 
> The power of two caches are 2^x beginning with KMALLOC_MIN_SHIFT. The non
> power of two caches were folded into number 1 + 2 since they do not fit
> into the scheme and they are special cased throughout. This works since
> the minimal slab cache size is 8 bytes.
> 
> > IOW if we can safely do cache 2 after cache 6, why can't we just do both
> > cache 1 and cache 2 after the loop?
> 
> Because the cache creation in SLAB can cause the use of a fractional slab
> size if kmem_cache_create() thinks its better to put the metadata on a
> different slab cache (OFF_SLAB type) because data will align better that
> way. Its weird I know but its due to the way that SLAB aligns data in the
> page frame.

Hmm OK so kmalloc_caches[7] got created earlier with INDEX_AC != INDEX_NODE,
and those are defined as:

#define INDEX_AC kmalloc_index(sizeof(struct arraycache_init))
#define INDEX_NODE kmalloc_index(sizeof(struct kmem_cache_node))

So the different sizes for the structs can trigger it like Pekka was
speculating earlier.

Regards,

Tony
