Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaFDQob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:44:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaFDQoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:44:17 -0400
Subject: Re: [PATCH] sd: bad return code of init_sd
From: Ewan Milne <emilne@redhat.com>
Reply-To: emilne@redhat.com
To: =?ISO-8859-1?Q?Cl=E9ment?= Calmels <clement.calmels@free.fr>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1401831265-8547-1-git-send-email-clement.calmels@free.fr>
References: <1401831265-8547-1-git-send-email-clement.calmels@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 04 Jun 2014 12:44:11 -0400
Message-ID: <1401900251.26039.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 23:34 +0200, Clément Calmels wrote:
> In init_sd function, if kmem_cache_create or mempool_create_slab_pools
> calls fail, the error will not be correclty reported because
> class_register previously set the value of err to 0.
> 
> Signed-off-by: Clément Calmels <clement.calmels@free.fr>
> ---
>  drivers/scsi/sd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e9689d5..7daa2aa 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3205,12 +3205,14 @@ static int __init init_sd(void)
>  					 0, 0, NULL);
>  	if (!sd_cdb_cache) {
>  		printk(KERN_ERR "sd: can't init extended cdb cache\n");
> +		err = -ENOMEM;
>  		goto err_out_class;
>  	}
>  
>  	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
>  	if (!sd_cdb_pool) {
>  		printk(KERN_ERR "sd: can't init extended cdb pool\n");
> +		err = -ENOMEM;
>  		goto err_out_cache;
>  	}
>  

I posted this same patch on 2/14/2013.  Thanks for reminding me!

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


