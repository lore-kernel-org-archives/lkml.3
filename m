Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaD1Lta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:49:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaD1Lt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:49:29 -0400
Date: Mon, 28 Apr 2014 04:49:27 -0700
From: hch <hch@infradead.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jack <jack@suse.cz>,
        hch <hch@infradead.org>, Viro <viro@zeniv.linux.org.uk>,
        tytso <tytso@mit.edu>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 1/2] FS: Add generic data flush to fsync
Message-ID: <20140428114927.GB9522@infradead.org>
References: <20140426005424.9268324f9911e60a0e20cb59@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140426005424.9268324f9911e60a0e20cb59@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (flush == true) {
> +		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
> +					 NULL);
> +		if (ret == 0)
> +			ret = err;
> +	}
> +
>  out:
>  	mutex_unlock(&inode->i_mutex);

There is no need to have the cache flush under i_mutex, and thus there's
also no need to have the parameter, as the flush can be done in
generic_file_fsync.

