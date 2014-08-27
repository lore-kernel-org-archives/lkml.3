Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878AbaH0OHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:07:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583AbaH0OHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:07:14 -0400
Message-ID: <53FDE610.5070309@suse.de>
Date: Wed, 27 Aug 2014 16:07:12 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
CC: linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 06/10] scsi/sd: Delete extra scsi_show_extd_sense()
 in sd_print_sense_hdr()
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115019.6768.99063.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140808115019.6768.99063.stgit@yuno-kbuild.novalocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
> sd_print_sense_hdr() calls scsi_show_extd_sense(),
> but scsi_print_sense_hdr() also calls scsi_show_extd_sense().
> We can get same result, so we delete it.
>
> Note:
> Calling scsi_show_extd_sense() is introduced in fdd8b297.
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>   drivers/scsi/sd.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8d7204a..22dd214 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3286,8 +3286,6 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
>   			       struct scsi_sense_hdr *sshdr)
>   {
>   	scsi_print_sense_hdr(sdkp->device, sdkp->disk->disk_name, sshdr);
> -	scsi_show_extd_sense(sdkp->device, sdkp->disk->disk_name,
> -			     sshdr->asc, sshdr->ascq);
>   }
>
>   static void sd_print_result(struct scsi_disk *sdkp, int result)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
A similar patch has been applied to my scsi-logging tree.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
