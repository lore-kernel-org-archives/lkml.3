Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3GCP5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:57:48 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:43048 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169Ab3GCP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:57:47 -0400
Date: Wed, 3 Jul 2013 15:57:45 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [RFC PATCH 1/5] mm, page_alloc: support multiple pages
 allocation
In-Reply-To: <1372840460-5571-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000013fa540f411-a89dd4a2-0fc9-428d-ad1e-5fa032413911-000000@email.amazonses.com>
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com> <1372840460-5571-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.03-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Joonsoo Kim wrote:

> @@ -298,13 +298,15 @@ static inline void arch_alloc_page(struct page *page, int order) { }
>
>  struct page *
>  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
> -		       struct zonelist *zonelist, nodemask_t *nodemask);
> +		       struct zonelist *zonelist, nodemask_t *nodemask,
> +		       unsigned long *nr_pages, struct page **pages);
>

Add a separate function for the allocation of multiple pages instead?
