Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3JaVrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 17:47:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3JaVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 17:47:12 -0400
Date: Thu, 31 Oct 2013 14:47:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] lib/scatterlist: export sg_miter_skip()
Message-Id: <20131031144710.05c08d4a3258098af9312781@linux-foundation.org>
In-Reply-To: <1383062842-28453-1-git-send-email-ming.lei@canonical.com>
References: <1383062842-28453-1-git-send-email-ming.lei@canonical.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013 00:07:22 +0800 Ming Lei <ming.lei@canonical.com> wrote:

> sg_copy_buffer() can't meet demand for some drrivers(such usb
> mass storage), so we have to use the sg_miter_* APIs to access
> sg buffer, then need export sg_miter_skip() for these drivers.
> 
> The API is needed for converting to sg_miter_* APIs in USB storage
> driver for accessing sg buffer.
> 
> ...
>
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -345,6 +345,7 @@ struct sg_mapping_iter {
>  
>  void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
>  		    unsigned int nents, unsigned int flags);
> +bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset);
>  bool sg_miter_next(struct sg_mapping_iter *miter);
>  void sg_miter_stop(struct sg_mapping_iter *miter);
>  
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index d16fa29..3a8e8e8 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -495,7 +495,7 @@ static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
>   *   true if @miter contains the valid mapping.  false if end of sg
>   *   list is reached.
>   */
> -static bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset)
> +bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset)
>  {
>  	sg_miter_stop(miter);
>  
> @@ -513,6 +513,7 @@ static bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset)
>  
>  	return true;
>  }
> +EXPORT_SYMBOL(sg_miter_skip);
>  
>  /**
>   * sg_miter_next - proceed mapping iterator to the next mapping

Looks OK to me.  Please include this in whatever tree is used to merge
"[PATCH 2/2] USB: storage: use sg_miter_* APIs to access scsi buffer".

