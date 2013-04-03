Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494Ab3DCOCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:02:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760315Ab3DCOCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:02:48 -0400
Date: Wed, 3 Apr 2013 16:02:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Robin Holt <holt@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, wli@holomorphy.com
Subject: Re: [PATCH] mm, x86: Do not zero hugetlbfs pages at boot. -v2
Message-ID: <20130403140247.GJ16471@dhcp22.suse.cz>
References: <E1UDME8-00041J-B4@eag09.americas.sgi.com>
 <20130314085138.GA11636@dhcp22.suse.cz>
 <20130403024344.GA4384@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403024344.GA4384@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-04-13 21:43:44, Robin Holt wrote:
[...]
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ca9a7c6..7683f6a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1185,7 +1185,7 @@ int __weak alloc_bootmem_huge_page(struct hstate *h)
>  	while (nr_nodes) {
>  		void *addr;
>  
> -		addr = __alloc_bootmem_node_nopanic(
> +		addr = __alloc_bootmem_node_nopanic_notzeroed(
>  				NODE_DATA(hstate_next_node_to_alloc(h,
>  						&node_states[N_MEMORY])),
>  				huge_page_size(h), huge_page_size(h), 0);

Ohh, and powerpc seems to have its own opinion how to allocate huge
pages. See arch/powerpc/mm/hugetlbpage.c

-- 
Michal Hocko
SUSE Labs
