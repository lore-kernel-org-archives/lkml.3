Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab3CZSLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:11:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949Ab3CZSLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:11:09 -0400
Date: Tue, 26 Mar 2013 11:11:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 26/27] block: Add an explicit bio flag for bios that own
 their bvec
Message-Id: <20130326111106.dc255f73804de1f8577fea52@linux-foundation.org>
In-Reply-To: <1361319761-23873-27-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
	<1361319761-23873-27-git-send-email-koverstreet@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013 16:22:40 -0800 Kent Overstreet <koverstreet@google.com> wrote:

> This is for the new bio splitting code. When we split a bio, if the
> split occured on a bvec boundry we reuse the bvec for the new bio. But
> that means bio_free() can't free it, hence the explicit flag.
> 
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -117,6 +117,7 @@ struct bio {
>   * BIO_POOL_IDX()
>   */
>  #define BIO_RESET_BITS	12
> +#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
>  
>  #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))

The BIO_OWNS_VEC definition seems to be in the wrong place - it should
be grouped with the "bio flags" group above?

