Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaHTXfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 19:35:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaHTXfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 19:35:22 -0400
Date: Wed, 20 Aug 2014 20:35:06 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] mm/balloon_compaction: isolate balloon pages without
 lru_lock
Message-ID: <20140820233505.GD3457@optiplex.redhat.com>
References: <20140820150435.4194.28003.stgit@buzz>
 <20140820150446.4194.5716.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820150446.4194.5716.stgit@buzz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 07:04:46PM +0400, Konstantin Khlebnikov wrote:
> LRU-lock isn't required for balloon page isolation. This check makes migration
> of some ballooned pages mostly impossible because isolate_migratepages_range()
> drops LRU lock periodically.
>
just for historical/explanatory purposes: https://lkml.org/lkml/2013/12/6/183 

> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Cc: stable <stable@vger.kernel.org> # v3.8
> ---
>  mm/compaction.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 21bf292..0653f5f 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -597,7 +597,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>  		 */
>  		if (!PageLRU(page)) {
>  			if (unlikely(balloon_page_movable(page))) {
> -				if (locked && balloon_page_isolate(page)) {
> +				if (balloon_page_isolate(page)) {
>  					/* Successfully isolated */
>  					goto isolate_success;
>  				}
> 
Acked-by: Rafael Aquini <aquini@redhat.com>
