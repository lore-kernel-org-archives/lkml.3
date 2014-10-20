Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaJTGEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:04:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaJTGEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:04:34 -0400
Message-ID: <5444A5F0.2010501@suse.de>
Date: Mon, 20 Oct 2014 08:04:32 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Chandra Seetharaman <sekharan@us.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
CC: Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] scsi_dh_hp_sw: fix return value on failed allocation
References: <1413734404-1426-1-git-send-email-hch@lst.de> <1413734404-1426-6-git-send-email-hch@lst.de>
In-Reply-To: <1413734404-1426-6-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 06:00 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_hp_sw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> index aa40fcb..471ffd1 100644
> --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -363,7 +363,7 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
>  	if (!h) {
>  		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
>  			    HP_SW_NAME);
> -		return 0;
> +		return -ENOMEM;
>  	}
>  
>  	h->dh_data.scsi_dh = &hp_sw_dh;
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
