Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3HELVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:21:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab3HELVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:21:21 -0400
Date: Mon, 5 Aug 2013 13:21:19 +0200
From: Jan Kara <jack@suse.cz>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/23] block: implement add_bdi_stat()
Message-ID: <20130805112119.GB25691@quack.suse.cz>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1375582645-29274-9-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375582645-29274-9-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 04-08-13 05:17:10, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> We're going to add/remove a number of page cache entries at once. This
> patch implements add_bdi_stat() which adjusts bdi stats by arbitrary
> amount. It's required for batched page cache manipulations.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/backing-dev.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index c388155..7060180 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -166,6 +166,16 @@ static inline void __dec_bdi_stat(struct backing_dev_info *bdi,
>  	__add_bdi_stat(bdi, item, -1);
>  }
>  
> +static inline void add_bdi_stat(struct backing_dev_info *bdi,
> +		enum bdi_stat_item item, s64 amount)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__add_bdi_stat(bdi, item, amount);
> +	local_irq_restore(flags);
> +}
> +
>  static inline void dec_bdi_stat(struct backing_dev_info *bdi,
>  		enum bdi_stat_item item)
>  {
> -- 
> 1.8.3.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
