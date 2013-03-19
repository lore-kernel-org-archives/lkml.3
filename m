Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab3CSF6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:58:21 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53372 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3CSF6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:58:20 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-ee-5147fe7ae770
Date: Tue, 19 Mar 2013 14:58:40 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 2/3] mm, nobootmem: clean-up of
 free_low_memory_core_early()
Message-ID: <20130319055840.GF8858@lge.com>
References: <1363670161-9214-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1363670161-9214-2-git-send-email-iamjoonsoo.kim@lge.com>
 <CAE9FiQXypPJbhT4mm-wfbO0G65eNSTRCE0DJoB+bXtNfvg7HbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXypPJbhT4mm-wfbO0G65eNSTRCE0DJoB+bXtNfvg7HbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:51:43PM -0700, Yinghai Lu wrote:
> On Mon, Mar 18, 2013 at 10:16 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > Remove unused argument and make function static,
> > because there is no user outside of nobootmem.c
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
> > index cdc3bab..5f0b0e1 100644
> > --- a/include/linux/bootmem.h
> > +++ b/include/linux/bootmem.h
> > @@ -44,7 +44,6 @@ extern unsigned long init_bootmem_node(pg_data_t *pgdat,
> >                                        unsigned long endpfn);
> >  extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
> >
> > -extern unsigned long free_low_memory_core_early(int nodeid);
> >  extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
> >  extern unsigned long free_all_bootmem(void);
> >
> > diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> > index 4711e91..589c673 100644
> > --- a/mm/nobootmem.c
> > +++ b/mm/nobootmem.c
> > @@ -120,7 +120,7 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
> >         return end_pfn - start_pfn;
> >  }
> >
> > -unsigned long __init free_low_memory_core_early(int nodeid)
> > +static unsigned long __init free_low_memory_core_early()
> 
> (void) ?

Yes, fixed version is already sent.
Thanks.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
