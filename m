Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBINGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:06:07 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58693 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaBINGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:06:05 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 9 Feb 2014 05:05:53 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 04/21] fs: Add prototype declaration to appropriate
 header file include/linux/bio.h
Message-ID: <20140209130553.GC30767@leaf>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <74e55f4ccf256d3cc51f377d39e6395f58cb1617.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <74e55f4ccf256d3cc51f377d39e6395f58cb1617.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 06:30:39PM +0530, Rashika Kheria wrote:
> Add prototype declaration to header file include/linux/bio.h because it
> is used by more than one file.
> 
> This eliminates the following warning in bio-integrity.c:
> fs/bio-integrity.c:214:14: warning: no previous prototype for ‘bio_integrity_tag_size’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> Some of the API functions like bio_integrity_tag_size appears to be
> entirely unused. Such occurences should be pruned because they haven't
> been used in any driver.
> 
>  include/linux/bio.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 7065452..d6791bb 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -332,6 +332,7 @@ extern struct bio *bio_clone_fast(struct bio *, gfp_t, struct bio_set *);
>  extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
>  
>  extern struct bio_set *fs_bio_set;
> +unsigned int bio_integrity_tag_size(struct bio *bio);
>  
>  static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
>  {
> -- 
> 1.7.9.5
> 
