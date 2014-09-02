Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaIBMc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbaIBMc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:32:57 -0400
Date: Tue, 2 Sep 2014 08:32:40 -0400
From: Rafael Aquini <aquini@redhat.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 3/6] mm/balloon_compaction: isolate balloon pages
 without lru_lock
Message-ID: <20140902123239.GD14419@t510.redhat.com>
References: <20140830163834.29066.98205.stgit@zurg>
 <20140830164117.29066.18189.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140830164117.29066.18189.stgit@zurg>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 08:41:17PM +0400, Konstantin Khlebnikov wrote:
> From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> 
> LRU-lock isn't required for balloon page isolation. This check makes migration
> of some ballooned pages mostly impossible because isolate_migratepages_range()
> drops LRU lock periodically.
> 
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Cc: stable <stable@vger.kernel.org> # v3.8
> ---
>  mm/compaction.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 73466e1..ad58f73 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -643,7 +643,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
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

