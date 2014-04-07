Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaDGMho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:37:44 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33035 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaDGMhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:37:42 -0400
MIME-Version: 1.0
In-Reply-To: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
References: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
Date: Mon, 7 Apr 2014 15:37:41 +0300
Message-ID: <CABeAxadUHD9wdyJQs0V4bC+pbXSutssBaY7wXSs1bVVqbD_DQA@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
From: Matei Oprea <eu@opreamatei.ro>
To: jbottomley@parallels.com
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this ?
ᐧ

On Tue, Mar 18, 2014 at 10:51 PM, Matei Oprea <eu@opreamatei.ro> wrote:
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
>         }
>
>         if (!phba->sli.ring)
> -               phba->sli.ring = (struct lpfc_sli_ring *)
> -                       kzalloc(LPFC_SLI3_MAX_RING *
> +               phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
>                         sizeof(struct lpfc_sli_ring), GFP_KERNEL);
> +
>         if (!phba->sli.ring)
>                 return -ENOMEM;
>
> --
> 1.7.9.5
>



-- 
Oprea Matei
