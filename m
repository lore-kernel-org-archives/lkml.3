Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3DYWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:01:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab3DYWA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:00:59 -0400
Date: Thu, 25 Apr 2013 15:00:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] mm, highmem: remove useless virtual variable in
 page_address_map
Message-Id: <20130425150057.c25220a8f03e068f5bea5d58@linux-foundation.org>
In-Reply-To: <1366619188-28087-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366619188-28087-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013 17:26:28 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> We can get virtual address without virtual field.
> So remove it.
> 
> ...
>
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -320,7 +320,6 @@ EXPORT_SYMBOL(kunmap_high);
>   */
>  struct page_address_map {
>  	struct page *page;
> -	void *virtual;
>  	struct list_head list;
>  };
>  
> @@ -362,7 +361,10 @@ void *page_address(const struct page *page)
>  
>  		list_for_each_entry(pam, &pas->lh, list) {
>  			if (pam->page == page) {
> -				ret = pam->virtual;
> +				int nr;
> +
> +				nr = pam - page_address_map;

Doesn't compile.  Presumably you meant page_address_maps.

I'll drop this - please resend if/when it has been runtime tested.


