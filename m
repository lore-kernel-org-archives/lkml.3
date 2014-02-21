Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaBUPDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:03:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbaBUPDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:03:41 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/direct-io: remove redundant comparison
References: <530726BB.1040308@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 21 Feb 2014 10:03:29 -0500
In-Reply-To: <530726BB.1040308@cn.fujitsu.com> (Gu Zheng's message of "Fri, 21
	Feb 2014 18:13:15 +0800")
Message-ID: <x49ob20a4ou.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> The return value of bio_get_nr_vecs() can not bigger than BIO_MAX_PAGES,
> so we can remove redundant the comparison between nr_pages and
> BIO_MAX_PAGES.

Yeah, commit f908ee94 (bio allocation failure due to bio_get_nr_vecs())
added that bounding.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/direct-io.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 160a548..6e6bff3 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -664,7 +664,6 @@ static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
>  		goto out;
>  	sector = start_sector << (sdio->blkbits - 9);
>  	nr_pages = min(sdio->pages_in_io, bio_get_nr_vecs(map_bh->b_bdev));
> -	nr_pages = min(nr_pages, BIO_MAX_PAGES);
>  	BUG_ON(nr_pages <= 0);
>  	dio_bio_alloc(dio, sdio, map_bh->b_bdev, sector, nr_pages);
>  	sdio->boundary = 0;
