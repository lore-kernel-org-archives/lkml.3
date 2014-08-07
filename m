Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaHGVmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaHGVl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:41:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/4] gdrom: fix error return code
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
	<1407445067-4044-2-git-send-email-Julia.Lawall@lip6.fr>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Aug 2014 17:41:54 -0400
In-Reply-To: <1407445067-4044-2-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Thu, 7 Aug 2014 22:57:44 +0200")
Message-ID: <x49wqak9dul.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> index 584bc31..46ecd95 100644
> --- a/drivers/cdrom/gdrom.c
> +++ b/drivers/cdrom/gdrom.c
> @@ -807,16 +807,20 @@ static int probe_gdrom(struct platform_device *devptr)
>  	if (err)
>  		goto probe_fail_cmdirq_register;
>  	gd.gdrom_rq = blk_init_queue(gdrom_request, &gdrom_lock);
> -	if (!gd.gdrom_rq)
> +	if (!gd.gdrom_rq) {
> +		err = -ENOMEM;
>  		goto probe_fail_requestq;
> +	}
>  
>  	err = probe_gdrom_setupqueue();
>  	if (err)
>  		goto probe_fail_toc;
>  
>  	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
> -	if (!gd.toc)
> +	if (!gd.toc) {
> +		err = -ENOMEM;
>  		goto probe_fail_toc;
> +	}

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
