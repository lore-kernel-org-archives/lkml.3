Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaGNGP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:15:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaGNGPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:15:40 -0400
Message-ID: <53C3758A.7030201@suse.de>
Date: Mon, 14 Jul 2014 08:15:38 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
CC: stable@vger.kernel.org
Subject: Re: [PATCH V3 2/7] Drivers: scsi: storvsc: Set cmd_per_lun to reflect
 value supported by the Host
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <1405183712-23967-2-git-send-email-kys@microsoft.com>
In-Reply-To: <1405183712-23967-2-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> Set cmd_per_lun to reflect value supported by the Host.
> In this version of the patch I have addressed comments from
> Christoph Hellwig <hch@infradead.org>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8938b13..cebcef7 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1690,7 +1690,7 @@ static struct scsi_host_template scsi_driver = {
>   	.slave_alloc =		storvsc_device_alloc,
>   	.slave_destroy =	storvsc_device_destroy,
>   	.slave_configure =	storvsc_device_configure,
> -	.cmd_per_lun =		1,
> +	.cmd_per_lun =		255,
>   	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
>   	.this_id =		-1,
>   	/* no use setting to 0 since ll_blk_rw reset it to 1 */
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
