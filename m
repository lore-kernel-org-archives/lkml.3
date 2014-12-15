Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaLOGrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:47:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaLOGrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:47:21 -0500
Date: Mon, 15 Dec 2014 08:47:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: question about the commits in the vhost tree
Message-ID: <20141215064715.GA24360@redhat.com>
References: <20141215092955.024e334b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215092955.024e334b@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 09:29:55AM +1100, Stephen Rothwell wrote:
> Hi Michael,
> 
> Just wondering if all those commits added to the vhost
> (git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git#linux-next)
> tree today are really destined for v3.19.

Most of them fix static analysis warnings, so I thought they they should
go there.
If there are issues I'd like to know early.

There is a new driver there that might not make it
due to lack of testing:

commit c9a04b96aa6af3a54b9b8d91782fb8f4415e2544
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Thu Dec 11 13:59:51 2014 +0200

    virtio_pci: modern driver
    
    It compiles! Must be perfect.
    
    One thing *not* implemented here is separate mappings
    for descriptor/avail/used rings. That's nice to have,
    will be done later after we have core support.
    
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

and it's dependencies:

commit fe13940bd8d00add4460c0a920d38d5f4385f0bb
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Sun Dec 14 15:15:55 2014 +0200

    virtio_pci: macros for PCI layout offsets.
    
    QEMU wants it, so why not?  Trust, but verify.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

commit 33028c00ddfb7bf433c9d020a7fd61f421daee76
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 29 11:52:22 2013 +0930

    virtio-pci: define layout for virtio 1.0
    
    Based on patches by Michael S. Tsirkin <mst@redhat.com>, but I found it
    hard to follow so changed to use structures which are more
    self-documenting.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>



commit 772b824772ad7f015534671136addcd00082d246
Author: Michael S Tsirkin <mst@redhat.com>
Date:   Wed May 29 11:52:21 2013 +0930

    s390: add pci_iomap_range
    
    Virtio drivers should map the part of the range they need, not
    necessarily all of it.
    To this end, support mapping ranges within BAR on s390.
    Since multiple ranges can now be mapped within a BAR, we keep track of
    the number of mappings created, and only clear out the mapping for a BAR
    when this number reaches 0.
    
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

commit 85f88e2d98c1bc6f34c3b625de2d9abfefdcde9d
Author: Michael S Tsirkin <mst@redhat.com>
Date:   Wed May 29 11:52:21 2013 +0930

    pci: add pci_iomap_range
    
    Virtio drivers should map the part of the BAR they need, not necessarily
    all of it.
    
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

but they are well contained so I was hoping putting them in linux-next
will not harm anyone and help more people test it.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


