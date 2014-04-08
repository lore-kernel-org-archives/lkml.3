Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaDHGgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:36:10 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42533 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaDHGgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:36:08 -0400
Message-ID: <534398D2.6010008@gmail.com>
Date: Tue, 08 Apr 2014 09:36:02 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matei Oprea <eu@opreamatei.ro>, jbottomley@parallels.com
CC: james.smart@emulex.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
References: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
In-Reply-To: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 10:51 PM, Matei Oprea wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.
> 
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 68c94cc..0a51ca5 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4731,9 +4731,9 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
>  	}
>  
>  	if (!phba->sli.ring)
> -		phba->sli.ring = (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> +		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
>  			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
> +

Just a nit please put this recheck inside the if(){} so in the hot path
when phba->sli.ring is already allocated it will not test twice.

>  	if (!phba->sli.ring)

and unlikely() on this if

>  		return -ENOMEM;
>  
> 

thanks
Boaz

