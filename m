Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762356Ab3DCRAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:00:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35533 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757417Ab3DCRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:00:13 -0400
Date: Wed, 3 Apr 2013 12:00:12 -0500
From: Robin Holt <holt@sgi.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Robin Holt <holt@sgi.com>, Cliff Wickman <cpw@sgi.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        wli@holomorphy.com
Subject: Re: [PATCH] mm, x86: Do not zero hugetlbfs pages at boot. -v2
Message-ID: <20130403170012.GY29151@sgi.com>
References: <E1UDME8-00041J-B4@eag09.americas.sgi.com>
 <20130314085138.GA11636@dhcp22.suse.cz>
 <20130403024344.GA4384@sgi.com>
 <20130403140247.GJ16471@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403140247.GJ16471@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 04:02:47PM +0200, Michal Hocko wrote:
> On Tue 02-04-13 21:43:44, Robin Holt wrote:
> [...]
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index ca9a7c6..7683f6a 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1185,7 +1185,7 @@ int __weak alloc_bootmem_huge_page(struct hstate *h)
> >  	while (nr_nodes) {
> >  		void *addr;
> >  
> > -		addr = __alloc_bootmem_node_nopanic(
> > +		addr = __alloc_bootmem_node_nopanic_notzeroed(
> >  				NODE_DATA(hstate_next_node_to_alloc(h,
> >  						&node_states[N_MEMORY])),
> >  				huge_page_size(h), huge_page_size(h), 0);
> 
> Ohh, and powerpc seems to have its own opinion how to allocate huge
> pages. See arch/powerpc/mm/hugetlbpage.c

Do I need to address their allocations?  Can I leave that part of the
changes as something powerpc can address if they are affected by this?

Robin
