Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaG1Obh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbaG1Obc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:31:32 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: bsg.c:  Cleaning up missing null-terminate in conjunction with strncpy
References: <1406383665-1670-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 28 Jul 2014 10:31:09 -0400
In-Reply-To: <1406383665-1670-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 26 Jul 2014 16:07:45 +0200")
Message-ID: <x49sillpnbm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  block/bsg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/bsg.c b/block/bsg.c
> index ff46add..b2688c5 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -790,7 +790,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
>  	mutex_lock(&bsg_mutex);
>  	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
>  
> -	strncpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name) - 1);
> +	strlcpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name));
>  	dprintk("bound to <%s>, max queue %d\n",
>  		format_dev_t(buf, inode->i_rdev), bd->max_queue);

NACK

The bsg data structure is allocated using kzalloc, so that last byte
will be zero.
