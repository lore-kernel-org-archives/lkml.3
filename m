Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3EHTBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:01:38 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:36103 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab3EHTBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:01:37 -0400
Date: Wed, 8 May 2013 19:01:35 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Chris Mason <clmason@fusionio.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [GIT PULL] SLAB changes for v3.10
In-Reply-To: <20130508184817.4271.72594@localhost.localdomain>
Message-ID: <0000013e85852607-fd84223c-112e-46b9-a60f-73d9597d90ac-000000@email.amazonses.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org> <20130508003022.GS28721@atomide.com> <20130508042422.GU28721@atomide.com> <20130508181353.23991.17852@localhost.localdomain> <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
 <20130508184817.4271.72594@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.08-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Chris Mason wrote:

> > You correctly moved the checks out of the if (!kmalloc_cacheS())
> > condition so that the caches are created properly.
>
> But if the ordering is required at all, why is it ok to create cache 2
> after cache 6 instead of after cache 7?

The power of two caches are 2^x beginning with KMALLOC_MIN_SHIFT. The non
power of two caches were folded into number 1 + 2 since they do not fit
into the scheme and they are special cased throughout. This works since
the minimal slab cache size is 8 bytes.

> IOW if we can safely do cache 2 after cache 6, why can't we just do both
> cache 1 and cache 2 after the loop?

Because the cache creation in SLAB can cause the use of a fractional slab
size if kmem_cache_create() thinks its better to put the metadata on a
different slab cache (OFF_SLAB type) because data will align better that
way. Its weird I know but its due to the way that SLAB aligns data in the
page frame.

