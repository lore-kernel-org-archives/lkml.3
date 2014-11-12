Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaKLQdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:33:46 -0500
Received: from www.sr71.net ([198.145.64.142]:58408 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaKLQdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:33:45 -0500
Message-ID: <54638BE4.3080509@sr71.net>
Date: Wed, 12 Nov 2014 08:33:40 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Alexander Nyberg <alexn@dsv.su.se>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] mm/page_ext: resurrect struct page extending
 code for debugging
References: <1415780835-24642-1-git-send-email-iamjoonsoo.kim@lge.com> <1415780835-24642-2-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1415780835-24642-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 12:27 AM, Joonsoo Kim wrote:
> @@ -1092,6 +1096,14 @@ struct mem_section {
>  
>  	/* See declaration of similar field in struct zone */
>  	unsigned long *pageblock_flags;
> +#ifdef CONFIG_PAGE_EXTENSION
> +	/*
> +	 * If !SPARSEMEM, pgdat doesn't have page_ext pointer. We use
> +	 * section. (see page_ext.h about this.)
> +	 */
> +	struct page_ext *page_ext;
> +	unsigned long pad;
> +#endif

Will the distributions be amenable to enabling this?  If so, I'm all for
it if it gets us things like page_owner at runtime.

If not, this becomes of much more questionable utility.
