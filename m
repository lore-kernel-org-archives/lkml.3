Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaJXJfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:35:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJXJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:35:20 -0400
Date: Fri, 24 Oct 2014 02:35:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/4] vfs: Prepare for adding a new preadv/pwritev with
 user flags.
Message-ID: <20141024093518.GA29178@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <9306856a3ea74bcc41523430d74ef4be93d8f436.1413923420.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9306856a3ea74bcc41523430d74ef4be93d8f436.1413923420.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:46:56PM -0400, Milosz Tanski wrote:
> Plumbing the flags argument through the vfs code so they can be passed down to
> __generic_file_(read/write)_iter function that do the acctual work.
> 
> Signed-off-by: Milosz Tanski <milosz@adfin.com>


The last hunk doesn't belong into this patch, both logically and because
the code won't actually compile after applying just this patch.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>


This is the culprit:

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 14b4642..cb7f530 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1465,7 +1465,7 @@ static void shrink_readahead_size_eio(struct file *filp,
>   * of the logic when it comes to error handling etc.
>   */
>  static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
> -		struct iov_iter *iter, ssize_t written)
> +		struct iov_iter *iter, ssize_t written, int flags)
>  {
>  	struct address_space *mapping = filp->f_mapping;
>  	struct inode *inode = mapping->host;
