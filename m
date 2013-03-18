Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3CRLDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:03:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab3CRLDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:03:35 -0400
Date: Mon, 18 Mar 2013 12:03:34 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, hannes@cmpxchg.org, yinghan@google.com
Subject: Re: [PATCH 1/2] mm: Export split_page()
Message-ID: <20130318110334.GI10192@dhcp22.suse.cz>
References: <1363470088-24565-1-git-send-email-kys@microsoft.com>
 <1363470125-24606-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363470125-24606-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 16-03-13 14:42:04, K. Y. Srinivasan wrote:
> The split_page() function will be very useful for balloon drivers. On Hyper-V,
> it will be very efficient to use 2M allocations in the guest as this (a) makes
> the ballooning protocol with the host that much more efficient and (b) moving
> memory in 2M chunks minimizes fragmentation in the host. Export the split_page()
> function to let the guest allocations be in 2M chunks while the host is free to
> return this memory at arbitrary granularity.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

I do not have any objections to exporting the symbol (at least we
prevent drivers code from inventing their own split_page) but the
Hyper-V specific description should go into Hyper-V patch IMO.

So for the export with a short note that the symbol will be used by
Hyper-V
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/page_alloc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6cacfee..7e0ead6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1404,6 +1404,7 @@ void split_page(struct page *page, unsigned int order)
>  	for (i = 1; i < (1 << order); i++)
>  		set_page_refcounted(page + i);
>  }
> +EXPORT_SYMBOL_GPL(split_page);
>  
>  static int __isolate_free_page(struct page *page, unsigned int order)
>  {
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
