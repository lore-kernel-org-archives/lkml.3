Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3FSHKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:10:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3FSHKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:10:47 -0400
Date: Wed, 19 Jun 2013 00:10:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Mel Gorman <mgorman@suse.de>, hannes@cmpxchg.org, riel@redhat.com,
        mhocko@suse.cz, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/vmscan.c: 'lru' may be used without initialized
 after the patch "3abf380..." in next-20130607 tree
Message-Id: <20130619001029.ee623fae.akpm@linux-foundation.org>
In-Reply-To: <51C155D1.3090304@asianux.com>
References: <51C155D1.3090304@asianux.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013 14:55:13 +0800 Chen Gang <gang.chen@asianux.com> wrote:

> 
> 'lru' may be used without initialized, so need regressing part of the
> related patch.
> 
> The related patch:
>   "3abf380 mm: remove lru parameter from __lru_cache_add and lru_cache_add_lru"
>
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -595,6 +595,7 @@ redo:
>  		 * unevictable page on [in]active list.
>  		 * We know how to handle that.
>  		 */
> +		lru = !!TestClearPageActive(page) + page_lru_base_type(page);
>  		lru_cache_add(page);
>  	} else {
>  		/*

That looks right.  Why the heck didn't gcc-4.4.4 (at least) warn about it?
