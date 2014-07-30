Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaG3BX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:23:27 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:45121 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaG3BXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:23:25 -0400
Message-ID: <1406683403.6628.58.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] target/configfs: Remove unnecessary null test
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Tue, 29 Jul 2014 18:23:23 -0700
In-Reply-To: <20140716205953.GA3231@himangi-Dell>
References: <20140716205953.GA3231@himangi-Dell>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi,

On Thu, 2014-07-17 at 02:29 +0530, Himangi Saraogi wrote:
> This patch removes the null test on lun_cg. lun_cg is initialized
> at the beginning of the function to &lun->lun_group. Since lun_cg is
> dereferenced prior to the null test, it must be a valid pointer.
> 
> The following Coccinelle script is used for detecting the change:
> 
> @r@
> expression e,f;
> identifier g,y;
> statement S1,S2;
> @@
> 
> *e = &f->g
> <+...
>  f->y
>  ...+>
> *if (e != NULL || ...)
>  S1 else S2
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/target/target_core_fabric_configfs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 7de9f04..7228a18 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -917,8 +917,7 @@ static struct config_group *target_fabric_make_lun(
>  
>  	return &lun->lun_group;
>  out:
> -	if (lun_cg)
> -		kfree(lun_cg->default_groups);
> +	kfree(lun_cg->default_groups);
>  	return ERR_PTR(errno);
>  }
>  

Thanks, applied to target-pending/for-next.

--nab

