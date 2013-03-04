Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab3CDCHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:07:37 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34382 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3CDCHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:07:36 -0500
Date: Mon, 4 Mar 2013 10:07:47 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, andi@firstfloor.org, akpm@linux-foundation.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mm: Export split_page().
Message-ID: <20130304020747.GA8265@kroah.com>
References: <1362364075-14564-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362364075-14564-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 06:27:55PM -0800, K. Y. Srinivasan wrote:
> The split_page() function will be very useful for balloon drivers. On Hyper-V,
> it will be very efficient to use 2M allocations in the guest as this (a) makes
> the ballooning protocol with the host that much more efficient and (b) moving
> memory in 2M chunks minimizes fragmentation in the host. Export the split_page()
> function to let the guest allocations be in 2M chunks while the host is free to
> return this memory at arbitrary granularity.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
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

When you export a symbol, you also need to post the code that is going
to use that symbol, otherwise people don't really know how to judge this
request.

Can you just make this a part of your balloon driver update patch series
instead?

thanks,

greg k-h
