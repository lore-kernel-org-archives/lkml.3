Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3LPKzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:55:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab3LPKze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:55:34 -0500
Date: Mon, 16 Dec 2013 08:55:15 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/6] mm/migrate: add comment about permanent failure
 path
Message-ID: <20131216105514.GA16165@localhost.localdomain>
References: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1386917611-11319-2-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386917611-11319-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 03:53:26PM +0900, Joonsoo Kim wrote:
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> Let's add a comment about where the failed page goes to, which makes
> code more readable.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 3747fcd..c6ac87a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1123,7 +1123,12 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
>  				nr_succeeded++;
>  				break;
>  			default:
> -				/* Permanent failure */
> +				/*
> +				 * Permanent failure (-EBUSY, -ENOSYS, etc.):
> +				 * unlike -EAGAIN case, the failed page is
> +				 * removed from migration page list and not
> +				 * retried in the next outer loop.
> +				 */
>  				nr_failed++;
>  				break;
>  			}

Acked-by: Rafael Aquini <aquini@redhat.com>

