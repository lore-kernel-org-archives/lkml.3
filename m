Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaJXJhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:37:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaJXJg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:36:59 -0400
Date: Fri, 24 Oct 2014 02:36:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/4] vfs: Define new syscalls preadv2,pwritev2
Message-ID: <20141024093659.GB29178@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <1613303dfaa91e6ff09cdd7860e0316765663ba6.1413923420.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613303dfaa91e6ff09cdd7860e0316765663ba6.1413923420.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/filemap.c b/mm/filemap.c
> index cb7f530..45964c8 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1735,7 +1735,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  		}
>  	}
>  
> -	retval = do_generic_file_read(file, ppos, iter, retval);
> +	retval = do_generic_file_read(file, ppos, iter, retval, iocb->ki_rwflags);

I think this belongs into the last patch, together with the last hunk
from the first patch.

Otherwise looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
