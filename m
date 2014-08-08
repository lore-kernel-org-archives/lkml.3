Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaHHPzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:55:01 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:50348
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbaHHPzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:55:00 -0400
Date: Fri, 8 Aug 2014 10:54:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH for v3.17-rc1] Revert "slab: remove BAD_ALIEN_MAGIC"
In-Reply-To: <CAMuHMdVZdaVeYY=A=eVEC67GGyQNq2XZ8wN3fk0+ywtkoa6EmA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1408081049400.24610@gentwo.org>
References: <1407481239-7572-1-git-send-email-iamjoonsoo.kim@lge.com> <alpine.DEB.2.11.1408080943280.16459@gentwo.org> <CAMuHMdVZdaVeYY=A=eVEC67GGyQNq2XZ8wN3fk0+ywtkoa6EmA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014, Geert Uytterhoeven wrote:

> On Fri, Aug 8, 2014 at 4:44 PM, Christoph Lameter <cl@linux.com> wrote:
> > On Fri, 8 Aug 2014, Joonsoo Kim wrote:
> >
> >> This reverts commit a640616822b2 ("slab: remove BAD_ALIEN_MAGIC").
> >
> > Lets hold off on this one. I am bit confused as to why a non NUMA system
> > would have multiple NUMA nodes.
>
> DISCONTIGMEM
>
> mm/Kconfig:
>
> #
> # Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
> # to represent different areas of memory.  This variable allows
> # those dependencies to exist individually.
> #
> config NEED_MULTIPLE_NODES
>         def_bool y
>         depends on DISCONTIGMEM || NUMA

Uhhh... And how does one access memory when the node is != 0 given that
zone_to_nid always returns 0 in the !CONFIG_NUMA case? AFAICT there are
numerous of these node == 0 assumptions in the kernel for !NUMA.

include/linux/mmzone.h:

#ifdef CONFIG_NUMA
#define pfn_to_nid(pfn)                                                 \
({                                                                      \
        unsigned long __pfn_to_nid_pfn = (pfn);                         \
        page_to_nid(pfn_to_page(__pfn_to_nid_pfn));                     \
})
#else
#define pfn_to_nid(pfn)         (0)
#endif


How can this work at all????




