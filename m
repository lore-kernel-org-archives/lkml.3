Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaBDMBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:01:22 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48985 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaBDMBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:01:20 -0500
Message-ID: <52F0D683.4000205@gmail.com>
Date: Tue, 04 Feb 2014 13:01:07 +0100
From: Jack Wang <xjtuwjp@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, lindar_liu@usish.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 16/22] pm8001: Fix invalid success return when request_irq()
 failed
References: <cover.1391512266.git.agordeev@redhat.com> <f724cdc95b9e1eb578cf7297ad32b830885f681c.1391512266.git.agordeev@redhat.com>
In-Reply-To: <f724cdc95b9e1eb578cf7297ad32b830885f681c.1391512266.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 12:17 PM, Alexander Gordeev wrote:
> When enabling MSI-X if a call to request_irq() failed
> pm8001_setup_msix() still returns success. This udate
> fixes the described misbehaviour.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: xjtuwjp@gmail.com
> Cc: lindar_liu@usish.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/pm8001/pm8001_init.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 73a120d..efffbb9 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -739,9 +739,10 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>  			pm8001_ha->irq_vector[i].irq_id = i;
>  			pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
>  
> -			if (request_irq(pm8001_ha->msix_entries[i].vector,
> +			rc = request_irq(pm8001_ha->msix_entries[i].vector,
>  				pm8001_interrupt_handler_msix, flag,
> -				intr_drvname[i], &(pm8001_ha->irq_vector[i]))) {
> +				intr_drvname[i], &(pm8001_ha->irq_vector[i]));
> +			if (rc) {
>  				for (j = 0; j < i; j++)
>  					free_irq(
>  					pm8001_ha->msix_entries[j].vector,
> 
Thanks, looks fine.
Acked-by: Jack Wang <xjtuwjp@gmail.com>
