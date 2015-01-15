Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbbAORLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:11:00 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbbAORK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:10:59 -0500
Date: Thu, 15 Jan 2015 09:10:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 2/7] block: rewrite __bio_copy_iov()
Message-ID: <20150115171058.GA28208@infradead.org>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * __bio_copy_iov - copy all pages between bio and iov_iter
> + * @bio: The &struct bio which describes the I/O
> + * @iter: iov_iter either as source or destination
> + * @to_iov: whether to %READ (0) or %WRITE (1)
> + *
> + * Simple wrapper around __bio_copy_iov_{write,read}().
> + * Returns 0 on success, or the error returned as-is on failure.
> + */
> +static inline int __bio_copy_iov(struct bio *bio, struct iov_iter iter,
> +				 int to_iov)
> +{
> +	if (to_iov == WRITE)
> +		return __bio_copy_iov_write(bio, iter);
> +	else
> +		return __bio_copy_iov_read(bio, iter);
>  }

No need to keep this wrapper..

