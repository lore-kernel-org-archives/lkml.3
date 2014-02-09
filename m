Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBINF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:05:28 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46548 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaBINF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:05:26 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 9 Feb 2014 05:05:18 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 03/21] fs: Mark function as static in fs/bio-integrity.c
Message-ID: <20140209130517.GB30767@leaf>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <3e778679e08fc73189ffaf4233fde057a0e75e68.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3e778679e08fc73189ffaf4233fde057a0e75e68.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 06:22:53PM +0530, Rashika Kheria wrote:
> Mark functions as static in bio-integrity.c because it is not used
> outside this file.
> 
> This eliminates the following warnings in bio-integrity.c:
> fs/bio-integrity.c:224:5: warning: no previous prototype for ‘bio_integrity_tag’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  fs/bio-integrity.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index 0bad24d..51d15ae 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -226,7 +226,8 @@ unsigned int bio_integrity_tag_size(struct bio *bio)
>  }
>  EXPORT_SYMBOL(bio_integrity_tag_size);
>  
> -int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len, int set)
> +static int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len,
> +			     int set)
>  {
>  	struct bio_integrity_payload *bip = bio->bi_integrity;
>  	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
> -- 
> 1.7.9.5
> 
