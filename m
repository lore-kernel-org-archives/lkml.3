Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab3CSF5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:57:51 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57612 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3CSF5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:57:50 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-6c-5147fe5a203e
Date: Tue, 19 Mar 2013 14:58:08 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 3/3] mm, nobootmem: do memset() after memblock_reserve()
Message-ID: <20130319055808.GE8858@lge.com>
References: <1363670161-9214-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1363670161-9214-3-git-send-email-iamjoonsoo.kim@lge.com>
 <CAE9FiQU-yCanj_jRSL2Pwdfg7L+832XYnsgR8m2gB=PJdTM_xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQU-yCanj_jRSL2Pwdfg7L+832XYnsgR8m2gB=PJdTM_xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:53:04PM -0700, Yinghai Lu wrote:
> On Mon, Mar 18, 2013 at 10:16 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > Currently, we do memset() before reserving the area.
> > This may not cause any problem, but it is somewhat weird.
> > So change execution order.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> > index 589c673..f11ec1c 100644
> > --- a/mm/nobootmem.c
> > +++ b/mm/nobootmem.c
> > @@ -46,8 +46,8 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
> >                 return NULL;
> >
> >         ptr = phys_to_virt(addr);
> > -       memset(ptr, 0, size);
> >         memblock_reserve(addr, size);
> > +       memset(ptr, 0, size);
> 
> move down ptr = ... too ?
Okay.
I will send v2 soon.

> 
> >         /*
> >          * The min_count is set to 0 so that bootmem allocated blocks
> >          * are never reported as leaks.
> > --
> > 1.7.9.5
> >
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
