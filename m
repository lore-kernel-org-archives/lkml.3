Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3KECXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:23:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:35680 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab3KECXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:23:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403660990"
Message-ID: <527856B6.8030901@intel.com>
Date: Tue, 05 Nov 2013 10:23:50 +0800
From: Aaron Lu <aaron.lu@intel.com>
Organization: Intel, Shanghai, PRC
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 1/2] libata: use sleep instead of standby command
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
In-Reply-To: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+linux-ide

On 11/05/2013 08:52 AM, Phillip Susi wrote:
> The ATA SLEEP mode saves some more power than SUSPEND, and
> has basically the same recovery time, so use it instead.

I suppose this is mainly for runtime PM? Since for system
suspend/hibernation, the disk and its controller will be powered off
anyway.

Best regards,
Aaron

> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> ---
>  drivers/ata/libata-scsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 97a0cef..79b75fd 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1362,8 +1362,8 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
>  		     system_entering_hibernation())
>  			goto skip;
>  
> -		/* Issue ATA STANDBY IMMEDIATE command */
> -		tf->command = ATA_CMD_STANDBYNOW1;
> +		/* Issue ATA SLEEP command */
> +		tf->command = ATA_CMD_SLEEP;
>  	}
>  
>  	/*
> 

